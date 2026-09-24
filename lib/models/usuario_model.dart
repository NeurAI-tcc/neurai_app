class CriancaModel {
  final String nomeCompleto;
  final String diagnosticoPrincipal;
  final List<String> medicamentos;
  final Map<String, dynamic> rotina;

  CriancaModel({
    required this.nomeCompleto,
    required this.diagnosticoPrincipal,
    required this.medicamentos,
    required this.rotina,
  });

  factory CriancaModel.fromJson(Map<String, dynamic> json) {
    return CriancaModel(
      nomeCompleto: json['nome_completo'] ?? '',
      diagnosticoPrincipal: json['diagnostico_principal'] ?? '',
      medicamentos: List<String>.from(json['medicamentos'] ?? []),
      rotina: json['rotina'] ?? {},
    );
  }
}

class UsuarioModel {
  final String id;
  final String nomeCompleto;
  final String email;
  final CriancaModel? perfilCrianca; // Nulo se for Admin ou se o cadastro estiver incompleto

  UsuarioModel({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    this.perfilCrianca,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      nomeCompleto: json['nome_completo'],
      email: json['email'],
      perfilCrianca: json['perfil_crianca'] != null 
          ? CriancaModel.fromJson(json['perfil_crianca']) 
          : null,
    );
  }
}