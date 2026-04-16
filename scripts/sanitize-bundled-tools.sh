#!/bin/bash
#
# sanitize-bundled-tools.sh
#
# Release packaging helper that removes executable permissions from copied tool
# resources that are not actual macOS executables or explicitly launched
# wrapper scripts.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

usage() {
    echo "Usage: $0 <path> [<path> ...]" >&2
}

if [ "$#" -lt 1 ]; then
    usage
    exit 64
fi

remove_build_only_files() {
    local tools_dir="$1"
    local relative_path
    for relative_path in \
        "bbtools/build_env_setup.sh" \
        "bbtools/conda_build.sh"
    do
        local path="$tools_dir/$relative_path"
        if [ -e "$path" ]; then
            rm -f "$path"
        fi
    done
}

is_allowlisted_script() {
    case "$1" in
        bbtools/clumpify.sh|\
        bbtools/bbduk.sh|\
        bbtools/bbmerge.sh|\
        bbtools/repair.sh|\
        bbtools/tadpole.sh|\
        bbtools/reformat.sh|\
        scrubber/scripts/scrub.sh|\
        scrubber/scripts/cut_spots_fastq.py|\
        scrubber/scripts/fastq_to_fasta.py)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

rewrite_embedded_path_prefix() {
    local path="$1"
    local source_prefix="$2"
    local replacement_prefix="$3"

    if [ -z "$source_prefix" ]; then
        return
    fi

    SOURCE_PREFIX="$source_prefix" REPLACEMENT_PREFIX="$replacement_prefix" perl -0pi -e '
        use strict;
        use warnings;
        use bytes;

        my $source = $ENV{SOURCE_PREFIX};
        my $replacement = $ENV{REPLACEMENT_PREFIX};

        if (length($replacement) > length($source)) {
            die "replacement is longer than source prefix\n";
        }

        my $padded = $replacement . ("\0" x (length($source) - length($replacement)));
        s/\Q$source\E/$padded/g;
    ' "$path"
}

rewrite_embedded_builder_paths() {
    local path="$1"

    rewrite_embedded_path_prefix \
        "$path" \
        "${PROJECT_ROOT}/.build/xcode-cli-release/" \
        "/swiftpm-build/"
    rewrite_embedded_path_prefix \
        "$path" \
        "/workspace/.build/xcode-cli-release/" \
        "/swiftpm-build/"
    rewrite_embedded_path_prefix \
        "$path" \
        "${PROJECT_ROOT}/.build/tools/" \
        "/lungfish-tools-build/"
    rewrite_embedded_path_prefix \
        "$path" \
        "/workspace/.build/tools/" \
        "/lungfish-tools-build/"
    rewrite_embedded_path_prefix \
        "$path" \
        "${PROJECT_ROOT}/" \
        "/workspace/"
    rewrite_embedded_path_prefix \
        "$path" \
        "/Users/dho/Documents/ncbi-vdb/" \
        "/ncbi-vdb-src/"
}

sanitize_file() {
    local path="$1"
    local root="$2"
    local relative_path
    if [ -n "$root" ] && [ "$path" != "$root" ]; then
        relative_path="${path#"$root"/}"
    else
        relative_path="$(basename "$path")"
    fi

    if is_allowlisted_script "$relative_path"; then
        chmod 755 "$path"
        return
    fi

    if [ ! -x "$path" ]; then
        return
    fi

    local file_type
    file_type=$(/usr/bin/file -b "$path")

    case "$file_type" in
        Mach-O*)
            rewrite_embedded_builder_paths "$path"
            chmod 755 "$path"
            ;;
        *)
            chmod 644 "$path"
            ;;
    esac
}

sanitize_target() {
    local target="$1"

    if [ ! -e "$target" ]; then
        return
    fi

    if [ -d "$target" ]; then
        remove_build_only_files "$target"
        while IFS= read -r -d '' path; do
            sanitize_file "$path" "$target"
        done < <(/usr/bin/find "$target" -type f -print0)
        return
    fi

    if [ -f "$target" ]; then
        sanitize_file "$target" "$(dirname "$target")"
    fi
}

for target in "$@"; do
    sanitize_target "$target"
done
