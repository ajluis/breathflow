#!/usr/bin/env python3
from PIL import Image, ImageDraw, ImageFont
import os

# iPhone 6.7" dimensions (1290 x 2796)
WIDTH = 1290
HEIGHT = 2796

# Colors matching the app
BG_COLOR = (248, 250, 252)
PRIMARY_COLOR = (94, 175, 180)  # Teal
INHALE_COLOR = (100, 180, 220)  # Blue
EXHALE_COLOR = (160, 130, 200)  # Purple
TEXT_PRIMARY = (30, 30, 40)
TEXT_SECONDARY = (120, 120, 130)

def draw_rounded_rect(draw, coords, radius, fill):
    x1, y1, x2, y2 = coords
    draw.rectangle([x1 + radius, y1, x2 - radius, y2], fill=fill)
    draw.rectangle([x1, y1 + radius, x2, y2 - radius], fill=fill)
    draw.ellipse([x1, y1, x1 + 2*radius, y1 + 2*radius], fill=fill)
    draw.ellipse([x2 - 2*radius, y1, x2, y1 + 2*radius], fill=fill)
    draw.ellipse([x1, y2 - 2*radius, x1 + 2*radius, y2], fill=fill)
    draw.ellipse([x2 - 2*radius, y2 - 2*radius, x2, y2], fill=fill)

def draw_breathing_circle(draw, center_x, center_y, progress, color, size=400):
    # Background track
    track_color = (*color, 50)
    line_width = 20

    # Draw background circle
    draw.ellipse(
        [center_x - size, center_y - size, center_x + size, center_y + size],
        outline=(*color[:3], 60),
        width=line_width
    )

    # Draw progress arc (simplified as full circle for screenshot)
    if progress > 0:
        draw.arc(
            [center_x - size, center_y - size, center_x + size, center_y + size],
            start=-90,
            end=-90 + (360 * progress),
            fill=color,
            width=line_width
        )

