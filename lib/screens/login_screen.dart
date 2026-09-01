import 'package:flutter/material.dart';

import '../data/espacos_mock.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

/// Tela de entrada do Janela.
///
/// É a única tela que o Checkpoint 4 precisa entregar rodando, e é uma tela do
/// produto final, não um placeholder descartável: a marca, a paleta, a
/// tipografia e a régua de espaçamento que ela usa são as mesmas que o CP5 vai
/// reaproveitar sem alterar. Congelar o visual aqui é o que permite ao CP5 ser
/// fiel ao design deste checkpoint em vez de redesenhar.
///
/// `StatelessWidget` porque nada nesta tela muda em resposta a interação. É a
/// regra de decisão da Aula CPAD 14 (página 10): "Esse widget vai mudar em
/// resposta a algo? NÃO, StatelessWidget."
///
/// Estilo de botão e de campo fica inline, por instância. `ThemeData` com
/// `elevatedButtonTheme` e `inputDecorationTheme` não aparece em nenhuma aula
/// do semestre (verificado por busca nos seis PDFs), então centralizar estilo
/// de componente no tema seria usar o que não foi ensinado.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      // Este bloco resolve um defeito real de layout, e vale explicar porque
      // não é óbvio.
      //
      // O `Spacer` lá embaixo empurra os botões para o rodapé, e para isso ele
      // precisa de altura LIMITADA. Já rolar a tela exige altura ILIMITADA.
      // As duas coisas se excluem: numa tela curta (celular na horizontal, ou
      // a janela do Chrome reduzida) o `Column` estourava.
      //
      // A combinação abaixo atende os dois casos. `ConstrainedBox` garante ao
      // menos a altura da tela, `IntrinsicHeight` torna essa altura justa (o
      // `Spacer` conta como 0 no cálculo intrínseco, então a altura intrínseca
      // é a soma do conteúdo fixo) e o `SingleChildScrollView` rola quando o
      // conteúdo não cabe. Sobrando espaço, o `Spacer` absorve a diferença e
      // os botões vão para o rodapé; faltando, a tela rola.
      //
      // O Guia Prático (página 2) manda dimensionar contra a tela com
      // `MediaQuery`; aqui `LayoutBuilder` é mais correto, porque devolve a
      // altura já descontada da `SafeArea`. E o checklist do próprio Guia
      // (página 8) pede testar em pelo menos dois tamanhos de tela: é esse
      // item que este trecho cumpre.
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            // `Center` mais `maxWidth` mantêm a coluna de conteúdo com largura
            // de celular mesmo numa janela larga de navegador.
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                  maxWidth: AppSpacing.maxContentWidth,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    // Só margem lateral. A vertical vem dos SizedBox, para o
                    // Spacer poder empurrar os botões para baixo.
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.topOffset),
                        _buildMarca(),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildTitulo(),
                        const SizedBox(height: AppSpacing.xxl),
                        _buildProvas(),
                        const Spacer(),
                        _buildBotaoAluno(context),
                        const SizedBox(height: AppSpacing.md),
                        _buildBotaoCoordenacao(context),
                        const SizedBox(height: AppSpacing.xl),
                        _buildIdentificacao(),
                        const SizedBox(height: AppSpacing.lg),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// A marca vem por `Image.asset` e o nome por `Text`, em vez de uma
  /// assinatura travada num único PNG. Texto nativo fica nítido em qualquer
  /// densidade e permite controlar o espaçamento. A assinatura travada é para
  /// capa de PDF e slide.
  Widget _buildMarca() {
    return Image.asset(
      'assets/images/janela_mark.png',
      width: AppSpacing.markSize,
      height: AppSpacing.markSize,
      fit: BoxFit.contain,
      // Decorativa: o nome "Janela" vem logo abaixo em `Text`, então o leitor
      // de tela anunciaria a mesma informação duas vezes.
      excludeFromSemantics: true,
    );
  }

  Widget _buildTitulo() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Janela', style: AppText.brandTitle),
        SizedBox(height: AppSpacing.sm),
        Text('Salas livres agora, e até que horário.', style: AppText.body),
      ],
    );
  }

  /// As três linhas de prova. Os ícones ficam em `textSecondary` e não em
  /// âmbar de propósito: na entrada, a única coisa quente da tela é o botão.
  /// É esse contraste que faz o acento significar ação.
  Widget _buildProvas() {
    return const Column(
      children: [
        _LinhaProva(
          icone: Icons.schedule,
          texto: 'Veja até que horário cada espaço está livre, não só se está.',
        ),
        SizedBox(height: AppSpacing.lg),
        _LinhaProva(
          icone: Icons.event_available,
          texto: 'Garanta o intervalo antes de sair do lugar onde você está.',
        ),
        SizedBox(height: AppSpacing.lg),
        _LinhaProva(
          icone: Icons.layers,
          texto: 'Filtre por andar e por tipo: sala, laboratório ou auditório.',
        ),
      ],
    );
  }

  Widget _buildBotaoAluno(BuildContext context) {
    final livres = contarPorStatus(StatusEspaco.livre);

    // O brilho âmbar sai de um Container com BoxDecoration, e não da
    // `elevation` do botão, porque `BoxDecoration` com `boxShadow` é o que a
    // Aula CPAD 16 (página 6) ensinou.
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        boxShadow: const [AppShadows.accentGlow],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _avisar(
            context,
            '$livres de ${espacos.length} espaços livres agora no campus piloto.',
          ),
          icon: const Icon(Icons.search, size: 20),
          label: const Text('Ver salas livres agora', style: AppText.button),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            elevation: 0,
            // `minimumSize` em vez de altura fixa: com escala de texto grande o
            // rótulo precisa de duas linhas, e altura travada o recortaria.
            // Rolagem não resolve altura interna.
            minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
          ),
        ),
      ),
    );
  }

  /// A coordenação é o público que pagaria pelo produto, então ela tem entrada
  /// própria desde a primeira tela. Botão secundário: `surfaceAlt` em vez de
  /// âmbar, porque só a ação principal é quente.
  Widget _buildBotaoCoordenacao(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _avisar(
          context,
          'O painel de demanda da coordenação entra no Checkpoint 6.',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.surfaceAlt,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radius),
          ),
        ),
        child: const Text('Entrar como coordenação', style: AppText.button),
      ),
    );
  }

  Widget _buildIdentificacao() {
    return const Text(
      'Rogério Deligi Ferreira Filho (RM561942)\n'
      'Maria Fernanda Garavelli Dantas (RM562686)',
      style: AppText.label,
    );
  }

  /// `ScaffoldMessenger` com `SnackBar`, como a Aula CPAD 13 (página 9)
  /// ensinou. A mensagem lê a contagem do mock em vez de texto fixo, para a
  /// tela provar que a camada de dados está ligada.
  void _avisar(BuildContext context, String mensagem) {
    // `hideCurrentSnackBar` antes de mostrar a nova: sem isso, toques repetidos
    // enfileiram mensagens e uma antiga reaparece depois que a pessoa já parou
    // de tocar. Esse defeito apareceu de verdade ao capturar a tela do README:
    // um SnackBar residual cobriu a identificação dos integrantes.
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(mensagem, style: AppText.body),
        backgroundColor: AppColors.surfaceAlt,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radius),
        ),
      ),
    );
  }
}

/// Uma linha de prova: ícone, respiro e texto que quebra em várias linhas.
///
/// Extraída em classe própria em vez de método porque é repetida três vezes
/// com dados diferentes. O Guia Prático (páginas 6 e 7) trata texto chumbado
/// dentro do `build` como defeito a corrigir: o dado entra por parâmetro do
/// construtor.
class _LinhaProva extends StatelessWidget {
  final IconData icone;
  final String texto;

  const _LinhaProva({required this.icone, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icone, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.md),
        // `Expanded` para o texto poder quebrar em vez de estourar a linha.
        Expanded(child: Text(texto, style: AppText.body)),
      ],
    );
  }
}
