import 'package:flutter/material.dart';

/// Sombras do Janela, no formato `BoxShadow` que a Aula CPAD 16 (página 6)
/// ensinou dentro de `BoxDecoration`.
///
/// Honestidade sobre a primeira: sobre a base `#0F1115`, sombra preta quase
/// não aparece, porque a luminância do fundo já é 0,0056 e escurecer não tem
/// para onde ir. Usamos [card] de todo modo porque ela fecha a costura do card
/// contra o fundo, mas **quem faz o card levantar é o degrau de superfície**.
/// Esse degrau se mede em L* e não em razão de contraste, que fica comprimida
/// perto do preto: `background` L*5,0 · `surface` L*10,7 · `surfaceAlt` L*16,1,
/// passos de cerca de 5,5 L*.
class AppShadows {
  /// Sombra de card. Alpha em hexadecimal, notação da Aula 16 (página 3).
  static const BoxShadow card = BoxShadow(
    color: Color(0x4D000000), // preto a 30%
    blurRadius: 16,
    offset: Offset(0, 4),
  );

  /// Brilho âmbar, só embaixo do botão primário, onde é visível de verdade:
  /// âmbar a 25% sobre `#0F1115` compõe em torno de `#4B3910`. Diz literalmente
  /// o conceito da marca, que é luz vazando por uma abertura.
  static const BoxShadow accentGlow = BoxShadow(
    color: Color(0x40FFB000), // AppColors.primary a 25%
    blurRadius: 24,
    offset: Offset(0, 8),
  );
}
