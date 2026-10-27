import 'package:flutter/material.dart';

import '../models/espaco.dart';
import '../state/janela_state.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text.dart';
import '../widgets/janela_widgets.dart';
import 'reserva_screen.dart';

class DetalheScreen extends StatelessWidget {
  const DetalheScreen({super.key, required this.state, required this.espaco});
  final JanelaState state;
  final Espaco espaco;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) {
      final dados = state.repository;
      final situacao = dados.situacao(espaco.id);
      final agenda = dados.agenda(espaco.id);
      final agora = dados.relogio();
      final horarios = dados.horarios;
      final passados = horarios.where((h) => !h.fim.isAfter(agora)).length;
      final restantes = horarios.where((h) => h.fim.isAfter(agora));
      return Scaffold(
        appBar: AppBar(title: Text(espaco.nome)),
        body: SafeArea(
          child: ConteudoJanela(
            children: [
              SeloStatus(situacao.status),
              const SizedBox(height: AppSpacing.lg),
              Text(situacao.descricao, style: AppText.timeValue),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '${espaco.andar}º andar · ${rotuloTipo[espaco.tipo]} · ${espaco.capacidade} lugares',
                style: AppText.body,
              ),
              const CabecalhoSecao('Recursos'),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final recurso in espaco.recursos)
                    Chip(label: Text(recurso)),
                ],
              ),
              const CabecalhoSecao('Uso atual'),
              Text(
                situacao.usoAtual?.descricao ?? 'Nenhum uso neste momento.',
                style: AppText.body,
              ),
              const CabecalhoSecao('Próximo uso'),
              Text(
                situacao.proximoUso == null
                    ? 'Nenhum uso agendado depois de agora.'
                    : '${situacao.proximoUso!.descricao}, das ${situacao.proximoUso!.horario.rotulo}.',
                style: AppText.body,
              ),
              const CabecalhoSecao(
                'Horários oferecidos hoje',
                descricao: 'Cada reserva ocupa uma hora. Consulte o resumo antes de confirmar.',
              ),
              if (dados.disponiveis(espaco.id).isEmpty)
                EstadoVazio(
                  mensagem: 'Nenhum horário livre para reservar neste espaço hoje. Consulte outro espaço na lista.',
                  acao: 'Voltar aos espaços',
                  onPressed: () => Navigator.pop(context),
                ),
              if (passados > 0) ...[
                Text(
                  '$passados horários de hoje já passaram',
                  style: AppText.label,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              for (final horario in restantes)
                LinhaHorario(
                  key: ValueKey('horario-${horario.inicio.hour}'),
                  horario: horario,
                  descricao: horario.inicio.isBefore(agora)
                      ? 'Em andamento'
                      : dados.impedimento(espaco.id, horario) ??
                            'Livre para reservar.',
                  acao: dados.impedimento(espaco.id, horario) != null
                      ? null
                      : BotaoJanela(
                          texto: 'Reservar ${horario.rotulo}',
                          onPressed: () async {
                            final confirmou = await Navigator.push<bool>(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReservaScreen(
                                  state: state,
                                  espaco: espaco,
                                  horario: horario,
                                ),
                              ),
                            );
                            if (context.mounted && confirmou == true) {
                              Navigator.pop(context, true);
                            }
                          },
                        ),
                ),
              const CabecalhoSecao('Agenda do dia'),
              if (agenda.isEmpty)
                const Text(
                  'Sem aulas ou reservas agendadas hoje.',
                  style: AppText.body,
                ),
              for (final uso in agenda)
                LinhaHorario(horario: uso.horario, descricao: uso.descricao),
            ],
          ),
        ),
      );
    },
  );
}
