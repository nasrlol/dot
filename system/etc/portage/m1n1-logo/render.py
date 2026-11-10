# Render ~/art (fastfetch ${cN} markup) into m1n1 boot logos.
import re, sys, os
from PIL import Image, ImageDraw

art, out = sys.argv[1], sys.argv[2]
COL = {  # from dotfiles/theme/palette-dark
    "c1": (0xd4, 0x8b, 0x30),  # accent
    "c2": (0xc8, 0x48, 0x20),  # rust
    "c3": (0xd9, 0xc6, 0xa5),  # fg_bright
    "c4": (0x8b, 0x73, 0x55),  # fg_dim
}
FILL = {"=": 1.0, "-": 1.0, "*": 1.0, "+": 0.75, ":": 0.5}

rows = []
for line in open(art).read().rstrip("\n").split("\n"):
    cells, cur = [], "c1"
    for tok in re.split(r"(\$\{c\d\})", line):
        m = re.fullmatch(r"\$\{(c\d)\}", tok)
        if m:
            cur = m.group(1)
        else:
            cells += [(ch, cur) for ch in tok]
    rows.append(cells)

CW, CH = 20, 40  # terminal cells are ~1:2
w = max(len(r) for r in rows) * CW
h = len(rows) * CH
img = Image.new("RGB", (w, h), "black")
d = ImageDraw.Draw(img)
for y, r in enumerate(rows):
    for x, (ch, c) in enumerate(r):
        f = FILL.get(ch)
        if not f:
            continue
        pw, ph = CW * f, CH * f
        x0, y0 = x * CW + (CW - pw) / 2, y * CH + (CH - ph) / 2
        d.rectangle([x0, y0, x0 + pw - 1, y0 + ph - 1], fill=COL[c])

# crop to content, center in a square with ~8% margin
img = img.crop(img.getbbox())
side = int(max(img.size) * 1.16)
sq = Image.new("RGB", (side, side), "black")
sq.paste(img, ((side - img.width) // 2, (side - img.height) // 2))

os.makedirs(out, exist_ok=True)
for s in (48, 128, 256):
    im = sq.resize((s, s), Image.LANCZOS)
    im.save(f"{out}/bootlogo_{s}.png")
    with open(f"{out}/bootlogo_{s}.bin", "wb") as f:
        f.write(im.convert("RGBA").tobytes())
sq.resize((512, 512), Image.NEAREST).save(f"{out}/preview.png")

# u-boot logo: 8-bit palette BMP (its apple config has no 24/32bpp BMP
# support), 160x160 like the stock drivers/video/u_boot_logo.bmp
sq.resize((160, 160), Image.LANCZOS).quantize(255).save(f"{out}/u_boot_logo.bmp")
