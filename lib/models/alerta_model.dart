import 'dart:convert';

class AlertaModel {
  final String id;
  final DateTime timestamp;
  final String tipoCrise;
  final String detalhes;
  final bool falsoPositivo;
  final double confiancaIa;
  final String cameraId;
  final String? videoUrl;

  const AlertaModel({
    required this.id,
    required this.timestamp,
    required this.tipoCrise,
    required this.detalhes,
    required this.falsoPositivo,
    required this.confiancaIa,
    required this.cameraId,
    this.videoUrl,
  });

  static String texto(dynamic valor) {
    if (valor == null) return '';
    if (valor is String) return valor;
    if (valor is Map || valor is List) {
      return jsonEncode(valor);
    }
    return valor.toString();
  }

  factory AlertaModel.fromJson(Map<String, dynamic> json) {
    return AlertaModel(
      id: texto(json['id']),
      timestamp:
          DateTime.tryParse(texto(json['timestamp'])) ??
          DateTime.fromMillisecondsSinceEpoch(0),
      tipoCrise: texto(json['tipo_crise'] ?? json['tipo']),
      detalhes: texto(json['detalhes']),
      falsoPositivo: json['falso_positivo'] == true,
      confiancaIa: (json['confianca_ia'] as num?)?.toDouble() ?? 0,
      cameraId: texto(json['camera_id']),
      videoUrl: json['video_url'] == null ? null : texto(json['video_url']),
    );
  }
}
