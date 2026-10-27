import 'package:flutter/material.dart';

import '../models/agenda.dart';
import '../models/espaco.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/janela_widgets.dart';

class GuiaVisualScreen extends StatelessWidget {
  const GuiaVisualScreen({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Guia visual')),
    body: const SafeArea(child: GuiaVisualConteudo()),
  );
}

class GuiaVisualConteudo extends StatelessWidget {
  const GuiaVisualConteudo({super.key});

  static const cores = {
    'primary': AppColors.primary,
    'primaryDark': AppColors.primaryDark,
    'onPrimary': AppColors.onPrimary,
    'primaryInk': AppColors.primaryInk,
    'background': AppColors.background,
    'surface': AppColors.surface,
    'surfaceAlt': AppColors.surfaceAlt,
    'textPrimary': AppColors.textPrimary,
    'textSecondary': AppColors.textSecondary,
    'border': AppColors.border,
    'divider': AppColors.divider,
    'slotDim': AppColors.slotDim,
    'statusLivre': AppColors.statusLivre,
    'statusOcupado': AppColors.statusOcupado,
    'statusManutencao': AppColors.statusManutencao,
  };
  static const estilos = {
    'brandTitle': AppText.brandTitle,
    'screenTitle': AppText.screenTitle,
    'cardTitle': AppText.cardTitle,
    'body': AppText.body,
    'button': AppText.button,
    'statusLabel': AppText.statusLabel,
    'label': AppText.label,
    'timeValue': AppText.timeValue,
    'numberXL': AppText.numberXL,
  };
  static const espacos = {
    'xs': AppSpacing.xs,
    'sm': AppSpacing.sm,
    'md': AppSpacing.md,
    'lg': AppSpacing.lg,
    'xl': AppSpacing.xl,
    'xxl': AppSpacing.xxl,
  };

  @override
  Widget build(BuildContext context) => ConteudoJanela(
    children: [
      const Text('A identidade em uso.', style: AppText.screenTitle),
      const Text(
        'Tema escuro, âmbar para ação e marca. Estado usa cor, ícone e palavra.',
        style: AppText.body,
      ),
      const CabecalhoSecao(
        'Paleta',
        descricao: 'Amostras ligadas diretamente a AppColors. primaryInk é exclusivo da marca sobre fundo claro.',
      ),
      for (final item in cores.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: AppSpacing.buttonHeight,
                height: AppSpacing.buttonHeight,
                decoration: BoxDecoration(
                  color: item.value,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppSpacing.radius),
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.key, style: AppText.body),
                    Text(
                      '#${item.value.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                      style: AppText.timeValue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      const CabecalhoSecao(
        'Tipografia',
        descricao: 'Poppins na interface. JetBrains Mono nas horas e contagens. Fontes locais.',
      ),
      for (final item in estilos.entries) ...[
        Text(
          '${item.key} · ${item.value.fontFamily} · ${item.value.fontSize!.toInt()}',
          style: AppText.label,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(switch (item.key) {
          'timeValue' => '14h00 às 15h00',
          'numberXL' => '08',
          _ => 'Seu tempo tem lugar.',
        }, style: item.value.copyWith(color: AppColors.textPrimary)),
        const SizedBox(height: AppSpacing.xl),
      ],
      const CabecalhoSecao(
        'Espaçamento',
        descricao: 'Régua AppSpacing, em múltiplos de quatro.',
      ),
      for (final item in espacos.entries)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${item.key} · ${item.value.toInt()}',
                  style: AppText.timeValue,
                ),
              ),
              Container(
                width: item.value,
                height: AppSpacing.lg,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      const Text('Raio de card e botão', style: AppText.label),
      Text('radius: ${AppSpacing.radius.toInt()}', style: AppText.timeValue),
      const Text('Raio de pílula', style: AppText.label),
      Text(
        'radiusPill: ${AppSpacing.radiusPill.toInt()}',
        style: AppText.timeValue,
      ),
      const Text('Toque mínimo', style: AppText.label),
      Text(
        'buttonHeight: ${AppSpacing.buttonHeight.toInt()}',
        style: AppText.timeValue,
      ),
      const CabecalhoSecao(
        'Componentes',
        descricao: 'As mesmas classes usadas nas telas, com AppShadows.card e AppShadows.accentGlow.',
      ),
      for (final status in StatusEspaco.values) ...[
        SeloStatus(status),
        const SizedBox(height: AppSpacing.md),
      ],
      BotaoJanela(
        texto: 'Botão primário',
        onPressed: () => mostrarMensagem(
          context,
          'Ação principal: âmbar, com texto escuro.',
        ),
      ),
      const SizedBox(height: AppSpacing.md),
      BotaoJanela(
        texto: 'Botão secundário',
        secundario: true,
        onPressed: () =>
            mostrarMensagem(context, 'Ação secundária: superfície elevada.'),
      ),
      const SizedBox(height: AppSpacing.xl),
      CardEspaco(
        espaco: const Espaco(
          id: 'exemplo',
          nome: 'Sala de exemplo',
          tipo: TipoEspaco.sala,
          andar: 2,
          capacidade: 28,
          recursos: ['Lousa'],
        ),
        situacao: const SituacaoEspaco(
          status: StatusEspaco.livre,
          descricao: 'Livre até 15h00',
        ),
        onTap: () => mostrarMensagem(
          context,
          'Exemplo de card. Consulte os espaços na aba Espaços.',
        ),
      ),
      LinhaHorario(
        horario: Horario(DateTime(2026, 1, 1, 14), DateTime(2026, 1, 1, 15)),
        descricao: 'Linha de horário · JetBrains Mono',
      ),
      const BarraGrafico(
        rotulo: 'Barra de exemplo',
        valor: '2/4 espaços',
        proporcao: .5,
      ),
      EstadoVazio(
        mensagem: 'Nenhum espaço combina com estes filtros. Consulte outros andares e tipos.',
        acao: 'Exemplo de estado vazio',
        onPressed: () =>
            mostrarMensagem(context, 'A mensagem oferece uma próxima opção.'),
      ),
      const SizedBox(height: AppSpacing.lg),
      BotaoJanela(
        texto: 'Exemplo de confirmação',
        secundario: true,
        onPressed: () {
          confirmarAcao(
            context,
            titulo: 'Cancelar reserva?',
            mensagem: 'Exemplo visual. O horário fica livre para outra pessoa.',
            confirmar: 'Confirmar cancelamento',
          );
        },
      ),
    ],
  );
}
