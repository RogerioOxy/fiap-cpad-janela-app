import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/login_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const JanelaApp());
}

/// Raiz do Janela.
///
/// O `ThemeData` fica deliberadamente enxuto, com três coisas só:
/// `colorScheme` semeado pelo âmbar da marca, `useMaterial3` e o `textTheme`
/// global do Poppins. É exatamente o que o material do semestre ensina.
/// `elevatedButtonTheme`, `inputDecorationTheme`, `cardTheme` e `appBarTheme`
/// não aparecem em nenhum dos seis PDFs da disciplina (verificado por busca),
/// e `ThemeData` global customizado, `ThemeExtension` e Design Tokens são o
/// anúncio da Aula 17, que ainda não foi dada. Estilo de componente, portanto,
/// fica inline por instância, com `ElevatedButton.styleFrom` e
/// `InputDecoration`, que é como as aulas fazem.
class JanelaApp extends StatelessWidget {
  const JanelaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Janela',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // A semente é o âmbar da marca. Semeando com um neutro azul, os
        // detalhes que o Material 3 distribui de graça (cursor, ripple, borda
        // focada, seleção de texto) sairiam azuis e criariam um segundo acento
        // por acidente, quebrando a regra de um único acento quente.
        //
        // `brightness` é parâmetro nomeado do mesmo `ColorScheme.fromSeed`
        // ensinado no Guia Prático (página 15). É o único acréscimo ao exemplo
        // dele, e existe porque o âmbar só lê como luz havendo escuro em volta:
        // sobre branco ele dá 1,83:1 e reprova qualquer critério de contraste.
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // O `textTheme` global é o que o Guia Prático (página 4) marca como
        // recomendado. A base escura entra explicitamente: sem ela, o
        // `poppinsTextTheme()` monta sobre a base do tema claro e o texto sai
        // quase preto sobre fundo escuro.
        textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
      ),
      // Rotas nomeadas já declaradas, mesmo com uma tela só. O CP5 acrescenta
      // as telas ao mapa sem mexer no `main.dart`, que é o motivo de o mapa
      // existir desde agora.
      initialRoute: '/',
      routes: {'/': (context) => const LoginScreen()},
    );
  }
}
