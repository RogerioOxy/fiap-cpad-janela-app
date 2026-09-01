import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Escala tipográfica do Janela: 9 papéis em 6 tamanhos
/// (12 · 14 · 16 · 18 · 24 · 32). Três papéis reaproveitam tamanho trocando de
/// família ou de peso, então não são níveis novos.
///
/// O `height` está escrito como divisão literal, do jeito que a Aula CPAD 16
/// (página 4) mostra: `height: 40 / 32`. Fica auto-documentado e a conferência
/// contra o Figma é direta. Em Flutter o `height` é MULTIPLICADOR, não pixel:
/// copiar o Line Height do Figma em px quebra a tela.
///
/// **Duas famílias, e a segunda tem motivo técnico.** A interface é Poppins,
/// aplicada globalmente por `GoogleFonts.poppinsTextTheme()` no `MaterialApp`,
/// que é o que o Guia Prático (página 4) marca como recomendado. Mas Poppins
/// não resolve tabela de horas: o avanço é largo e o `1` é uma haste com
/// bandeirola e sem base. Como a tela deste app é sobretudo uma coluna de
/// horários, hora e contagem vão em JetBrains Mono, que é tabular por
/// construção e desenhada para desambiguar `1`, `7` e `0`.
///
/// Isso não acrescenta dependência: `GoogleFonts.jetBrainsMono(...)` é o mesmo
/// construto `GoogleFonts.poppins(...)` da página 3 do Guia, mudando só o nome
/// da família, no mesmo pacote `google_fonts`.
///
/// Os estilos de Poppins são `const` e sem `fontFamily`, porque herdam a
/// família do `textTheme` global. Os dois estilos mono são `final`, porque
/// `GoogleFonts.jetBrainsMono(...)` é chamada em tempo de execução e não é
/// expressão constante.
class AppText {
  /// Nome do produto na tela de entrada.
  static const TextStyle brandTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  /// Título de tela e da `AppBar`.
  static const TextStyle screenTitle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Nome do espaço no card (`Sala 312`).
  static const TextStyle cardTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  /// Microcopy, subtítulo, mensagem, texto de confirmação.
  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  /// Texto do botão. Reaproveita o tamanho de [body] com peso maior, em vez de
  /// criar um sétimo tamanho.
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
    letterSpacing: 0.2,
  );

  /// Palavra do estado no chip. A cor vem do status, então não é fixada aqui.
  static const TextStyle statusLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.2,
  );

  /// Andar, capacidade, identificação, cabeçalho de coluna.
  ///
  /// O `letterSpacing` positivo abre as contraformas fechadas da geométrica
  /// justamente no tamanho onde ela mais sofre. Nada de caixa-alta abaixo de
  /// 12dp.
  static const TextStyle label = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
  );

  /// Horário-limite dentro do card e da lista. Mono, para alinhar a coluna.
  ///
  /// Regra de legibilidade: hora nunca abaixo de 14dp, e sempre com o
  /// separador `h` (`15h40`, nunca `1540`), o que dá contexto ao numeral.
  static final TextStyle timeValue = GoogleFonts.jetBrainsMono(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 20 / 16,
    color: AppColors.textPrimary,
  );

  /// Contagem de livres, ocupados e em manutenção no painel do momento.
  /// A cor vem do status, então não é fixada aqui.
  static final TextStyle numberXL = GoogleFonts.jetBrainsMono(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
  );

  /// Largura da caixa da coluna de hora.
  ///
  /// Alinhamento vertical entre linhas de lista não depende só do avanço do
  /// glifo, depende do container: assim `07h05` e `15h40` ocupam a mesma
  /// caixa. Elemento interno com tamanho fixo é permitido pela regra do Guia
  /// (página 2), que só proíbe tamanho fixo em frame externo.
  static const double timeColumnWidth = 64;
}
