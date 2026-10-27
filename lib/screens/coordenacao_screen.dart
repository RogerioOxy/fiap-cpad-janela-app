import 'package:flutter/material.dart';

import '../models/agenda.dart';
import '../state/janela_state.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../widgets/janela_widgets.dart';

class CoordenacaoScreen extends StatelessWidget {
  const CoordenacaoScreen({super.key, required this.state});
  final JanelaState state;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: state,
    builder: (context, _) {
      final dados = state.repository;
      final ocupacao = dados.ocupacaoPorAndar;
      final demanda = dados.demandaPorHora.entries.toList()
        ..sort(
          (a, b) => b.value == a.value
              ? a.key.compareTo(b.key)
              : b.value.compareTo(a.value),
        );
      final maximo = demanda.fold<int>(
        0,
        (maior, item) => item.value > maior ? item.value : maior,
      );
      return Scaffold(
        appBar: AppBar(
          title: const Text('Coordenação'),
          actions: [
            IconButton(
              tooltip: 'Sair para a Entrada',
              icon: const Icon(Icons.logout),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        body: SafeArea(
          child: ConteudoJanela(
            children: [
              const Text('Campus em números.', style: AppText.screenTitle),
              const Text(
                'Agenda simulada. Reserva não comprova presença física.',
                style: AppText.body,
              ),
              const CabecalhoSecao(
                'Ocupação simulada por andar',
                descricao: 'Usos ativos agora, incluindo aulas e reservas. Manutenção aparece separadamente.',
              ),
              for (final item in ocupacao.entries)
                BarraGrafico(
                  key: ValueKey('ocupacao-${item.key}'),
                  rotulo: '${item.key}º andar',
                  valor:
                      '${item.value.ocupados}/${item.value.total} ocupados · ${item.value.manutencao} em manutenção',
                  proporcao: item.value.proporcao,
                ),
              const CabecalhoSecao(
                'Horários mais pedidos',
                descricao: 'Demanda declarada: reservas de hoje, pelo horário de início.',
              ),
              for (final item in demanda)
                BarraGrafico(
                  key: ValueKey('demanda-${item.key}'),
                  rotulo: hora(DateTime(2026, 1, 1, item.key)),
                  valor: '${item.value} reservas',
                  proporcao: maximo == 0 ? 0 : item.value / maximo,
                  cor: AppColors.statusManutencao,
                ),
            ],
          ),
        ),
      );
    },
  );
}
