#!/bin/bash
#
# smoke-test-release-tools.sh
#
# Run tiny end-to-end smoke tests against the bundled native tools inside a
# built Lungfish.app bundle.

set -euo pipefail

usage() {
    cat <<'EOF'
Usage: smoke-test-release-tools.sh <Lungfish.app> [--scrubber-db /path/to/human_filter.db]

Runs tiny-input smoke tests against the bundled BBTools wrappers and, when a
human-scrubber database is available, against scrub.sh as well.
EOF
}

if [ "$#" -lt 1 ]; then
    usage >&2
    exit 64
fi

APP_PATH="$1"
shift

SCRUBBER_DB="${LUNGFISH_SCRUBBER_DB:-}"

while [ "$#" -gt 0 ]; do
    case "$1" in
        --scrubber-db)
            shift
            if [ "$#" -eq 0 ]; then
                echo "missing value for --scrubber-db" >&2
                exit 64
            fi
            SCRUBBER_DB="$1"
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
JAVA_HOME_DIR="$TOOLS_DIR/jre"
JAVA_BIN="$TOOLS_DIR/jre/bin/java"
KEYTOOL_BIN="$TOOLS_DIR/jre/bin/keytool"
JSPAWNHELPER_BIN="$TOOLS_DIR/jre/lib/jspawnhelper"
RG_BIN="$(command -v rg || true)"

if [ ! -d "$TOOLS_DIR" ]; then
    echo "tools directory not found: $TOOLS_DIR" >&2
    exit 66
fi

if [ -z "$RG_BIN" ]; then
    echo "missing required command: rg" >&2
    exit 69
fi

for path in "$JAVA_BIN" "$KEYTOOL_BIN" "$JSPAWNHELPER_BIN"; do
    if [ ! -f "$path" ]; then
        echo "missing required bundled JRE executable: $path" >&2
        exit 66
    fi
done

find_scrubber_db() {
    if [ -n "$SCRUBBER_DB" ] && [ -f "$SCRUBBER_DB" ]; then
        printf '%s\n' "$SCRUBBER_DB"
        return 0
    fi

    local candidate
    for candidate in \
        "$HOME/.lungfish/databases/human-scrubber" \
        "$HOME/Library/Application Support/Lungfish/databases/human-scrubber"
    do
        if [ -d "$candidate" ]; then
            local found
            found=$(find "$candidate" -maxdepth 2 -type f -name 'human_filter.db*' | head -n 1 || true)
            if [ -n "$found" ]; then
                printf '%s\n' "$found"
                return 0
            fi
        fi
    done

    return 1
}

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

run_bbtools_test() {
    local name="$1"
    shift

    run_test "$name" \
        env \
        "PATH=$JAVA_HOME_DIR/bin:$PATH" \
        "JAVA_HOME=$JAVA_HOME_DIR" \
        "BBMAP_JAVA=$JAVA_BIN" \
        "$@"
}

run_portability_scan() {
    local leak_patterns=(
        "/Users/dho"
        ".build/xcode-cli-release"
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

run_java_entitlement_scan() {
    local candidate
    for candidate in "$JAVA_BIN" "$KEYTOOL_BIN" "$JSPAWNHELPER_BIN"; do
        if ! /usr/bin/codesign -d --entitlements :- "$candidate" 2>&1 | /usr/bin/grep -q "allow-jit"; then
            printf 'FAIL java-entitlements missing allow-jit for %s\n' "$candidate" >&2
            /usr/bin/codesign -d --entitlements :- "$candidate" 2>&1 | sed -n '1,120p' >&2 || true
            exit 1
        fi
    done

    printf 'PASS java-entitlements\n'
}

run_portability_scan
run_java_entitlement_scan

run_test java "$JAVA_BIN" -version

run_bbtools_test reformat \
    "$TOOLS_DIR/bbtools/reformat.sh" \
    in="$TMP_DIR/single.fq" \
    out="$TMP_DIR/reformat.fq" \
    ow=t

run_bbtools_test bbduk \
    "$TOOLS_DIR/bbtools/bbduk.sh" \
    in="$TMP_DIR/single.fq" \
    out="$TMP_DIR/bbduk-out.fq" \
    outm="$TMP_DIR/bbduk-match.fq" \
    literal=TTTT \
    k=4 \
    hdist=0 \
    ow=t

run_bbtools_test clumpify \
    "$TOOLS_DIR/bbtools/clumpify.sh" \
    in="$TMP_DIR/single.fq" \
    out="$TMP_DIR/clumpify.fq" \
    ow=t \
    groups=1

run_bbtools_test bbmerge \
    "$TOOLS_DIR/bbtools/bbmerge.sh" \
    in1="$TMP_DIR/r1.fq" \
    in2="$TMP_DIR/r2.fq" \
    out="$TMP_DIR/bbmerge.fq" \
    outu1="$TMP_DIR/bbmerge-u1.fq" \
    outu2="$TMP_DIR/bbmerge-u2.fq" \
    ow=t

run_bbtools_test repair \
    "$TOOLS_DIR/bbtools/repair.sh" \
    in1="$TMP_DIR/r1.fq" \
    in2="$TMP_DIR/r2.fq" \
    out="$TMP_DIR/repair1.fq" \
    out2="$TMP_DIR/repair2.fq" \
    outs="$TMP_DIR/repair-singles.fq" \
    ow=t

run_bbtools_test tadpole \
    "$TOOLS_DIR/bbtools/tadpole.sh" \
    in="$TMP_DIR/single.fq" \
    out="$TMP_DIR/tadpole.fa" \
    k=3 \
    ow=t \
    prealloc=f \
    mincount=1 \
    shave=f \
    rinse=f \
    pop=f

if SCRUBBER_DB=$(find_scrubber_db); then
    run_test scrub \
        "$TOOLS_DIR/scrubber/scripts/scrub.sh" \
        -i "$TMP_DIR/single.fq" \
        -o "$TMP_DIR/scrub.fq" \
        -d "$SCRUBBER_DB"
else
    printf 'SKIP scrub (no installed human_filter.db found)\n'
fi
