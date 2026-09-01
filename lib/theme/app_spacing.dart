/// Régua de espaçamento e raio do Janela.
///
/// Seis valores, todos múltiplos de 4. Padding e gap saem daqui, sem exceção,
/// pelo mesmo motivo que a cor sai de `AppColors`: número solto no layout é
/// magic number igual a cor solta.
///
/// O professor exigiu centralizar cor, não espaçamento. Esta classe é a mesma
/// construção do `AppColors` do Guia Prático, sem conceito novo.
class AppSpacing {
  static const double xs = 4; // gap entre ícone e texto
  static const double sm = 8; // gap entre título e subtítulo
  static const double md = 12; // gap entre cards
  static const double lg = 16; // padding interno de card
  static const double xl = 24; // margem lateral de tela
  static const double xxl = 32; // respiro entre blocos

  /// Raio de card, botão, campo de texto e imagem.
  static const double radius = 12;

  /// Raio de pílula, para chip de filtro e chip de status.
  static const double radiusPill = 999;

  /// Altura de toque de botão. É o valor do exemplo do Guia Prático (página 5),
  /// mantido de propósito.
  static const double buttonHeight = 52;

  /// Lado da marca na tela de entrada.
  static const double markSize = 88;

  /// Afastamento do topo da tela de entrada.
  ///
  /// Fica fora da régua de propósito: é offset estrutural de uma tela, não gap
  /// entre elementos. Múltiplo de 4, como o resto.
  static const double topOffset = 64;

  /// Largura máxima da coluna de conteúdo.
  ///
  /// O app é desenhado para celular (referência 360 por 800), mas o CP5 aceita
  /// demonstração no Chrome, e numa janela maximizada o conteúdo esticaria até
  /// 1500dp: botão largo demais, texto colado na borda. Limitar a coluna e
  /// centralizar resolve, e é o item "testei em pelo menos dois tamanhos de
  /// tela" do checklist do Guia Prático (página 8).
  static const double maxContentWidth = 480;
}
