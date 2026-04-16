#!/usr/bin/env bash
# setup-worktree.sh — hydrate gitignored runtime assets into a worktree build.

set -euo pipefail

usage() {
    cat <<'EOF' >&2
Usage: setup-worktree.sh [--source-root PATH] <target-root>

Copies gitignored runtime dylibs into the target tree and symlinks ignored
database payloads from a source checkout. If --source-root is omitted, the
script prefers the primary checkout reported by `git worktree list`.
EOF
}

TARGET_ROOT=""
SOURCE_ROOT=""

while [ "$#" -gt 0 ]; do
    case "$1" in
        --source-root)
            if [ "$#" -lt 2 ]; then
                usage
                exit 64
            fi
            SOURCE_ROOT="$2"
            shift 2
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown argument: $1" >&2
            usage
            exit 64
            ;;
        *)
            if [ -n "$TARGET_ROOT" ]; then
                echo "Only one target root may be provided." >&2
                usage
                exit 64
            fi
            TARGET_ROOT="$1"
            shift
            ;;
    esac
done

if [ -z "$TARGET_ROOT" ]; then
    usage
    exit 64
fi

if [ ! -d "$TARGET_ROOT" ]; then
    echo "Error: target root does not exist: $TARGET_ROOT" >&2
    exit 66
fi

TARGET_ROOT="$(cd "$TARGET_ROOT" && pwd)"

discover_source_root() {
    local target_root="$1"
    local repo_root

    if ! repo_root=$(/usr/bin/git -C "$target_root" rev-parse --show-toplevel 2>/dev/null); then
        return 1
    fi
    repo_root="$(cd "$repo_root" && pwd)"

    local primary_root=""
    local line
    while IFS= read -r line; do
        case "$line" in
            worktree\ *)
                local candidate="${line#worktree }"
                if [ -d "$candidate" ]; then
                    candidate="$(cd "$candidate" && pwd)"
                    if [ -z "$primary_root" ]; then
                        primary_root="$candidate"
                    fi
                fi
                ;;
        esac
    done < <(/usr/bin/git -C "$repo_root" worktree list --porcelain 2>/dev/null || true)

    if [ -n "$primary_root" ]; then
        if [ "$target_root" = "$primary_root" ]; then
            printf '%s\n' "$target_root"
        else
            printf '%s\n' "$primary_root"
        fi
        return 0
    fi

    printf '%s\n' "$repo_root"
}

if [ -n "$SOURCE_ROOT" ]; then
    if [ ! -d "$SOURCE_ROOT" ]; then
        echo "Error: source root does not exist: $SOURCE_ROOT" >&2
        exit 66
    fi
    SOURCE_ROOT="$(cd "$SOURCE_ROOT" && pwd)"
else
    if ! SOURCE_ROOT="$(discover_source_root "$TARGET_ROOT")"; then
        echo "Error: could not infer a source checkout for $TARGET_ROOT" >&2
        exit 69
    fi
fi

copy_count=0
link_count=0

copy_runtime_files() {
    local source_dir="$1"
    local target_dir="$2"
    shift 2

    [ -d "$source_dir" ] || return

    local source_path relative_path target_path
    while IFS= read -r -d '' source_path; do
        relative_path="${source_path#"$source_dir"/}"
        target_path="$target_dir/$relative_path"

        /bin/mkdir -p "$(dirname "$target_path")"

        if [ -L "$target_path" ]; then
            /bin/rm -f "$target_path"
        elif [ -f "$target_path" ] && /usr/bin/cmp -s "$source_path" "$target_path"; then
            continue
        fi

        /bin/rm -f "$target_path"
        /bin/cp -p "$source_path" "$target_path"
        copy_count=$((copy_count + 1))
    done < <(/usr/bin/find "$source_dir" -type f \( "$@" \) -print0)
}

link_runtime_files() {
    local source_dir="$1"
    local target_dir="$2"
    shift 2

    [ -d "$source_dir" ] || return

    local source_path relative_path target_path existing_link
    while IFS= read -r -d '' source_path; do
        relative_path="${source_path#"$source_dir"/}"
        target_path="$target_dir/$relative_path"

        /bin/mkdir -p "$(dirname "$target_path")"

        existing_link=""
        if [ -L "$target_path" ]; then
            existing_link="$(readlink "$target_path" || true)"
        fi

        if [ "$existing_link" = "$source_path" ]; then
            continue
        fi

        /bin/rm -f "$target_path"
        /bin/ln -s "$source_path" "$target_path"
        link_count=$((link_count + 1))
    done < <(/usr/bin/find "$source_dir" -type f \( "$@" \) -print0)
}

echo "Hydrating runtime resources into: $TARGET_ROOT"
echo "Using source root: $SOURCE_ROOT"

if [ "$SOURCE_ROOT" != "$TARGET_ROOT" ]; then
    copy_runtime_files \
        "$SOURCE_ROOT/Sources/LungfishWorkflow/Resources/Tools" \
        "$TARGET_ROOT/Sources/LungfishWorkflow/Resources/Tools" \
        -name "*.dylib"
    link_runtime_files \
        "$SOURCE_ROOT/Sources/LungfishWorkflow/Resources/Databases" \
        "$TARGET_ROOT/Sources/LungfishWorkflow/Resources/Databases" \
        -name "*.db" -o -name "*.db.*"
fi

echo "Copied $copy_count runtime file(s)"
echo "Linked $link_count runtime file(s)"
echo "Worktree setup complete."
