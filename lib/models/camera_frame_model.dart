class BoundingBox {
  final double left;
  final double top;
  final double width;
  final double height;
  final String label;
  final double confidence;

  const BoundingBox({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.label,
    required this.confidence,
  });

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
    left:
        (json['left'] as num?)?.toDouble() ??
        (json['x'] as num?)?.toDouble() ??
        0,
    top:
        (json['top'] as num?)?.toDouble() ??
        (json['y'] as num?)?.toDouble() ??
        0,
    width: (json['width'] as num?)?.toDouble() ?? 0,
    height: (json['height'] as num?)?.toDouble() ?? 0,
    label: json['label'] as String? ?? '',
    confidence: (json['confidence'] as num?)?.toDouble() ?? 0,
  );
}

class CameraFrame {
  final String imagemBase64;
  final String statusIa;
  final List<BoundingBox> caixas;
  final DateTime timestamp;

  const CameraFrame({
    required this.imagemBase64,
    required this.statusIa,
    required this.caixas,
    required this.timestamp,
  });

  factory CameraFrame.fromJson(Map<String, dynamic> json) => CameraFrame(
    imagemBase64:
        json['imagem_base64'] as String? ??
        json['image_base64'] as String? ??
        '',
    statusIa:
        json['status_ia'] as String? ?? json['status'] as String? ?? 'normal',
    caixas: json['caixas'] is List
        ? (json['caixas'] as List)
              .whereType<Map>()
              .map(
                (item) => BoundingBox.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList()
        : const [],
    timestamp:
        DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
  );
}
