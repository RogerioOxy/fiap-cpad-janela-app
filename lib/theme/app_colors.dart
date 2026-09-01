import 'package:flutter/material.dart';

/// Paleta do Janela.
///
/// Segue o que a Aula CPAD 16 (página 9) e o Guia Prático (páginas 2 e 3)
/// ensinaram: cor centralizada em `static const Color`, nunca `Color(0xFF...)`
/// solto na tela. O Guia chama cor repetida no código de "magic number", que é
/// "um número que não tem nome, não tem contexto".
///
/// Os nomes reaproveitam os mesmos slots do `AppColors` do Guia (`primary`,
/// `primaryDark`, `background`, `surface`, `border`). O bloco de feedback dele
/// (`success` / `error` / `warning`) foi renomeado para o domínio, porque neste
/// app o estado de uma sala não é feedback de formulário.
///
/// Regra de uso que mantém a consistência entre CP4, CP5 e CP6:
/// **âmbar é ação e marca; cor de status é estado.** Nenhum número de hora,
/// contagem ou ícone informativo usa âmbar. É isso que mantém o botão como a
/// coisa mais quente da tela.
class AppColors {
  // Marca. `primary` é a semente única do ColorScheme.
  static const Color primary = Color(0xFFFFB000);
  static const Color primaryDark = Color(0xFFD18E00);
  static const Color onPrimary = Color(0xFF1B1200);

  /// Âmbar escurecido, só para a marca sobre fundo claro (capa, slide, README).
  /// O `primary` sobre branco dá 1,83:1 e reprova qualquer critério; este dá
  /// 3,79:1 e cumpre os 3:1 de elemento gráfico. Nunca usar na interface.
  static const Color primaryInk = Color(0xFFB87400);

  // Fundos, em três degraus de superfície.
  static const Color background = Color(0xFF0F1115);
  static const Color surface = Color(0xFF191D25);
  static const Color surfaceAlt = Color(0xFF232833);

  // Texto.
  static const Color textPrimary = Color(0xFFF2F4F7);
  static const Color textSecondary = Color(0xFFA2AAB8);

  // Bordas e trilhas.
  /// Contorno de campo de texto e de card, onde o contorno é o que identifica
  /// o componente. 3,38:1 sobre `surface`, o que cumpre o mínimo de 3:1 do
  /// critério 1.4.11 (elemento de interface não textual).
  static const Color border = Color(0xFF657084);

  /// Linha separadora. Puramente decorativa: 1,45:1, nunca a única indicação.
  static const Color divider = Color(0xFF2C313B);

  /// Trilha da faixa de tempo (a hora que não está livre) e vão do caixilho
  /// na marca.
  static const Color slotDim = Color(0xFF39404C);

  // Status. Substitui o bloco success/error/warning do Guia.
  //
  // Nenhum verde-vermelho de semáforo: esse par é o pior possível para
  // deuteranopia e protanopia. E nenhum amarelo de status, que colidiria com
  // o âmbar da marca.
  //
  // Cor NUNCA é o único sinal de estado. Onde o status aparece, aparecem
  // sempre três redundâncias: cor, ícone de silhueta diferente
  // (`check_circle` círculo, `groups` corpo, `build` diagonal) e a palavra.
  // A luminância relativa dos três é 0,544 · 0,375 · 0,297, com passos de
  // 1,40x e 1,23x, muito abaixo de 3:1: luminância sozinha não distingue, e é
  // por isso que ícone e palavra são obrigatórios e não enfeite.
  static const Color statusLivre = Color(0xFF3DDC97);
  static const Color statusOcupado = Color(0xFFFF7A9A);
  static const Color statusManutencao = Color(0xFF8795AE);
}
