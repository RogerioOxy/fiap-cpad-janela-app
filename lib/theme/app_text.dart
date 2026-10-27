import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Escala local: Poppins na interface e JetBrains Mono nas horas e contagens.
class AppText {
  /// Nome do produto na tela de entrada.
  static const TextStyle brandTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 32,
    fontWeight: FontWeight.w600,
    height: 40 / 32,
    letterSpacing: -0.8,
    color: AppColors.textPrimary,
  );

  /// Título de tela e da `AppBar`.
  static const TextStyle screenTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 32 / 24,
    letterSpacing: -0.2,
    color: AppColors.textPrimary,
  );

  /// Nome do espaço no card (`Sala 312`).
  static const TextStyle cardTitle = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 24 / 18,
    color: AppColors.textPrimary,
  );

  /// Microcopy, subtítulo, mensagem, texto de confirmação.
  static const TextStyle body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 24 / 16,
    color: AppColors.textSecondary,
  );

  /// Texto do botão. Reaproveita o tamanho de [body] com peso maior, em vez de
  /// criar um sétimo tamanho.
  static const TextStyle button = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 20 / 16,
    letterSpacing: 0.2,
  );

  /// Palavra do estado no chip. A cor vem do status, então não é fixada aqui.
  static const TextStyle statusLabel = TextStyle(
    fontFamily: 'Poppins',
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
    fontFamily: 'Poppins',
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
  static const TextStyle timeValue = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontVariations: [FontVariation('wght', 500)],
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 20 / 16,
    color: AppColors.textPrimary,
  );

  /// Contagem de livres, ocupados e em manutenção no painel do momento.
  /// A cor vem do status, então não é fixada aqui.
  static const TextStyle numberXL = TextStyle(
    fontFamily: 'JetBrainsMono',
    fontVariations: [FontVariation('wght', 600)],
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
