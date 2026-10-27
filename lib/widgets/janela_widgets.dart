import 'package:flutter/material.dart';

import '../models/agenda.dart';
import '../models/espaco.dart';
import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';

Color corStatus(StatusEspaco status) => switch (status) {
  StatusEspaco.livre => AppColors.statusLivre,
  StatusEspaco.ocupado => AppColors.statusOcupado,
  StatusEspaco.manutencao => AppColors.statusManutencao,
};

class SeloStatus extends StatelessWidget {
  const SeloStatus(this.status, {super.key});
  final StatusEspaco status;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.sm,
    ),
    decoration: BoxDecoration(
      color: corStatus(status).withValues(alpha: .12),
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          switch (status) {
            StatusEspaco.livre => Icons.check_circle,
            StatusEspaco.ocupado => Icons.groups,
            StatusEspaco.manutencao => Icons.build,
          },
          size: 18,
          color: corStatus(status),
        ),
        const SizedBox(width: AppSpacing.xs),
        Flexible(
          child: Text(
            rotuloStatus[status]!,
            style: AppText.statusLabel.copyWith(color: corStatus(status)),
          ),
        ),
      ],
    ),
  );
}

class BotaoJanela extends StatelessWidget {
  const BotaoJanela({
    super.key,
    required this.texto,
    required this.onPressed,
    this.secundario = false,
    this.icone,
  });
  final String texto;
  final VoidCallback? onPressed;
  final bool secundario;
  final IconData? icone;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      boxShadow: secundario || onPressed == null
          ? null
          : const [AppShadows.accentGlow],
    ),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          elevation: const WidgetStatePropertyAll(0),
          minimumSize: const WidgetStatePropertyAll(
            Size.fromHeight(AppSpacing.buttonHeight),
          ),
          padding: const WidgetStatePropertyAll(EdgeInsets.all(AppSpacing.lg)),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSpacing.radius),
            ),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.surfaceAlt;
            }
            if (secundario) return AppColors.surfaceAlt;
            return states.contains(WidgetState.pressed)
                ? AppColors.primaryDark
                : AppColors.primary;
          }),
          foregroundColor: WidgetStatePropertyAll(
            secundario ? AppColors.textPrimary : AppColors.onPrimary,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icone != null) ...[
              Icon(icone, size: 20),
              const SizedBox(width: AppSpacing.sm),
            ],
            Flexible(
              child: Text(
                texto,
                style: AppText.button,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class PainelJanela extends StatelessWidget {
  const PainelJanela({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(AppSpacing.lg),
    decoration: BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppSpacing.radius),
      boxShadow: const [AppShadows.card],
    ),
    child: child,
  );
}

class CardEspaco extends StatelessWidget {
  const CardEspaco({
    super.key,
    required this.espaco,
    required this.situacao,
    required this.onTap,
  });
  final Espaco espaco;
  final SituacaoEspaco situacao;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Semantics(
        button: true,
        child: Material(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.radius),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(espaco.nome, style: AppText.cardTitle),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '${espaco.andar}º andar · ${rotuloTipo[espaco.tipo]} · ${espaco.capacidade} lugares',
                    style: AppText.label,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SeloStatus(situacao.status),
                  const SizedBox(height: AppSpacing.sm),
                  Text(situacao.descricao, style: AppText.timeValue),
                  const SizedBox(height: AppSpacing.sm),
                  const Text('Ver agenda e horários', style: AppText.body),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

class CabecalhoSecao extends StatelessWidget {
  const CabecalhoSecao(this.titulo, {super.key, this.descricao});
  final String titulo;
  final String? descricao;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.lg),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(titulo, style: AppText.cardTitle),
        if (descricao != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(descricao!, style: AppText.body),
        ],
      ],
    ),
  );
}

class LinhaHorario extends StatelessWidget {
  const LinhaHorario({
    super.key,
    required this.horario,
    required this.descricao,
    this.acao,
  });
  final Horario horario;
  final String descricao;
  final Widget? acao;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: AppSpacing.md),
    child: PainelJanela(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(horario.rotulo, style: AppText.timeValue),
          const SizedBox(height: AppSpacing.sm),
          Text(descricao, style: AppText.body),
          if (acao != null) ...[const SizedBox(height: AppSpacing.md), acao!],
        ],
      ),
    ),
  );
}

class BarraGrafico extends StatelessWidget {
  const BarraGrafico({
    super.key,
    required this.rotulo,
    required this.valor,
    required this.proporcao,
    this.cor = AppColors.statusOcupado,
  });
  final String rotulo;
  final String valor;
  final double proporcao;
  final Color cor;
  @override
  Widget build(BuildContext context) => Semantics(
    label: '$rotulo: $valor',
    excludeSemantics: true,
    child: Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(rotulo, style: AppText.body),
          Text(valor, style: AppText.timeValue),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) => Container(
              height: AppSpacing.md,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: AppColors.slotDim,
                borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              ),
              alignment: Alignment.centerLeft,
              child: Container(
                width: constraints.maxWidth * proporcao.clamp(0, 1),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class EstadoVazio extends StatelessWidget {
  const EstadoVazio({
    super.key,
    required this.mensagem,
    required this.acao,
    required this.onPressed,
  });
  final String mensagem;
  final String acao;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => PainelJanela(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.search_off, color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.md),
        Text(mensagem, style: AppText.body),
        const SizedBox(height: AppSpacing.lg),
        BotaoJanela(texto: acao, onPressed: onPressed, secundario: true),
      ],
    ),
  );
}

Future<bool> confirmarAcao(
  BuildContext context, {
  required String titulo,
  required String mensagem,
  required String confirmar,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo, style: AppText.cardTitle),
        content: Text(mensagem, style: AppText.body),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Manter reserva'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmar),
          ),
        ],
      ),
    ) ??
    false;

void mostrarMensagem(BuildContext context, String mensagem) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Text(mensagem, style: AppText.body),
      backgroundColor: AppColors.surfaceAlt,
    ),
  );
}

class ConteudoJanela extends StatelessWidget {
  const ConteudoJanela({super.key, required this.children});
  final List<Widget> children;
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          ),
        ),
      ),
    ),
  );
}
