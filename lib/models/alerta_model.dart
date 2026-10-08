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

  factory AlertaModel.fromJson(Map<String, dynamic> json) => AlertaModel(
    id: json['id'] as String? ?? '',
    timestamp:
        DateTime.tryParse(json['timestamp'] as String? ?? '') ??
        DateTime.fromMillisecondsSinceEpoch(0),
    tipoCrise: json['tipo_crise'] as String? ?? json['tipo'] as String? ?? '',
    detalhes: json['detalhes'] as String? ?? '',
    falsoPositivo: json['falso_positivo'] as bool? ?? false,
    confiancaIa: (json['confianca_ia'] as num?)?.toDouble() ?? 0,
    cameraId: json['camera_id'] as String? ?? '',
    videoUrl: json['video_url'] as String?,
  );
}
