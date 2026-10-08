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
    cadastro.text('atividades_favoritas').text = 'Música, blocos';
    cadastro.text('gatilhos').text = 'Barulho alto';
    cadastro.text('o_que_acalma').text = 'Abraço; música';
    cadastro.text('medicamentos').text =
        'Remédio A - 08:00\nRemédio B - 20:00';
    cadastro.text('atividades_terapeuticas').text = 'Fonoaudiologia';
    cadastro.setValue('condicoes_saude', ['Epilepsia']);
    cadastro.setValue('alergias', ['Poeira']);
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
    cadastro.fotos.addAll(
      [
        ...imageBytes.map(
          (bytes) => XFile.fromData(bytes, name: 'captura.png'),
        ),
        XFile.fromData(Uint8List.fromList([7, 17]), name: 'extra.png'),
      ],
    );
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
      'condicoes',
      'alergias',
      'usa_medicamentos',
      'medicacoes',
      'possui_crises_epilepticas',
      'atividades_favoritas',
      'gatilhos',
      'o_que_ajuda_acalmar',
      'possui_sonecas',
      'alimentacao',
      'seletividade_alimentar',
      'atividades',
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
    expect(perfil['condicoes'], ['Epilepsia']);
    expect(perfil['alergias'], ['Poeira']);
    expect(perfil['usa_medicamentos'], isTrue);
    expect(perfil['medicacoes'], [
      {'nome': 'Remédio A', 'horario': '08:00'},
      {'nome': 'Remédio B', 'horario': '20:00'},
    ]);
    expect(perfil['possui_crises_epilepticas'], isTrue);
    expect(perfil['atividades_favoritas'], ['Música', 'blocos']);
    expect(perfil['gatilhos'], ['Barulho alto']);
    expect(perfil['o_que_ajuda_acalmar'], ['Abraço', 'música']);
    expect(perfil['possui_sonecas'], isTrue);
    expect(perfil['alimentacao'], ['Dieta especial']);
    expect(perfil['seletividade_alimentar'], isFalse);
    expect(perfil['atividades'], ['Fonoaudiologia']);
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
}
