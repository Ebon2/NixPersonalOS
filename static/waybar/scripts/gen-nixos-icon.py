#!/usr/bin/env python3
"""
Genera ~/.config/waybar/icons/nixos-catppuccin.png
Logo NixOS con colores Catppuccin Mocha (blue→lavender)
Ejecutar una vez: python3 gen-nixos-icon.py
"""
import math, os
from PIL import Image, ImageDraw

OUT = os.path.expanduser("~/.config/waybar/icons/nixos-catppuccin.png")
os.makedirs(os.path.dirname(OUT), exist_ok=True)

SIZE = 256
img  = Image.new("RGBA", (SIZE, SIZE), (0,0,0,0))
draw = ImageDraw.Draw(img)
cx = cy = SIZE // 2

def rot(pts, deg, ox=0, oy=0):
    a = math.radians(deg)
    return [(
        (x-ox)*math.cos(a)-(y-oy)*math.sin(a)+ox,
        (x-ox)*math.sin(a)+(y-oy)*math.cos(a)+oy
    ) for x,y in pts]

def mv(pts, tx, ty):
    return [(x+tx, y+ty) for x,y in pts]

# Segmento NixOS apuntando arriba
R, r, W, WH = 108, 58, 22, 38
seg = [(-W,-r),(-W,-(R-38)),(-WH,-(R-38)),(0,-R),(WH,-(R-38)),(W,-(R-38)),(W,-r)]

BLUE = (137,180,250); LAV = (180,190,254)
for i in range(6):
    t = i/5
    c = tuple(int(BLUE[k]+t*(LAV[k]-BLUE[k])) for k in range(3))+(255,)
    draw.polygon(mv(rot(seg, i*60), cx, cy), fill=c)

img.save(OUT)
print(f"Saved {OUT}")
