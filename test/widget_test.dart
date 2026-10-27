import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:janela_app/data/reservas_repository.dart';
import 'package:janela_app/models/espaco.dart';
import 'package:janela_app/theme/app_text.dart';
import 'package:flutter/services.dart';
import 'package:janela_app/main.dart';

void main() {
  testWidgets('a tela de entrada mostra marca e proposta de valor', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));

    expect(find.text('Janela'), findsOneWidget);
    expect(find.text('Salas livres agora, e até que horário.'), findsOneWidget);
    expect(find.text('Ver salas livres agora'), findsOneWidget);
    expect(find.text('Entrar como coordenação'), findsOneWidget);
  });

  testWidgets('a identificação dos dois integrantes está na tela', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));

    final identificacao = find.textContaining('RM561942');
    expect(identificacao, findsOneWidget);
    expect(find.textContaining('RM562686'), findsOneWidget);
    expect(find.textContaining('Rogério Deligi'), findsOneWidget);
    expect(find.textContaining('Maria Fernanda'), findsOneWidget);
  });

  testWidgets('o botão principal informa a contagem real do mock', (
    WidgetTester tester,
  ) async {
    final dados = ReservasRepository(relogio: () => DateTime(2026, 10, 27, 14));
    await tester.pumpWidget(JanelaApp(repository: dados));
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    final livres = dados.contagens[StatusEspaco.livre];
    await tester.tap(find.text('Ver salas livres agora'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(
        '$livres de ${dados.inventario.length} espaços livres',
      ),
      findsOneWidget,
    );
  });

  testWidgets('fontes locais e pesos variáveis estão empacotados', (
    tester,
  ) async {
    await tester.pumpWidget(const JanelaApp());
    addTearDown(() => tester.pumpWidget(const SizedBox.shrink()));
    for (final fonte in [
      'Poppins-Regular.ttf',
      'Poppins-Medium.ttf',
      'Poppins-SemiBold.ttf',
      'Poppins-Bold.ttf',
      'JetBrainsMono-wght.ttf',
    ]) {
      expect(
        (await rootBundle.load('assets/fonts/$fonte')).lengthInBytes,
        greaterThan(0),
      );
    }
    expect(AppText.body.fontFamily, 'Poppins');
    expect(AppText.timeValue.fontFamily, 'JetBrainsMono');
    expect(AppText.timeValue.fontVariations!.single.value, 500);
    expect(AppText.numberXL.fontVariations!.single.value, 600);
  });
}
