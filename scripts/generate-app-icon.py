#!/usr/bin/env python3
"""
Generate Lungfish Genome Browser app icon.
Creates all required PNG sizes and assembles into .icns file.

Based on APP-ICON-DESIGN-SPECIFICATION.md
"""

import os
import math
from PIL import Image, ImageDraw, ImageFilter

# Color palette from design spec
COLORS = {
    'teal_dark': (0, 122, 140),       # #007A8C
    'teal': (0, 160, 176),            # #00A0B0
    'teal_light': (0, 196, 217),      # #00C4D9
    'teal_bright': (77, 217, 230),    # #4DD9E6
    'background_dark': (26, 47, 58),  # #1A2F3A
    'background_neutral': (46, 74, 90), # #2E4A5A
    'gear_silver': (139, 163, 176),   # #8BA3B0
    'white': (255, 255, 255),
}

def create_gradient_background(size, color1, color2):
    """Create a vertical gradient background."""
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    for y in range(size):
        # Interpolate between colors
        ratio = y / size
        r = int(color1[0] * (1 - ratio) + color2[0] * ratio)
        g = int(color1[1] * (1 - ratio) + color2[1] * ratio)
        b = int(color1[2] * (1 - ratio) + color2[2] * ratio)
        draw.line([(0, y), (size, y)], fill=(r, g, b, 255))

    return img

def draw_rounded_rect(draw, bounds, radius, fill):
    """Draw a rounded rectangle."""
    x1, y1, x2, y2 = bounds
    draw.rounded_rectangle(bounds, radius=radius, fill=fill)

def draw_circle(draw, center, radius, fill=None, outline=None, width=1):
    """Draw a circle."""
    x, y = center
    draw.ellipse(
        [x - radius, y - radius, x + radius, y + radius],
        fill=fill,
        outline=outline,
        width=width
    )

def draw_lungfish_silhouette(draw, center, size, color):
    """
    Draw a stylized lungfish silhouette.
    The lungfish is depicted as an elegant curved fish shape.
    """
    cx, cy = center
    scale = size / 100  # Base design at 100px

    # Lungfish body - elegant elongated S-curve shape
    # The lungfish has a distinctive elongated body with lobed fins

    # Main body curve points (scaled)
    body_points = [
        # Head (left side, rounded)
        (cx - 35*scale, cy),
        (cx - 38*scale, cy - 8*scale),
        (cx - 35*scale, cy - 15*scale),
        (cx - 25*scale, cy - 18*scale),
        # Upper body curve
        (cx - 10*scale, cy - 15*scale),
        (cx + 5*scale, cy - 12*scale),
        (cx + 20*scale, cy - 8*scale),
        # Tail section (upper)
        (cx + 35*scale, cy - 5*scale),
        (cx + 42*scale, cy - 15*scale),  # Tail tip upper
        (cx + 38*scale, cy),              # Tail center
        # Tail section (lower)
        (cx + 42*scale, cy + 15*scale),  # Tail tip lower
        (cx + 35*scale, cy + 5*scale),
        # Lower body curve
        (cx + 20*scale, cy + 8*scale),
        (cx + 5*scale, cy + 12*scale),
        (cx - 10*scale, cy + 15*scale),
        (cx - 25*scale, cy + 18*scale),
        # Back to head
        (cx - 35*scale, cy + 15*scale),
        (cx - 38*scale, cy + 8*scale),
        (cx - 35*scale, cy),
    ]

    # Draw the body as a polygon
    draw.polygon(body_points, fill=color)

    # Eye position - will be filled with virus outline later
    # Store eye coordinates for external use
    eye_x = cx - 28*scale
    eye_y = cy - 5*scale
    eye_radius = 3*scale

    # Draw white background for eye
    draw_circle(draw, (eye_x, eye_y), eye_radius, fill=COLORS['white'])

    # Pectoral fin (lobed fin characteristic of lungfish)
    fin_points = [
        (cx - 15*scale, cy + 5*scale),
        (cx - 20*scale, cy + 18*scale),
        (cx - 8*scale, cy + 15*scale),
        (cx - 5*scale, cy + 8*scale),
    ]
    draw.polygon(fin_points, fill=color)

