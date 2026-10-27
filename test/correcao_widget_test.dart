import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:janela_app/data/espacos_mock.dart';
import 'package:janela_app/data/reservas_repository.dart';
import 'package:janela_app/main.dart';
import 'package:janela_app/models/agenda.dart';
import 'package:janela_app/models/espaco.dart';
import 'package:janela_app/theme/app_colors.dart';
import 'package:janela_app/theme/app_spacing.dart';
import 'package:janela_app/widgets/janela_widgets.dart';

import 'fluxos_widget_test.dart' show abrir, abrirSala, tocar;

class _ReservasComConcorrencia extends ReservasRepository {
  _ReservasComConcorrencia() : super(relogio: () => DateTime(2026, 10, 27, 14));

  final adicionais = <Reserva>[];

  @override
  List<Reserva> get reservas => [...super.reservas, ...adicionais];
}

void main() {
  for (final tamanho in [
    const Size(360, 640),
    const Size(390, 844),
    const Size(800, 900),
  ]) {
    testWidgets(
      'C01 cards preenchem a largura e filtros cabem em duas linhas em $tamanho',
      (tester) async {
        await abrir(tester);
        tester.view.physicalSize = tamanho;
        await tester.pumpAndSettle();
        await tocar(tester, find.text('Ver salas livres agora'));
        await tocar(tester, find.text('Espaços').last);

        final card = find.byType(CardEspaco).first;
        final largura =
            math.min(tamanho.width, AppSpacing.maxContentWidth) -
            2 * AppSpacing.xl;
        expect(tester.getSize(card).width, largura);
        final superficie = find.descendant(
          of: card,
          matching: find.byType(Material),
        );
        expect(tester.getSize(superficie).width, largura);
        expect(
          tester.getTopLeft(card).dy,
          lessThan(tester.getTopLeft(find.byType(NavigationBar)).dy),
        );
        expect(find.text('Limpar filtros'), findsNothing);

        for (final grupo in ['andar', 'tipo']) {
          final linha = find.byKey(ValueKey('filtros-$grupo'));
          expect(
            tester.widget<SingleChildScrollView>(linha).scrollDirection,
            Axis.horizontal,
          );
          final chips = find.descendant(
            of: linha,
            matching: find.byType(ChoiceChip),
          );
          final alturas = [
            for (var i = 0; i < chips.evaluate().length; i++)
              tester.getTopLeft(chips.at(i)).dy,
          ];
          expect(alturas.toSet(), hasLength(1));
          expect(
            tester.getTopLeft(find.byType(TextField)).dy,
            lessThan(alturas.first),
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'C02 filtros distantes são acessíveis e limpeza depende de filtro ativo',
    (tester) async {
      await abrir(tester);
      await tocar(tester, find.text('Ver salas livres agora'));
      await tocar(tester, find.text('Espaços').last);
      await tocar(tester, find.widgetWithText(ChoiceChip, '5º andar'));
      expect(find.text('Limpar filtros'), findsOneWidget);
      expect(find.byType(CardEspaco), findsNWidgets(2));
      await tocar(tester, find.text('Limpar filtros'));
      expect(find.text('Limpar filtros'), findsNothing);
      await tocar(tester, find.widgetWithText(ChoiceChip, 'Auditório'));
      expect(find.text('Limpar filtros'), findsOneWidget);
      await tocar(tester, find.text('Limpar filtros'));
      await tester.enterText(find.byType(TextField), 'Sala 104');
      await tester.pumpAndSettle();
      expect(find.text('Limpar filtros'), findsOneWidget);
      await tocar(tester, find.text('Limpar filtros'));
      expect(find.text('Limpar filtros'), findsNothing);
      expect(find.byType(CardEspaco), findsNWidgets(16));
    },
  );

  testWidgets('C03 às 18h30 oculta 07h00 e mantém 19h00 e faixa em andamento', (
    tester,
  ) async {
    var agora = DateTime(2026, 10, 27, 18, 30);
    final dados = ReservasRepository(relogio: () => agora);
    await tester.pumpWidget(JanelaApp(repository: dados));
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    await tocar(tester, find.text('Ver salas livres agora'));
    await abrirSala(tester, 'Sala 210');
    expect(find.text('07h00 às 08h00'), findsNothing);
    expect(find.byKey(const ValueKey('horario-7')), findsNothing);
    expect(find.text('19h00 às 20h00'), findsOneWidget);
    expect(find.text('11 horários de hoje já passaram'), findsOneWidget);
    final atual = find.byKey(const ValueKey('horario-18'));
    expect(
      find.descendant(of: atual, matching: find.text('Em andamento')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: atual, matching: find.byType(BotaoJanela)),
      findsNothing,
    );
    await tester.ensureVisible(find.text('Reservar 19h00 às 20h00'));
    expect(find.text('Reservar 19h00 às 20h00').hitTestable(), findsOneWidget);
    agora = DateTime(2026, 10, 27, 19);
    await tester.pump(const Duration(minutes: 1));
    expect(find.byKey(const ValueKey('horario-18')), findsNothing);
    expect(find.text('12 horários de hoje já passaram'), findsOneWidget);
    expect(find.text('Reservar 19h00 às 20h00'), findsOneWidget);
  });

  testWidgets('C04 reserva de outro aluno no detalhe usa mensagem estável', (
    tester,
  ) async {
    await abrir(tester);
    await tocar(tester, find.text('Ver salas livres agora'));
      await abrirSala(tester, 'Auditório Central');
    final linha = find.byKey(const ValueKey('horario-14'));
    expect(
      find.descendant(
        of: linha,
        matching: find.text('Reservado por outra pessoa.'),
      ),
      findsOneWidget,
    );
    expect(find.textContaining('acabou de ser reservado'), findsNothing);
    expect(
      find.descendant(of: linha, matching: find.byType(BotaoJanela)),
      findsNothing,
    );
  });

  testWidgets(
    'C04 conflito de outra pessoa ao confirmar usa acabou de ser reservado',
    (tester) async {
      final dados = _ReservasComConcorrencia();
      await tester.pumpWidget(JanelaApp(repository: dados));
      addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
      await tocar(tester, find.text('Ver salas livres agora'));
      await abrirSala(tester, 'Sala 210');
      await tocar(tester, find.text('Reservar 14h00 às 15h00'));
      dados.adicionais.add(
        Reserva(
          id: 'concorrente',
          espacoId: 'S210',
          usuarioId: 'outro-aluno',
          horario: dados.horarios.firstWhere((h) => h.inicio.hour == 14),
        ),
      );
      await tocar(tester, find.text('Confirmar reserva'));
      expect(
        find.text(
          'Esse horário acabou de ser reservado por outra pessoa. Escolha outro.',
        ),
        findsOneWidget,
      );
      expect(find.text('Reserva confirmada'), findsNothing);
      expect(dados.minhasReservas.where((r) => r.espacoId == 'S210'), isEmpty);
    },
  );

  test(
    'C05 livre até 20h considera reserva de outro aluno e ocupação no início',
    () {
      var agora = DateTime(2026, 10, 27, 17);
      final dados = ReservasRepository(relogio: () => agora);
      final reserva = dados.reservas.firstWhere((r) => r.espacoId == 'L501');
      expect(reserva.usuarioId, isNot(usuarioAtual));
      expect(reserva.horario.inicio.hour, 20);
      expect(dados.situacao('L501').status, StatusEspaco.livre);
      expect(dados.situacao('L501').descricao, 'Livre até 20h00');
      expect(dados.situacao('L501').ate, reserva.horario.inicio);
      agora = DateTime(2026, 10, 27, 20);
      expect(dados.situacao('L501').status, StatusEspaco.ocupado);
      expect(dados.situacao('L501').usoAtual!.descricao, 'Reserva de aluno');
      expect(dados.contagens[StatusEspaco.ocupado], 1);
      expect(dados.contagens[StatusEspaco.livre], 13);
    },
  );

  test(
    'C05 livre até 20h considera reserva própria e cancelamento devolve limite',
    () {
      final dados = ReservasRepository(
        relogio: () => DateTime(2026, 10, 27, 17),
      );
      final reserva = dados.reservar(
        'S210',
        dados.horarios.firstWhere((h) => h.inicio.hour == 20),
      );
      expect(dados.situacao('S210').descricao, 'Livre até 20h00');
      expect(dados.situacao('S210').proximoUso!.descricao, 'Sua reserva');
      dados.cancelar(reserva.id);
      expect(dados.situacao('S210').descricao, 'Livre até 23h00');
    },
  );

  testWidgets(
    'C05 lista, detalhe e painel consultam reservas de outros alunos',
    (tester) async {
      var agora = DateTime(2026, 10, 27, 17);
      final dados = ReservasRepository(relogio: () => agora);
      await tester.pumpWidget(JanelaApp(repository: dados));
      addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
      await tocar(tester, find.text('Ver salas livres agora'));
      await tocar(tester, find.text('Espaços').last);
      await tester.enterText(find.byType(TextField), 'Lab de robótica');
      await tester.pumpAndSettle();
      expect(find.text('Livre até 20h00'), findsOneWidget);
      await tocar(tester, find.byType(CardEspaco));
      expect(find.text('Livre até 20h00'), findsOneWidget);
      expect(
        find.text('Reserva de aluno, das 20h00 às 21h00.'),
        findsOneWidget,
      );
      await tester.pageBack();
      await tester.pumpAndSettle();
      await tocar(tester, find.text('Início').last);
      agora = DateTime(2026, 10, 27, 20);
      await tester.pump(const Duration(minutes: 1));
      expect(dados.situacao('L501').status, StatusEspaco.ocupado);
      expect(
        find.textContaining(
          '${dados.contagens[StatusEspaco.livre]} de 16 espaços livres',
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('C06 diálogo de cancelamento usa superfície sem tonalização', (
    tester,
  ) async {
    await abrir(tester);
    await tocar(tester, find.text('Ver salas livres agora'));
    await tocar(tester, find.text('Reservas'));
    await tocar(tester, find.text('Cancelar reserva'));
    expect(find.text('Cancelar reserva?'), findsOneWidget);
    final dialogo = find.byType(Dialog);
    final superficie = tester.widget<Material>(
      find.descendant(of: dialogo, matching: find.byType(Material)).first,
    );
    expect(superficie.color, AppColors.surface);
    expect(superficie.surfaceTintColor, Colors.transparent);
    await tocar(tester, find.text('Manter reserva'));
    expect(find.text('Cancelar reserva'), findsOneWidget);
  });
}
