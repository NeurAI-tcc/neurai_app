import 'package:flutter_test/flutter_test.dart';
import 'package:app_teste_tcc/models/alerta_model.dart';
import 'package:app_teste_tcc/models/camera_frame_model.dart';
import 'package:app_teste_tcc/models/usuario_model.dart';

void main() {
  group('modelos', () {
    test('converte o perfil da criança com subestruturas', () {
      final perfil = CriancaModel.fromJson({
        'id': 'child-1',
        'info_basica': {'nome_completo': 'Ana'},
        'diagnostico': {'principal': 'TEA'},
        'saude': {
          'medicamentos': ['vitamina'],
        },
        'preferencias': {
          'atividades_favoritas': ['desenho'],
        },
        'rotina': {'segunda': []},
        'reconhecimento_facial': {
          'fotos_urls': ['https://foto/1.jpg'],
        },
      });

      expect(perfil.id, 'child-1');
      expect(perfil.nomeCompleto, 'Ana');
      expect(perfil.diagnosticoPrincipal, 'TEA');
      expect(perfil.medicamentos, ['vitamina']);
      expect(perfil.reconhecimentoFacial.fotosUrls, ['https://foto/1.jpg']);
    });

    test('interpreta alerta e frame recebido da IA', () {
      final alerta = AlertaModel.fromJson({
        'id': 'alert-1',
        'timestamp': '2026-10-01T10:00:00Z',
        'tipo_crise': 'saude',
        'detalhes': 'Queda detectada',
        'falso_positivo': false,
        'confianca_ia': 0.94,
        'camera_id': 'cam-1',
      });
      final frame = CameraFrame.fromJson({
        'imagem_base64': 'ZmFrZQ==',
        'status_ia': 'alerta',
        'caixas': [
          {
            'x': 1,
            'y': 2,
            'width': 30,
            'height': 40,
            'label': 'crianca',
            'confidence': 0.9,
          },
        ],
      });

      expect(alerta.confiancaIa, 0.94);
      expect(frame.imagemBase64, 'ZmFrZQ==');
      expect(frame.caixas.single.label, 'crianca');
      expect(frame.caixas.single.left, 1);
    });
  });
}