def draw_virus_outline(draw, center, radius, color, spikes=12):
    """Draw a stylized virus outline with spike proteins."""
    cx, cy = center
    inner_radius = radius * 0.5
    spike_length = radius * 0.5
    spike_ball_radius = radius * 0.15

    # Draw spike proteins radiating outward
    for i in range(spikes):
        angle = (2 * math.pi * i) / spikes
        # Spike line from inner circle to outer ball
        inner_x = cx + inner_radius * math.cos(angle)
        inner_y = cy + inner_radius * math.sin(angle)
        outer_x = cx + (inner_radius + spike_length) * math.cos(angle)
        outer_y = cy + (inner_radius + spike_length) * math.sin(angle)

        # Draw spike line
        draw.line([(inner_x, inner_y), (outer_x, outer_y)], fill=color, width=max(1, int(radius * 0.08)))

        # Draw spike ball at end
        draw_circle(draw, (outer_x, outer_y), spike_ball_radius, fill=color)

    # Draw central virus body (circle outline)
    draw_circle(draw, center, inner_radius, outline=color, width=max(1, int(radius * 0.1)))

def create_icon(size, include_virus_eye=True, simplified=False):
    """
    Create the app icon at the specified size.

    Args:
        size: Output size in pixels
        include_virus_eye: Whether to include the virus outline in the eye
        simplified: Use simplified design for small sizes
    """
    # Create canvas with transparency
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Calculate dimensions
    padding = size * 0.05
    icon_size = size - (2 * padding)
    center = size / 2

    # Background: rounded rectangle with gradient
    corner_radius = size * 0.22  # macOS squircle corner radius

    # Create gradient background
    bg = create_gradient_background(size, COLORS['background_dark'], COLORS['background_neutral'])

    # Apply rounded corners by masking
    mask = Image.new('L', (size, size), 0)
    mask_draw = ImageDraw.Draw(mask)
    mask_draw.rounded_rectangle([0, 0, size-1, size-1], radius=corner_radius, fill=255)

    # Apply mask to background
    bg.putalpha(mask)
    img = Image.alpha_composite(img, bg)
    draw = ImageDraw.Draw(img)

    # Draw circular container for the logo
    circle_radius = icon_size * 0.38
    circle_center = (center, center)

    # Circle background with gradient effect
    # Outer glow
    glow_color = (*COLORS['teal_dark'], 100)
    for i in range(3):
        r = circle_radius + (3 - i) * (size * 0.01)
        draw_circle(draw, circle_center, r, fill=(*COLORS['teal_dark'], 30 + i * 20))

    # Main circle with teal gradient
    draw_circle(draw, circle_center, circle_radius, fill=COLORS['teal'])

    # Inner highlight (top)
    highlight_y_offset = -circle_radius * 0.15
    highlight_radius = circle_radius * 0.85
    # Create a subtle highlight arc at top

    # Draw lungfish silhouette
    fish_size = circle_radius * 1.6
    if simplified:
        fish_size = circle_radius * 1.8
    draw_lungfish_silhouette(draw, circle_center, fish_size, COLORS['teal_bright'])

    # Draw virus outline in the eye (only for larger sizes where it's visible)
    if include_virus_eye and size >= 64:
        # Calculate eye position based on fish position
        scale = fish_size / 100
        eye_x = center - 28 * scale
        eye_y = center - 5 * scale
        eye_radius = 3 * scale

        # Draw virus outline in a dark teal color for contrast against white eye
        virus_radius = eye_radius * 0.8
        virus_color = COLORS['teal_dark']
        draw_virus_outline(draw, (eye_x, eye_y), virus_radius, virus_color, spikes=8)

    # Add subtle highlight on circle edge (top-left)
    if size >= 128:
        # Top-left arc highlight
        highlight_start = center - circle_radius * 0.9
        arc_bounds = [
            center - circle_radius + size * 0.02,
            center - circle_radius + size * 0.02,
            center + circle_radius - size * 0.02,
            center + circle_radius - size * 0.02
        ]
        # Simple highlight dot
        draw_circle(
            draw,
            (center - circle_radius * 0.5, center - circle_radius * 0.5),
            size * 0.03,
            fill=(*COLORS['white'], 80)
        )

    return img

