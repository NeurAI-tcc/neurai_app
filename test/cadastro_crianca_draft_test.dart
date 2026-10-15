import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neurai_app/models/cadastro_crianca_draft.dart';

void main() {
  test('serializa cadastro e converte imagens e laudo para Base64', () async {
    final cadastro = CadastroCriancaDraft(
      nomeCompleto: 'Responsável',
      email: 'responsavel@example.com',
      senha: 'senha-segura',
    );
    cadastro.text('crianca_nome').text = 'Criança';
    cadastro.text('nome_social').text = 'Ana';
    cadastro.text('observacoes').text = 'Precisa de rotina previsível.';
    cadastro.text('atividades_favoritas').text = 'Música, blocos';
    cadastro.text('gatilhos').text = 'Barulho alto';
    cadastro.text('o_que_acalma').text = 'Abraço; música';
    cadastro.text('medicamentos').text = 'Remédio A - 08:00\nRemédio B - 20:00';
    cadastro.text('atividades_terapeuticas').text = 'Fonoaudiologia';
    cadastro.setValue('condicoes_saude', ['Epilepsia']);
    cadastro.setValue('alergias', ['Poeira']);
    cadastro.setValue('data_nascimento', DateTime(2019, 4, 12));
    cadastro.setValue('sexo', 'Feminino');
    cadastro.setValue('diagnostico', 'TEA');
    cadastro.setValue('data_diagnostico', DateTime(2023, 8, 3));
    cadastro.setValue('nivel_suporte', 'Nível 2');
    cadastro.setValue('frequencia_crises', 'Raramente');
    cadastro.setValue('comunicacao', 'Verbal');
    cadastro.setValue('horario_acordar', '07:00');
    cadastro.setValue('horario_dormir', '20:30');
    cadastro.setValue('laudo_nome', 'laudo.pdf');
    cadastro.setValue('usa_medicacao', true);
    cadastro.setValue('possui_crises', true);
    cadastro.setValue('faz_soneca', true);
    cadastro.setValue('alimentacao', 'Dieta especial');
    cadastro.setValue('seletividade_alimentar', false);

    final imageBytes = List.generate(
      6,
      (index) => Uint8List.fromList([index + 1, index + 11]),
    );
    final profileBytes = Uint8List.fromList([99, 98]);
    cadastro.fotoPerfil = XFile.fromData(profileBytes, name: 'perfil.png');
    cadastro.fotos.addAll([
      ...imageBytes.map((bytes) => XFile.fromData(bytes, name: 'captura.png')),
      XFile.fromData(Uint8List.fromList([7, 17]), name: 'extra.png'),
    ]);
    cadastro.laudoBytes = Uint8List.fromList([99, 100, 101]);

    final result = await cadastro.toJson();
    final perfil = result['perfil_crianca'] as Map<String, dynamic>;

    expect(result['tipo_usuario'], 'Responsavel');
    expect(result['nome_completo'], 'Responsável');
    expect(result['email'], 'responsavel@example.com');
    expect(result['senha'], 'senha-segura');
    expect(result['valor'], 50.0);
    expect(perfil.keys.toSet(), {
      'nome_completo',
      'nome_social',
      'data_nascimento',
      'sexo',
      'diagnostico',
      'data_diagnostico',
      'nivel_suporte',
      'frequencia_crises',
      'condicoes',
      'alergias',
      'usa_medicamentos',
      'medicacoes',
      'possui_crises_epilepticas',
      'comunicacao',
      'atividades_favoritas',
      'gatilhos',
      'o_que_ajuda_acalmar',
      'horario_acordar',
      'horario_dormir',
      'possui_sonecas',
      'alimentacao',
      'seletividade_alimentar',
      'atividades',
      'observacoes',
      'laudo_nome',
      'foto_perfil_url',
      'foto_frente_url',
      'foto_direita_url',
      'foto_esquerda_url',
      'foto_cima_url',
      'foto_baixo_url',
      'foto_sorrindo_url',
      'laudo_url',
    });
    expect(perfil['nome_completo'], 'Criança');
    expect(perfil['nome_social'], 'Ana');
    expect(perfil['data_nascimento'], '2019-04-12T00:00:00.000');
    expect(perfil['sexo'], 'Feminino');
    expect(perfil['diagnostico'], 'TEA');
    expect(perfil['data_diagnostico'], '2023-08-03T00:00:00.000');
    expect(perfil['nivel_suporte'], 'Nível 2');
    expect(perfil['frequencia_crises'], 'Raramente');
    expect(perfil['condicoes'], ['Epilepsia']);
    expect(perfil['alergias'], ['Poeira']);
    expect(perfil['usa_medicamentos'], isTrue);
    expect(perfil['medicacoes'], [
      {'nome': 'Remédio A', 'horario': '08:00'},
      {'nome': 'Remédio B', 'horario': '20:00'},
    ]);
    expect(perfil['possui_crises_epilepticas'], isTrue);
    expect(perfil['comunicacao'], 'Verbal');
    expect(perfil['atividades_favoritas'], ['Música', 'blocos']);
    expect(perfil['gatilhos'], ['Barulho alto']);
    expect(perfil['o_que_ajuda_acalmar'], ['Abraço', 'música']);
    expect(perfil['horario_acordar'], '07:00');
    expect(perfil['horario_dormir'], '20:30');
    expect(perfil['possui_sonecas'], isTrue);
    expect(perfil['alimentacao'], ['Dieta especial']);
    expect(perfil['seletividade_alimentar'], isFalse);
    expect(perfil['atividades'], ['Fonoaudiologia']);
    expect(perfil['observacoes'], 'Precisa de rotina previsível.');
    expect(perfil['laudo_nome'], 'laudo.pdf');
    expect(perfil['foto_perfil_url'], base64Encode(profileBytes));
    expect(perfil['foto_frente_url'], base64Encode(imageBytes[0]));
    expect(perfil['foto_frente_url'], base64Encode(imageBytes[0]));
    expect(perfil['foto_direita_url'], base64Encode(imageBytes[1]));
    expect(perfil['foto_esquerda_url'], base64Encode(imageBytes[2]));
    expect(perfil['foto_cima_url'], base64Encode(imageBytes[3]));
    expect(perfil['foto_baixo_url'], base64Encode(imageBytes[4]));
    expect(perfil['foto_sorrindo_url'], base64Encode(imageBytes[5]));
    expect(
      perfil['laudo_url'],
      base64Encode(Uint8List.fromList([99, 100, 101])),
    );
    cadastro.dispose();
  });

  test('envia null para imagens e laudo opcionais ausentes', () async {
    final cadastro = CadastroCriancaDraft(
      nomeCompleto: 'Responsável',
      email: 'responsavel@example.com',
      senha: 'senha-segura',
    );

    final result = await cadastro.toJson();
    final perfil = result['perfil_crianca'] as Map<String, dynamic>;

    expect(perfil['foto_perfil_url'], isNull);
    expect(perfil['foto_frente_url'], isNull);
    expect(perfil['foto_direita_url'], isNull);
    expect(perfil['foto_esquerda_url'], isNull);
    expect(perfil['foto_cima_url'], isNull);
    expect(perfil['foto_baixo_url'], isNull);
    expect(perfil['foto_sorrindo_url'], isNull);
    expect(perfil['laudo_url'], isNull);
    cadastro.dispose();
  });

  test('serializa câmera junto dos dados acumulados no cadastro', () async {
    final cadastro = CadastroCriancaDraft(
      nomeCompleto: 'Responsável',
      email: 'responsavel@example.com',
      senha: 'senha-segura',
    );
    cadastro.text('crianca_nome').text = 'Criança';
    cadastro.text('nome_social').text = 'Ana';
    cadastro.text('observacoes').text = 'Acompanha fonoaudiologia.';
    cadastro.text('gatilhos').text = 'Barulho alto';
    cadastro.setValue('condicoes_saude', ['Epilepsia']);
    cadastro.setValue('sexo', 'Feminino');
    cadastro.setValue('diagnostico', 'TEA');
    cadastro.setValue('horario_acordar', '07:30');
    cadastro.fotos.addAll(
      List.generate(
        7,
        (_) => XFile.fromData(Uint8List.fromList([1, 2, 3]), name: 'foto.png'),
      ),
    );
    cadastro.setCamera({
      'endereco_ip': '192.168.1.10',
      'nome': 'Quarto',
      'localizacao': 'Quarto da criança',
      'modelo': 'Intelbras iM3',
    });

    final payload = await cadastro.toJson();
    final perfil = payload['perfil_crianca'] as Map<String, dynamic>;
    expect(payload['nome_completo'], 'Responsável');
    expect(payload['camera'], {
      'endereco_ip': '192.168.1.10',
      'nome': 'Quarto',
      'localizacao': 'Quarto da criança',
      'modelo': 'Intelbras iM3',
    });
    expect(perfil['nome_completo'], 'Criança');
    expect(perfil['nome_social'], 'Ana');
    expect(perfil['sexo'], 'Feminino');
    expect(perfil['diagnostico'], 'TEA');
    expect(perfil['condicoes'], ['Epilepsia']);
    expect(perfil['gatilhos'], ['Barulho alto']);
    expect(perfil['horario_acordar'], '07:30');
    expect(perfil['observacoes'], 'Acompanha fonoaudiologia.');
    expect(perfil['foto_frente_url'], base64Encode([1, 2, 3]));
    cadastro.dispose();
  });
}
