import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:neurai_app/views/cadastro_page.dart';

void main() {
  testWidgets('mostra os erros de nome e senha na tela de cadastro', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: CadastroPage()));

    final campos = find.byType(TextFormField);
    await tester.enterText(campos.at(0), 'Al');
    await tester.enterText(campos.at(1), 'aluno@example.com');
    await tester.enterText(campos.at(2), '12345');
    final botaoContinuar = find.text('Continuar cadastro');
    await tester.ensureVisible(botaoContinuar);
    await tester.tap(botaoContinuar);
    await tester.pumpAndSettle();

    expect(
      find.text('O nome deve ter pelo menos 3 caracteres.'),
      findsOneWidget,
    );
    expect(
      find.text('A senha deve ter pelo menos 6 caracteres.'),
      findsOneWidget,
    );
    expect(find.text('Preencha nome, e-mail e senha.'), findsNothing);
    expect(find.text('Cadastro da criança'), findsNothing);
  });
}
