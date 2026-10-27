import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janela_app/data/reservas_repository.dart';
import 'package:janela_app/main.dart';
import 'package:janela_app/models/espaco.dart';
import 'package:janela_app/screens/guia_visual_screen.dart';
import 'package:janela_app/theme/app_colors.dart';
import 'package:janela_app/widgets/janela_widgets.dart';

Future<void> tocar(WidgetTester tester, Finder alvo) async {
  await tester.ensureVisible(alvo);
  await tester.tap(alvo);
  await tester.pumpAndSettle();
}

Future<ReservasRepository> abrir(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  final dados = ReservasRepository(relogio: () => DateTime(2026, 10, 27, 14));
  await tester.pumpWidget(JanelaApp(repository: dados));
  addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
  return dados;
}

Future<void> abrirSala(WidgetTester tester, String nome) async {
  await tocar(tester, find.text('Espaços').last);
  await tester.enterText(find.byType(TextField), nome);
  await tester.pumpAndSettle();
  await tocar(tester, find.widgetWithText(CardEspaco, nome));
}

void main() {
  testWidgets(
    'F01 Espaços combina andar, tipo e busca e oferece saída do vazio',
    (tester) async {
      await abrir(tester);
      await tocar(tester, find.text('Ver salas livres agora'));
      await tocar(tester, find.text('Encontrar um espaço'));
      await tocar(tester, find.widgetWithText(ChoiceChip, '2º andar'));
      await tocar(tester, find.widgetWithText(ChoiceChip, 'Laboratório'));
      expect(find.byType(CardEspaco), findsNWidgets(2));
      expect(find.text('Lab 201'), findsOneWidget);
      expect(find.text('Sala 210'), findsNothing);
      await tester.enterText(find.byType(TextField), 'inexistente');
      await tester.pumpAndSettle();
      expect(find.byType(EstadoVazio), findsOneWidget);
      await tocar(tester, find.text('Ver todos os espaços'));
      expect(find.byType(CardEspaco), findsNWidgets(16));
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );

  testWidgets(
    'F02 detalhe, resumo, reserva, confirmação e cancelamento devolvem horário',
    (tester) async {
      final dados = await abrir(tester);
      await tocar(tester, find.text('Ver salas livres agora'));
      await abrirSala(tester, 'Sala 210');
      expect(find.text('Recursos'), findsOneWidget);
      expect(find.text('Uso atual'), findsOneWidget);
      expect(find.text('Próximo uso'), findsOneWidget);
      expect(find.text('Agenda do dia'), findsOneWidget);
      await tocar(tester, find.text('Reservar 14h00 às 15h00'));
      expect(find.text('Resumo da reserva'), findsOneWidget);
      await tocar(tester, find.text('Confirmar reserva'));
      expect(find.text('Reserva confirmada'), findsOneWidget);
      expect(
        find.text('Reservado: Sala 210, das 14h00 às 15h00.'),
        findsOneWidget,
      );
      final reserva = dados.minhasReservas.firstWhere(
        (r) => r.espacoId == 'S210',
      );
      await tocar(tester, find.text('Ver minhas reservas'));
      final card = find.byKey(ValueKey('reserva-${reserva.id}'));
      expect(card, findsOneWidget);
      final cancelar = find.descendant(
        of: card,
        matching: find.text('Cancelar reserva'),
      );
      await tocar(tester, cancelar);
      expect(find.text('Cancelar reserva?'), findsOneWidget);
      await tocar(tester, find.text('Manter reserva'));
      expect(dados.minhasReservas.any((r) => r.id == reserva.id), isTrue);
      await tocar(tester, cancelar);
      await tocar(tester, find.text('Confirmar cancelamento'));
      expect(card, findsNothing);
      expect(
        find.text('Reserva cancelada. O horário voltou a ficar livre.'),
        findsOneWidget,
      );
      expect(
        dados.disponiveis('S210').any((h) => h.igual(reserva.horario)),
        isTrue,
      );
      await abrirSala(tester, 'Sala 210');
      expect(find.text('Reservar 14h00 às 15h00'), findsOneWidget);
      await tocar(tester, find.text('Reservar 14h00 às 15h00'));
      await tocar(tester, find.text('Confirmar reserva'));
      expect(find.text('Reserva confirmada'), findsOneWidget);
    },
  );

  for (final sobreposicao in [false, true]) {
    testWidgets(
      'F03 erro visível ao confirmar ${sobreposicao ? 'sobreposição' : 'horário indisponível'}',
      (tester) async {
        final dados = await abrir(tester);
        await tocar(tester, find.text('Ver salas livres agora'));
        await abrirSala(tester, 'Sala 210');
        await tocar(tester, find.text('Reservar 14h00 às 15h00'));
        final horario = dados.horarios.firstWhere((h) => h.inicio.hour == 14);
        dados.reservar(sobreposicao ? 'S104' : 'S210', horario);
        await tocar(tester, find.text('Confirmar reserva'));
        expect(
          find.text(
            sobreposicao
                ? 'Você já tem uma reserva nesse intervalo. Escolha outro horário.'
                : 'Você já reservou esse horário. Consulte suas reservas.',
          ),
          findsOneWidget,
        );
        expect(find.text('Reserva confirmada'), findsNothing);
        await tocar(tester, find.text('Escolher outro horário'));
        expect(find.text('Horários oferecidos hoje'), findsOneWidget);
      },
    );
  }

  testWidgets('F04 manutenção e aula informam bloqueios no detalhe', (
    tester,
  ) async {
    await abrir(tester);
    await tocar(tester, find.text('Ver salas livres agora'));
    await abrirSala(tester, 'Lab 305');
    expect(
      find.textContaining('Lab 305 está em manutenção hoje.'),
      findsWidgets,
    );
    expect(find.textContaining('Reservar 14h00'), findsNothing);
    await tester.pageBack();
    await tester.pumpAndSettle();
    await abrirSala(tester, 'Sala 101');
    final linha = find.byKey(const ValueKey('horario-14'));
    expect(
      find.descendant(
        of: linha,
        matching: find.text('Ocupado por aula ou uso agendado.'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: linha, matching: find.byType(BotaoJanela)),
      findsNothing,
    );
  });

  testWidgets('F05 nenhuma reserva oferece atalho e sair mantém a sessão', (
    tester,
  ) async {
    final dados = await abrir(tester);
    for (final r in dados.minhasReservas) {
      dados.cancelar(r.id);
    }
    await tocar(tester, find.text('Ver salas livres agora'));
    await tocar(tester, find.text('Reservas'));
    expect(find.textContaining('Nenhuma reserva por aqui.'), findsOneWidget);
    await tocar(tester, find.text('Encontrar um espaço'));
    expect(find.byType(TextField), findsOneWidget);
    await tocar(tester, find.byTooltip('Sair para a Entrada'));
    expect(find.text('Entrar como coordenação'), findsOneWidget);
    await tocar(tester, find.text('Ver salas livres agora'));
    await tocar(tester, find.text('Reservas'));
    expect(find.textContaining('Nenhuma reserva por aqui.'), findsOneWidget);
  });

  testWidgets('F06 coordenação desenha barras com agregações da sessão', (
    tester,
  ) async {
    final dados = await abrir(tester);
    final horario = dados.horarios.firstWhere((h) => h.inicio.hour == 14);
    dados.reservar('S210', horario);
    await tocar(tester, find.text('Entrar como coordenação'));
    expect(find.byType(BarraGrafico), findsNWidgets(21));
    final andar = tester.widget<BarraGrafico>(
      find.byKey(const ValueKey('ocupacao-2')),
    );
    expect(andar.proporcao, dados.ocupacaoPorAndar[2]!.proporcao);
    final demanda = tester.widget<BarraGrafico>(
      find.byKey(const ValueKey('demanda-14')),
    );
    expect(demanda.valor, '${dados.demandaPorHora[14]} reservas');
    expect(
      find.textContaining('Reserva não comprova presença física.'),
      findsOneWidget,
    );
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Ver salas livres agora'), findsOneWidget);
  });

  testWidgets(
    'F07 Guia visual da entrada e aba mostra tokens reais e componentes',
    (tester) async {
      await abrir(tester);
      await tocar(tester, find.text('Guia visual'));
      for (final token in GuiaVisualConteudo.cores.keys) {
        expect(find.text(token), findsOneWidget);
      }
      expect(GuiaVisualConteudo.cores['primary'], AppColors.primary);
      expect(find.text('#FFB000'), findsOneWidget);
      expect(find.text('Espaçamento'), findsOneWidget);
      expect(find.text('Componentes'), findsOneWidget);
      await tocar(tester, find.text('Exemplo de confirmação'));
      expect(find.byType(AlertDialog), findsOneWidget);
      await tocar(tester, find.text('Manter reserva'));
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tocar(tester, find.text('Ver salas livres agora'));
      await tocar(tester, find.text('Guia'));
      expect(find.text('statusLivre'), findsOneWidget);
    },
  );

  testWidgets(
    'F08 atualização pelo relógio renova o painel sem reiniciar sessão',
    (tester) async {
      var agora = DateTime(2026, 10, 27, 14);
      final dados = ReservasRepository(relogio: () => agora);
      await tester.pumpWidget(JanelaApp(repository: dados));
      addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
      await tocar(tester, find.text('Ver salas livres agora'));
      agora = agora.add(const Duration(hours: 1));
      await tester.pump(const Duration(minutes: 1));
      expect(
        find.textContaining(
          '${dados.contagens[StatusEspaco.livre]} de 16 espaços livres',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('F09 fluxo compacto com texto ampliado preserva ações', (
    tester,
  ) async {
    await abrir(tester);
    tester.view.physicalSize = const Size(360, 640);
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpAndSettle();
    await tocar(tester, find.text('Ver salas livres agora'));
    await abrirSala(tester, 'Sala 210');
    await tocar(tester, find.text('Reservar 14h00 às 15h00'));
    await tocar(tester, find.text('Confirmar reserva'));
    expect(find.text('Reserva confirmada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
