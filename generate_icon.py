#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFilter
import math

def create_icon(size=1024):
    # Create base image with light background
    img = Image.new('RGB', (size, size), (248, 250, 252))

    # Create a separate layer for the circles with transparency
    circles = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(circles)

    center = size // 2

    # Colors - teal/cyan tones
    teal_dark = (90, 170, 180)
    teal_light = (140, 210, 215)
    teal_glow = (180, 230, 235)
    white_ring = (255, 255, 255)

    # Ring configurations (radius, color, width)
    rings = [
        # Outer glow ring
        (0.42, teal_glow, 0.08),
        # Outer teal ring
        (0.34, teal_dark, 0.07),
        # White ring
        (0.27, white_ring, 0.05),
        # Middle teal ring
        (0.20, teal_light, 0.06),
        # Inner white ring
        (0.14, white_ring, 0.04),
        # Inner teal ring
        (0.08, teal_dark, 0.05),
    ]

    # Draw outer glow first
    glow_layer = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_layer)

    # Soft outer glow
    for i in range(20):
        alpha = int(30 - i * 1.5)
        radius = int(size * (0.45 + i * 0.01))
        glow_draw.ellipse(
            [center - radius, center - radius, center + radius, center + radius],
            fill=(teal_glow[0], teal_glow[1], teal_glow[2], alpha)
        )

    # Apply blur to glow
    glow_layer = glow_layer.filter(ImageFilter.GaussianBlur(radius=size//20))

    # Draw concentric rings with gradients
    for ring_radius_pct, color, width_pct in rings:
        outer_radius = int(size * ring_radius_pct)
        inner_radius = int(size * (ring_radius_pct - width_pct))

        # Draw ring with slight 3D effect
        for r in range(inner_radius, outer_radius):
            progress = (r - inner_radius) / max(1, (outer_radius - inner_radius))

            # Add depth - darker at edges, lighter in middle
            depth = math.sin(progress * math.pi)

            if color == white_ring:
                # White rings with subtle shadow
                brightness = int(245 + depth * 10)
                ring_color = (brightness, brightness, brightness, 255)
            else:
                # Teal rings with gradient
                r_val = int(color[0] + depth * 30)
                g_val = int(color[1] + depth * 25)
                b_val = int(color[2] + depth * 20)
                ring_color = (min(255, r_val), min(255, g_val), min(255, b_val), 255)

            draw.ellipse(
                [center - r, center - r, center + r, center + r],
                outline=ring_color,
                width=2
            )

    # Draw center dot
    center_radius = int(size * 0.035)
    for r in range(center_radius, 0, -1):
        progress = r / center_radius
        brightness = int(180 + (1 - progress) * 60)
        draw.ellipse(
            [center - r, center - r, center + r, center + r],
            fill=(brightness, min(255, brightness + 40), min(255, brightness + 45), 255)
        )

    # Composite layers
    img = img.convert('RGBA')
    img = Image.alpha_composite(img, glow_layer)
    img = Image.alpha_composite(img, circles)

    # Convert back to RGB
    final = Image.new('RGB', (size, size), (248, 250, 252))
    final.paste(img, mask=img.split()[3] if img.mode == 'RGBA' else None)

    # Slight overall blur for smoothness
    final = final.filter(ImageFilter.GaussianBlur(radius=1))

    return final

icon = create_icon(1024)
icon.save("BreathFlow/Assets.xcassets/AppIcon.appiconset/icon_1024.png", "PNG")
print("Icon created successfully!")
