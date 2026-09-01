// Testes de widget da tela de entrada.
//
// O template do `flutter create` vem com um teste do contador de exemplo. Como
// o contador foi substituído pela tela de entrada do Janela, aquele teste
// deixaria de compilar e apareceria como `error` no `flutter analyze`, o que
// contraria o critério "projeto Flutter inicial funcional (builda sem erros)"
// do Checkpoint 4.
//
// O teste da identificação existe por um motivo concreto: nome e RM dos dois
// integrantes são requisito de entrega, e o enunciado diz que o papel de cada
// membro é obrigatório na documentação. Se alguém editar a tela e remover a
// identificação, o teste falha em vez de a entrega sair sem ela.

import 'package:flutter_test/flutter_test.dart';

import 'package:janela_app/data/espacos_mock.dart';
import 'package:janela_app/main.dart';

void main() {
  testWidgets('a tela de entrada mostra marca e proposta de valor', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());

    expect(find.text('Janela'), findsOneWidget);
    expect(find.text('Salas livres agora, e até que horário.'), findsOneWidget);
    expect(find.text('Ver salas livres agora'), findsOneWidget);
    expect(find.text('Entrar como coordenação'), findsOneWidget);
  });

  testWidgets('a identificação dos dois integrantes está na tela', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());

    final identificacao = find.textContaining('RM561942');
    expect(identificacao, findsOneWidget);
    expect(find.textContaining('RM562686'), findsOneWidget);
    expect(find.textContaining('Rogério Deligi'), findsOneWidget);
    expect(find.textContaining('Maria Fernanda'), findsOneWidget);
  });

  testWidgets('o botão principal informa a contagem real do mock', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());

    final livres = contarPorStatus(StatusEspaco.livre);
    await tester.tap(find.text('Ver salas livres agora'));
    await tester.pump();

    expect(
      find.textContaining('$livres de ${espacos.length} espaços livres'),
      findsOneWidget,
    );
  });

  test('o mock cobre os três status e os três tipos de espaço', () {
    // A cobertura de casos do mock é o que faz a interface ser exercitada por
    // inteiro. Este teste garante que ela não se perde quando alguém editar a
    // lista.
    for (final status in StatusEspaco.values) {
      expect(
        contarPorStatus(status),
        greaterThan(0),
        reason: 'nenhum espaço com status $status',
      );
    }
    for (final tipo in TipoEspaco.values) {
      expect(
        espacos.where((e) => e.tipo == tipo),
        isNotEmpty,
        reason: 'nenhum espaço do tipo $tipo',
      );
    }
    expect(
      andaresDisponiveis.length,
      greaterThanOrEqualTo(3),
      reason: 'o filtro por andar precisa de pelo menos três andares',
    );
  });

  test('espaço livre não declara uso atual, e ocupado declara', () {
    for (final e in espacos) {
      if (e.status == StatusEspaco.livre) {
        expect(
          e.usoAtual,
          isNull,
          reason: '${e.nome} está livre e tem usoAtual',
        );
        expect(
          e.horarios,
          isNotEmpty,
          reason: '${e.nome} está livre e não oferece horário',
        );
      }
      if (e.status == StatusEspaco.ocupado) {
        expect(
          e.usoAtual,
          isNotNull,
          reason: '${e.nome} está ocupado e não diz por quê',
        );
        expect(
          e.livreApartirDe,
          isNotNull,
          reason: '${e.nome} está ocupado e não diz quando libera',
        );
      }
      if (e.status == StatusEspaco.manutencao) {
        expect(
          e.horarios,
          isEmpty,
          reason: '${e.nome} está em manutenção e oferece horário',
        );
      }
    }
  });
}
