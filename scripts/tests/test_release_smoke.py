import os
import subprocess
import tempfile
import unittest
from pathlib import Path


class ReleaseSmokeTests(unittest.TestCase):
    def setUp(self):
        self.root = Path(__file__).resolve().parents[2]
        self.script = self.root / "scripts" / "smoke-test-release-tools.sh"

    def test_smoke_test_fails_when_app_icon_resource_is_missing(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            app_path = self._make_minimal_app(Path(temp_dir))

            result = subprocess.run(
                ["/bin/bash", str(self.script), str(app_path), "--portability-only"],
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
            )

            self.assertNotEqual(result.returncode, 0)
            self.assertIn("app icon missing", result.stderr)

    def test_smoke_test_accepts_app_icon_resource_and_metadata(self):
        with tempfile.TemporaryDirectory() as temp_dir:
            app_path = self._make_minimal_app(Path(temp_dir), include_icon=True)

            result = subprocess.run(
                ["/bin/bash", str(self.script), str(app_path), "--portability-only"],
                text=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.PIPE,
                check=False,
            )

            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertIn("PASS portability", result.stdout)

    def _make_minimal_app(self, root, include_icon=False):
        app_path = root / "Lungfish.app"
        resources = app_path / "Contents" / "Resources"
        tools = resources / "LungfishGenomeBrowser_LungfishWorkflow.bundle" / "Tools"
        tools.mkdir(parents=True)

        info_plist = app_path / "Contents" / "Info.plist"
        info_plist.parent.mkdir(parents=True, exist_ok=True)
        info_plist.write_text(
            """<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>CFBundleIconName</key>
    <string>AppIcon</string>
</dict>
</plist>
""",
            encoding="utf-8",
        )

        micromamba = tools / "micromamba"
        micromamba.write_text("#!/bin/sh\necho micromamba 1.0\n", encoding="utf-8")
        os.chmod(micromamba, 0o755)
        (tools / "tool-versions.json").write_text('{"tools":[{"name": "micromamba"}]}\n', encoding="utf-8")
        (tools / "VERSIONS.txt").write_text("- micromamba: 1.0\n", encoding="utf-8")

        if include_icon:
            (resources / "AppIcon.icns").write_bytes(b"icns")

        return app_path


if __name__ == "__main__":
    unittest.main()
