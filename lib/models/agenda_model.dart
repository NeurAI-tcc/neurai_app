class EventoModel {
  final String id;
  final String titulo;
  final DateTime inicio;
  final DateTime fim;
  final String localizacao;

  const EventoModel({
    required this.id,
    required this.titulo,
    required this.inicio,
    required this.fim,
    required this.localizacao,
  });

  Map<String, dynamic> toJson() => {
    'nome': titulo,
    'localizacao': localizacao,
    'horario_inicio': inicio.toIso8601String(),
    'horario_fim': fim.toIso8601String(),
  };

  factory EventoModel.fromJson(Map<String, dynamic> json) => EventoModel(
    id: json['id']?.toString() ?? '',
    titulo: json['titulo'] as String? ?? json['nome'] as String? ?? '',
    inicio:
        DateTime.tryParse(
          json['inicio'] as String? ?? json['horario_inicio'] as String? ?? '',
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    fim:
        DateTime.tryParse(
          json['fim'] as String? ?? json['horario_fim'] as String? ?? '',
        ) ??
        DateTime.fromMillisecondsSinceEpoch(0),
    localizacao: json['localizacao'] as String? ?? '',
  );
}