def generate_all_icons(output_dir):
    """Generate all required icon sizes."""
    os.makedirs(output_dir, exist_ok=True)

    # Icon size specifications (pt, scale, pixels)
    sizes = [
        (16, 1, 16),
        (16, 2, 32),
        (32, 1, 32),
        (32, 2, 64),
        (128, 1, 128),
        (128, 2, 256),
        (256, 1, 256),
        (256, 2, 512),
        (512, 1, 512),
        (512, 2, 1024),
    ]

    generated_files = []

    for pt, scale, pixels in sizes:
        # Determine if we need simplified version
        simplified = pixels <= 32
        include_virus_eye = pixels >= 64

        print(f"Generating {pixels}x{pixels} icon (simplified={simplified}, virus_eye={include_virus_eye})...")

        icon = create_icon(pixels, include_virus_eye=include_virus_eye, simplified=simplified)

        # Generate filename
        if scale == 1:
            filename = f"icon_{pt}x{pt}.png"
        else:
            filename = f"icon_{pt}x{pt}@2x.png"

        filepath = os.path.join(output_dir, filename)
        icon.save(filepath, 'PNG')
        generated_files.append(filepath)
        print(f"  Saved: {filepath}")

    return generated_files

def create_icns(png_dir, output_path):
    """
    Create .icns file from PNG icons using iconutil.
    """
    import subprocess
    import shutil

    # Create .iconset directory
    iconset_dir = output_path.replace('.icns', '.iconset')
    os.makedirs(iconset_dir, exist_ok=True)

    # Copy PNGs to iconset with correct naming
    png_files = [f for f in os.listdir(png_dir) if f.endswith('.png')]

    for png in png_files:
        src = os.path.join(png_dir, png)
        dst = os.path.join(iconset_dir, png)
        shutil.copy2(src, dst)

    # Run iconutil to create .icns
    try:
        subprocess.run(
            ['iconutil', '-c', 'icns', iconset_dir, '-o', output_path],
            check=True
        )
        print(f"\nCreated: {output_path}")

        # Cleanup iconset
        shutil.rmtree(iconset_dir)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error creating .icns: {e}")
        return False
    except FileNotFoundError:
        print("iconutil not found - .icns creation requires macOS")
        return False

def main():
    # Paths
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)

    # Output directories
    png_output_dir = os.path.join(project_root, 'Sources', 'LungfishApp', 'Resources',
                                   'Assets.xcassets', 'AppIcon.appiconset')
    resources_dir = os.path.join(project_root, 'Resources')
    icns_output = os.path.join(resources_dir, 'AppIcon.icns')

    # Create Resources directory if needed
    os.makedirs(resources_dir, exist_ok=True)

    print("=" * 60)
    print("Lungfish Genome Browser - App Icon Generator")
    print("=" * 60)
    print()

    # Generate PNG icons
    print("Generating PNG icons...")
    generate_all_icons(png_output_dir)

    print()
    print("Creating .icns file...")
    create_icns(png_output_dir, icns_output)

    print()
    print("=" * 60)
    print("Icon generation complete!")
    print(f"PNG icons: {png_output_dir}")
    print(f"ICNS file: {icns_output}")
    print("=" * 60)

if __name__ == '__main__':
    main()
