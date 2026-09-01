"""Gera os arquivos da marca Janela a partir da geometria especificada.

A marca é paramétrica: nenhuma forma foi desenhada à mão, todas saem das
coordenadas abaixo, num quadro de 512 por 512 para o ícone e de 288 por 288
para a marca sem chapa. Rodar este script reproduz os PNGs idênticos.

    python design/gerar_marca.py

Geometria (quadro 512), de baixo para cima:
    chapa          0,   0, 512x512, raio 112, background
    caixilho     112, 112, 288x288, raio  56, textSecondary
    vão          144, 144, 224x224, raio  24, slotDim
    vidro aceso  144, 144,  85x224, recortado pela forma do vão, primary
    montante     229, 144,  16x224, textSecondary

Conferências que a geometria satisfaz:
    espessura do caixilho = 32 nos quatro lados
    raio interno 24 = 56 - 32 (raios concêntricos, espessura constante na curva)
    vidro aceso = 38% da largura do vão
    montante encostado no vidro aceso, mesma cor do caixilho
"""

from PIL import Image, ImageDraw

# Tokens de AppColors (lib/theme/app_colors.dart)
BACKGROUND = (0x0F, 0x11, 0x15, 255)
CAIXILHO = (0xA2, 0xAA, 0xB8, 255)  # textSecondary
VAO = (0x39, 0x40, 0x4C, 255)       # slotDim
ACESO = (0xFF, 0xB0, 0x00, 255)     # primary
TINTA = (0x0F, 0x11, 0x15, 255)     # background, usado como tinta no fundo claro
ACESO_TINTA = (0xB8, 0x74, 0x00, 255)  # primaryInk, 3,79:1 sobre branco
VAZIO = (0, 0, 0, 0)

FRACAO_ACESA = 0.38
MONTANTE = 16


def _rr(draw, x, y, w, h, raio, cor):
    draw.rounded_rectangle([x, y, x + w - 1, y + h - 1], radius=raio, fill=cor)


def _vidro_aceso(img, vao, cor):
    """Pinta o vidro aceso recortado pela forma arredondada do vão."""
    vx, vy, vw, vh, vr = vao
    largura = int(vw * FRACAO_ACESA)
    mascara = Image.new("L", img.size, 0)
    md = ImageDraw.Draw(mascara)
    md.rounded_rectangle([vx, vy, vx + vw - 1, vy + vh - 1], radius=vr, fill=255)
    md.rectangle([vx + largura, vy, vx + vw, vy + vh], fill=0)
    aceso = Image.new("RGBA", img.size, cor)
    img = Image.composite(aceso, img, mascara)
    ImageDraw.Draw(img).rectangle(
        [vx + largura, vy, vx + largura + MONTANTE - 1, vy + vh - 1],
        fill=CAIXILHO if cor == ACESO else TINTA,
    )
    return img


def icone(lado=512):
    """Ícone de app: com chapa, para launcher e README."""
    img = Image.new("RGBA", (512, 512), VAZIO)
    d = ImageDraw.Draw(img)
    _rr(d, 0, 0, 512, 512, 112, BACKGROUND)
    _rr(d, 112, 112, 288, 288, 56, CAIXILHO)
    _rr(d, 144, 144, 224, 224, 24, VAO)
    img = _vidro_aceso(img, (144, 144, 224, 224, 24), ACESO)
    return img if lado == 512 else img.resize((lado, lado), Image.LANCZOS)


def marca(lado=288, claro=False):
    """Marca sem chapa, vão transparente. Usada dentro do app."""
    caixilho = TINTA if claro else CAIXILHO
    aceso = ACESO_TINTA if claro else ACESO
    img = Image.new("RGBA", (288, 288), VAZIO)
    d = ImageDraw.Draw(img)
    _rr(d, 0, 0, 288, 288, 56, caixilho)
    # abre o vão
    mascara = Image.new("L", (288, 288), 0)
    ImageDraw.Draw(mascara).rounded_rectangle([32, 32, 255, 255], radius=24, fill=255)
    img = Image.composite(Image.new("RGBA", (288, 288), VAZIO), img, mascara)
    img = _vidro_aceso(img, (32, 32, 224, 224, 24), aceso)
    return img if lado == 288 else img.resize((lado, lado), Image.LANCZOS)


def icone_maskable(lado=512):
    """Ícone para launcher adaptativo e PWA maskable.

    O sistema recorta a arte num círculo ou num quadrado arredondado, cortando
    cerca de um sexto de cada lado. Por isso a figura entra reduzida a 70% em
    torno do centro, com a chapa preenchendo o quadro inteiro: assim o corte
    come fundo e nunca a marca.
    """
    base = Image.new("RGBA", (512, 512), BACKGROUND)
    figura = icone(512)
    # descarta a chapa original e reaproveita só a figura, reduzida
    reduzida = figura.resize((358, 358), Image.LANCZOS)  # 512 * 0.70
    base.paste(reduzida, (77, 77), reduzida)
    return base if lado == 512 else base.resize((lado, lado), Image.LANCZOS)


def exportar_icones_de_plataforma():
    """Substitui os ícones default do Flutter pela marca.

    O `flutter create` deixa o favicon azul do Flutter e os ícones brancos de
    template. Sem esta passada, o app roda com a marca na tela e o ícone de
    outro produto na aba do navegador e na gaveta do Android.
    """
    icone(16).save("web/favicon.png")
    icone(192).save("web/icons/Icon-192.png")
    icone(512).save("web/icons/Icon-512.png")
    icone_maskable(192).save("web/icons/Icon-maskable-192.png")
    icone_maskable(512).save("web/icons/Icon-maskable-512.png")

    mipmaps = {
        "mdpi": 48,
        "hdpi": 72,
        "xhdpi": 96,
        "xxhdpi": 144,
        "xxxhdpi": 192,
    }
    for densidade, px in mipmaps.items():
        caminho = f"android/app/src/main/res/mipmap-{densidade}/ic_launcher.png"
        icone_maskable(px).save(caminho)
    print("icones de plataforma exportados")


if __name__ == "__main__":
    base = "assets/images"
    icone(512).save(f"{base}/janela_icon_512.png")
    marca(88).save(f"{base}/janela_mark.png")
    marca(176).save(f"{base}/2.0x/janela_mark.png")
    marca(264).save(f"{base}/3.0x/janela_mark.png")
    marca(264, claro=True).save(f"{base}/janela_mark_light.png")
    print("marca gerada em", base)
    exportar_icones_de_plataforma()
