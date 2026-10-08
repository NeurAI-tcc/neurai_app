class CameraModel {
  final String id;
  final String enderecoIp;
  final String nome;
  final String localizacao;
  final String modelo;

  const CameraModel({
    required this.id,
    required this.enderecoIp,
    required this.nome,
    required this.localizacao,
    required this.modelo,
  });

  factory CameraModel.fromJson(Map<String, dynamic> json) => CameraModel(
    id: json['id'] as String? ?? '',
    enderecoIp: json['endereco_ip'] as String? ?? json['ip'] as String? ?? '',
    nome: json['nome'] as String? ?? '',
    localizacao: json['localizacao'] as String? ?? '',
    modelo: json['modelo'] as String? ?? '',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'endereco_ip': enderecoIp,
    'nome': nome,
    'localizacao': localizacao,
    'modelo': modelo,
  };
}
