#!/bin/bash
#
# smoke-test-release-tools.sh
#
# Run tiny smoke tests against the bundled native tools inside a built
# Lungfish.app bundle.

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: smoke-test-release-tools.sh <Lungfish.app> [--portability-only]

Verifies that managed core tools and retired scrubber binaries are not bundled,
scans the packaged app for leaked build/Homebrew paths, and optionally runs
tiny-input smoke tests against the remaining bundled tools.
EOF
}

if [ "$#" -lt 1 ]; then
    usage >&2
    exit 64
fi

APP_PATH="$1"
shift
PORTABILITY_ONLY=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --portability-only)
            PORTABILITY_ONLY=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "unknown argument: $1" >&2
            exit 64
            ;;
    esac
    shift
done

TOOLS_DIR="$APP_PATH/Contents/Resources/LungfishGenomeBrowser_LungfishWorkflow.bundle/Contents/Resources/Tools"
RG_BIN="$(command -v rg || true)"

if [ ! -d "$TOOLS_DIR" ]; then
    echo "tools directory not found: $TOOLS_DIR" >&2
    exit 66
fi

if [ -z "$RG_BIN" ]; then
    echo "missing required command: rg" >&2
    exit 69
fi

if [ -e "$TOOLS_DIR/bbtools" ]; then
    echo "bbtools should not be bundled: $TOOLS_DIR/bbtools" >&2
    exit 66
fi

if [ -e "$TOOLS_DIR/jre" ]; then
    echo "jre should not be bundled: $TOOLS_DIR/jre" >&2
    exit 66
fi

if [ -e "$TOOLS_DIR/fastp" ]; then
    echo "fastp should not be bundled: $TOOLS_DIR/fastp" >&2
    exit 66
fi

if [ -e "$TOOLS_DIR/scrubber/bin/aligns_to" ]; then
    echo "aligns_to should not be bundled: $TOOLS_DIR/scrubber/bin/aligns_to" >&2
    exit 66
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT

cat >"$TMP_DIR/single.fq" <<'EOF'
@r1
ACGTACGT
+
FFFFFFFF
EOF

cat >"$TMP_DIR/r1.fq" <<'EOF'
@pair1/1
ACGTACGT
+
FFFFFFFF
EOF

cat >"$TMP_DIR/r2.fq" <<'EOF'
@pair1/2
ACGTACGT
+
FFFFFFFF
EOF

run_test() {
    local name="$1"
    shift

    if "$@" >"$TMP_DIR/${name}.stdout" 2>"$TMP_DIR/${name}.stderr"; then
        printf 'PASS %s\n' "$name"
    else
        local rc=$?
        printf 'FAIL %s exit=%s\n' "$name" "$rc" >&2
        printf -- '--- stdout ---\n' >&2
        sed -n '1,120p' "$TMP_DIR/${name}.stdout" >&2 || true
        printf -- '--- stderr ---\n' >&2
        sed -n '1,160p' "$TMP_DIR/${name}.stderr" >&2 || true
        exit "$rc"
    fi
}

run_portability_scan() {
    local leak_patterns=(
        "/Users/dho"
        ".build/xcode-cli-release"
        "/opt/homebrew"
        "/opt/homebrew/Cellar"
        "/usr/local/Cellar"
        "/usr/local/Homebrew"
    )

    local pattern
    for pattern in "${leak_patterns[@]}"; do
        if "$RG_BIN" -a -n --fixed-strings "$pattern" "$APP_PATH" >"$TMP_DIR/portability-scan.stderr" 2>&1; then
            printf 'FAIL portability leak=%s\n' "$pattern" >&2
            sed -n '1,120p' "$TMP_DIR/portability-scan.stderr" >&2 || true
            exit 1
        fi
    done

    printf 'PASS portability\n'
}

run_portability_scan

if [ "$PORTABILITY_ONLY" -eq 1 ]; then
    exit 0
fi

run_test samtools "$TOOLS_DIR/samtools" --version
run_test seqkit "$TOOLS_DIR/seqkit" version
