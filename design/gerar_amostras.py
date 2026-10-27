"""Amostras PNG 48x48 lidas dos tokens Dart, sem dependências externas."""

from pathlib import Path
import argparse
import re
import struct
import zlib

ROOT = Path(__file__).resolve().parents[1]


def tokens():
    source = (ROOT / 'lib/theme/app_colors.dart').read_text(encoding='utf-8')
    return dict(re.findall(r'static const Color (\w+) = Color\(0xFF([0-9A-Fa-f]{6})\)', source))


def png(hex_color):
    def chunk(kind, data):
        return (struct.pack('!I', len(data)) + kind + data
                + struct.pack('!I', zlib.crc32(kind + data)))

    row = b'\0' + bytes.fromhex(hex_color) * 48
    return (b'\x89PNG\r\n\x1a\n'
            + chunk(b'IHDR', struct.pack('!2I5B', 48, 48, 8, 2, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(row * 48))
            + chunk(b'IEND', b''))


def contraste(first, second):
    def luminancia(value):
        rgb = [int(value[i:i + 2], 16) / 255 for i in (0, 2, 4)]
        linear = [v / 12.92 if v <= .04045 else ((v + .055) / 1.055) ** 2.4 for v in rgb]
        return sum(v * peso for v, peso in zip(linear, (.2126, .7152, .0722)))

    a, b = sorted((luminancia(first), luminancia(second)))
    return (b + .05) / (a + .05)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true')
    args = parser.parse_args()
    output = ROOT / 'docs/img/paleta'
    if not args.check:
        output.mkdir(parents=True, exist_ok=True)
    for name, value in tokens().items():
        path = output / f'{name}.png'
        data = png(value)
        if args.check:
            if not path.is_file() or path.read_bytes() != data:
                raise SystemExit(f'Amostra divergente: {name}')
        else:
            path.write_bytes(data)
    print(f'{len(tokens())} amostras 48x48 conferidas com os tokens Dart.' if args.check
          else f'{len(tokens())} amostras 48x48 gravadas em docs/img/paleta/.')


if __name__ == '__main__':
    main()
