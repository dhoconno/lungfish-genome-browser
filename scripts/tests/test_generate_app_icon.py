import importlib.util
import unittest
from pathlib import Path

from PIL import Image


PROJECT_ROOT = Path(__file__).resolve().parents[2]
SCRIPT_PATH = PROJECT_ROOT / "scripts" / "generate-app-icon.py"


def load_module():
    spec = importlib.util.spec_from_file_location("generate_app_icon", SCRIPT_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


class GenerateAppIconTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.module = load_module()
        cls.source_logo = Image.open(
            PROJECT_ROOT / "scripts" / "app-icon-source.png"
        ).convert("RGBA")

    def test_extract_brand_mark_recolors_logo_and_clears_tile_background(self):
        mark = self.module.extract_brand_mark(self.source_logo)

        self.assertEqual(mark.size, self.source_logo.size)
        self.assertEqual(mark.getpixel((0, 0))[3], 0)
        self.assertIsNotNone(mark.getbbox())

        orange = self.module.BRAND_COLORS["orange"]
        orange_pixels = sum(1 for pixel in self.module.iter_pixels(mark) if pixel[:3] == orange and pixel[3] > 0)
        self.assertGreater(orange_pixels, 1000)

    def test_create_icon_uses_rounded_transparent_corners_and_brand_palette(self):
        icon = self.module.create_icon(256)

        self.assertEqual(icon.size, (256, 256))
        self.assertEqual(icon.getpixel((0, 0))[3], 0)

        cream = self.module.BRAND_COLORS["cream"]
        background_pixel = icon.getpixel((128, 28))
        self.assertEqual(background_pixel[:3], cream)
        self.assertGreater(background_pixel[3], 0)

        orange = self.module.BRAND_COLORS["orange"]
        orange_pixels = sum(1 for pixel in self.module.iter_pixels(icon) if pixel[:3] == orange and pixel[3] > 0)
        self.assertGreater(orange_pixels, 500)


if __name__ == "__main__":
    unittest.main()
