import 'package:flutter_test/flutter_test.dart';
import 'package:neurai_app/views/contents/calendario_semanal.dart';

void main() {
  test('calcula o domingo da semana da data selecionada', () {
    final inicio = CalendarioSemanal.inicioDaSemana(DateTime(2026, 11, 4));

    expect(inicio, DateTime(2026, 11, 1));
  });

  test('mantem a data correta ao atravessar o fim do mês', () {
    final inicio = CalendarioSemanal.inicioDaSemana(DateTime(2026, 11, 2));
    final dias = List.generate(7, (index) => inicio.add(Duration(days: index)));

    expect(dias.map((dia) => dia.day), [1, 2, 3, 4, 5, 6, 7]);
    expect(dias.map((dia) => dia.weekday % DateTime.daysPerWeek), [
      0,
      1,
      2,
      3,
      4,
      5,
      6,
    ]);
  });
}