def create_screenshot_1_home():
    """Home screen"""
    img = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(img)

    # Status bar area (top safe area)
    y_start = 180

    # App title
    draw.text((WIDTH//2, y_start + 100), "BreathFlow", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 72))

    # Subtitle
    draw.text((WIDTH//2, y_start + 180), "Find your calm", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 36))

    # Stats cards
    card_y = y_start + 350
    card_width = 580
    card_height = 160

    # Total time card
    draw_rounded_rect(draw, (60, card_y, 60 + card_width, card_y + card_height), 24, (255, 255, 255))
    draw.text((60 + card_width//2, card_y + 55), "45", fill=PRIMARY_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 56))
    draw.text((60 + card_width//2, card_y + 115), "minutes this week", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28))

    # Streak card
    draw_rounded_rect(draw, (WIDTH - 60 - card_width, card_y, WIDTH - 60, card_y + card_height), 24, (255, 255, 255))
    draw.text((WIDTH - 60 - card_width//2, card_y + 55), "7", fill=PRIMARY_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 56))
    draw.text((WIDTH - 60 - card_width//2, card_y + 115), "day streak", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28))

    # Breathing circle preview
    center_y = HEIGHT // 2 + 100
    draw_breathing_circle(draw, WIDTH//2, center_y, 0.7, PRIMARY_COLOR, 320)

    # Center icon
    draw.ellipse([WIDTH//2 - 80, center_y - 80, WIDTH//2 + 80, center_y + 80], fill=PRIMARY_COLOR)

    # Start button
    btn_y = HEIGHT - 400
    draw_rounded_rect(draw, (100, btn_y, WIDTH - 100, btn_y + 120), 60, PRIMARY_COLOR)
    draw.text((WIDTH//2, btn_y + 60), "Start Session", fill=(255, 255, 255), anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 40))

    return img

def create_screenshot_2_inhale():
    """Breathing session - Inhale"""
    img = Image.new('RGB', (WIDTH, HEIGHT), (240, 248, 255))  # Light blue tint
    draw = ImageDraw.Draw(img)

    y_start = 180

    # Header
    draw.text((WIDTH//2, y_start + 80), "12", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 48))
    draw.text((WIDTH//2, y_start + 130), "breaths left", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28))

    # Breathing circle
    center_y = HEIGHT // 2
    size = 380

    # Background track
    draw.ellipse(
        [WIDTH//2 - size, center_y - size, WIDTH//2 + size, center_y + size],
        outline=(*INHALE_COLOR, 60),
        width=24
    )

    # Progress arc
    draw.arc(
        [WIDTH//2 - size, center_y - size, WIDTH//2 + size, center_y + size],
        start=-90,
        end=-90 + 216,  # 60% progress
        fill=INHALE_COLOR,
        width=24
    )

    # Inner glow
    draw.ellipse(
        [WIDTH//2 - size + 50, center_y - size + 50, WIDTH//2 + size - 50, center_y + size - 50],
        fill=(*INHALE_COLOR, 20)
    )

    # Center text
    draw.text((WIDTH//2, center_y - 40), "Inhale", fill=INHALE_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 44))
    draw.text((WIDTH//2, center_y + 50), "3", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 120))

    # Exercise name
    draw.text((WIDTH//2, HEIGHT - 350), "Balanced Breathing", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32))
    draw.text((WIDTH//2, HEIGHT - 300), "5 sec in, 5 sec out", fill=(*TEXT_SECONDARY, 180), anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 26))

    return img

def create_screenshot_3_exhale():
    """Breathing session - Exhale"""
    img = Image.new('RGB', (WIDTH, HEIGHT), (248, 245, 255))  # Light purple tint
    draw = ImageDraw.Draw(img)

    y_start = 180

    # Header
    draw.text((WIDTH//2, y_start + 80), "8", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 48))
    draw.text((WIDTH//2, y_start + 130), "breaths left", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 28))

    # Breathing circle
    center_y = HEIGHT // 2
    size = 380

    # Background track
    draw.ellipse(
        [WIDTH//2 - size, center_y - size, WIDTH//2 + size, center_y + size],
        outline=(*EXHALE_COLOR, 60),
        width=24
    )

    # Progress arc (emptying)
    draw.arc(
        [WIDTH//2 - size, center_y - size, WIDTH//2 + size, center_y + size],
        start=-90,
        end=-90 + 144,  # 40% remaining
        fill=EXHALE_COLOR,
        width=24
    )

    # Inner glow
    draw.ellipse(
        [WIDTH//2 - size + 50, center_y - size + 50, WIDTH//2 + size - 50, center_y + size - 50],
        fill=(*EXHALE_COLOR, 20)
    )

    # Center text
    draw.text((WIDTH//2, center_y - 40), "Exhale", fill=EXHALE_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 44))
    draw.text((WIDTH//2, center_y + 50), "5", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 120))

    # Exercise name
    draw.text((WIDTH//2, HEIGHT - 350), "Relaxing Breathing", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32))
    draw.text((WIDTH//2, HEIGHT - 300), "4 sec in, 8 sec out", fill=(*TEXT_SECONDARY, 180), anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 26))

    return img

def create_screenshot_4_complete():
    """Session complete"""
    img = Image.new('RGB', (WIDTH, HEIGHT), BG_COLOR)
    draw = ImageDraw.Draw(img)

    center_y = HEIGHT // 2 - 100

    # Checkmark circle
    draw.ellipse([WIDTH//2 - 120, center_y - 120, WIDTH//2 + 120, center_y + 120], fill=PRIMARY_COLOR)

    # Checkmark (simplified)
    draw.text((WIDTH//2, center_y), "✓", fill=(255, 255, 255), anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 100))

    # Congratulations text
    draw.text((WIDTH//2, center_y + 220), "Session Complete!", fill=TEXT_PRIMARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 52))

    draw.text((WIDTH//2, center_y + 300), "Great job! You completed", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32))
    draw.text((WIDTH//2, center_y + 350), "5 minutes of breathing", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 32))

    # Stats
    stats_y = center_y + 500
    draw.text((WIDTH//2 - 200, stats_y), "30", fill=PRIMARY_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 64))
    draw.text((WIDTH//2 - 200, stats_y + 50), "breaths", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 26))

    draw.text((WIDTH//2 + 200, stats_y), "8", fill=PRIMARY_COLOR, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 64))
    draw.text((WIDTH//2 + 200, stats_y + 50), "day streak", fill=TEXT_SECONDARY, anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 26))

    # Done button
    btn_y = HEIGHT - 400
    draw_rounded_rect(draw, (100, btn_y, WIDTH - 100, btn_y + 120), 60, PRIMARY_COLOR)
    draw.text((WIDTH//2, btn_y + 60), "Done", fill=(255, 255, 255), anchor="mm",
              font=ImageFont.truetype("/System/Library/Fonts/Helvetica.ttc", 40))

    return img

# Create output directory
os.makedirs("screenshots", exist_ok=True)

# Generate screenshots
screenshots = [
    ("screenshots/01_home.png", create_screenshot_1_home()),
    ("screenshots/02_inhale.png", create_screenshot_2_inhale()),
    ("screenshots/03_exhale.png", create_screenshot_3_exhale()),
    ("screenshots/04_complete.png", create_screenshot_4_complete()),
]

for filename, img in screenshots:
    img.save(filename, "PNG")
    print(f"Created {filename}")

print("\nAll screenshots created!")
