class InfoBasica {
  final String nomeCompleto;
  final DateTime? dataNascimento;
  final String? sexo;

  const InfoBasica({
    required this.nomeCompleto,
    this.dataNascimento,
    this.sexo,
  });

  factory InfoBasica.fromJson(Map<String, dynamic> json) => InfoBasica(
    nomeCompleto: json['nome_completo'] as String? ?? '',
    dataNascimento: _dateFromJson(json['data_nascimento']),
    sexo: json['sexo'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'nome_completo': nomeCompleto,
    'data_nascimento': dataNascimento?.toIso8601String(),
    'sexo': sexo,
  };
}

class Diagnostico {
  final String principal;
  final List<String> comorbidades;
  final String? observacoes;

  const Diagnostico({
    required this.principal,
    this.comorbidades = const [],
    this.observacoes,
  });

  factory Diagnostico.fromJson(Map<String, dynamic> json) => Diagnostico(
    principal:
        json['principal'] as String? ??
        json['diagnostico_principal'] as String? ??
        '',
    comorbidades: _stringList(json['comorbidades']),
    observacoes: json['observacoes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'principal': principal,
    'comorbidades': comorbidades,
    'observacoes': observacoes,
  };
}

class Saude {
  final List<String> medicamentos;
  final List<String> alergias;
  final String? observacoes;

  const Saude({
    this.medicamentos = const [],
    this.alergias = const [],
    this.observacoes,
  });

  factory Saude.fromJson(Map<String, dynamic> json) => Saude(
    medicamentos: _stringList(json['medicamentos']),
    alergias: _stringList(json['alergias']),
    observacoes: json['observacoes'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'medicamentos': medicamentos,
    'alergias': alergias,
    'observacoes': observacoes,
  };
}

class Preferencias {
  final List<String> atividadesFavoritas;
  final List<String> sensibilidades;

  const Preferencias({
    this.atividadesFavoritas = const [],
    this.sensibilidades = const [],
  });

  factory Preferencias.fromJson(Map<String, dynamic> json) => Preferencias(
    atividadesFavoritas: _stringList(json['atividades_favoritas']),
    sensibilidades: _stringList(json['sensibilidades']),
  );

  Map<String, dynamic> toJson() => {
    'atividades_favoritas': atividadesFavoritas,
    'sensibilidades': sensibilidades,
  };
}

class Rotina {
  final Map<String, dynamic> dias;

  const Rotina({this.dias = const {}});

  factory Rotina.fromJson(Map<String, dynamic> json) =>
      Rotina(dias: Map<String, dynamic>.from(json));
  Map<String, dynamic> toJson() => dias;
}

class ReconhecimentoFacial {
  final List<String> fotosUrls;

  const ReconhecimentoFacial({this.fotosUrls = const []});

  factory ReconhecimentoFacial.fromJson(Map<String, dynamic> json) =>
      ReconhecimentoFacial(
        fotosUrls: _stringList(json['fotos_urls'] ?? json['fotos']),
      );

  Map<String, dynamic> toJson() => {'fotos_urls': fotosUrls};
}

class CriancaModel {
  final String id;
  final InfoBasica infoBasica;
  final Diagnostico diagnostico;
  final Saude saude;
  final Preferencias preferencias;
  final Rotina rotina;
  final ReconhecimentoFacial reconhecimentoFacial;

  const CriancaModel({
    this.id = '',
    required this.infoBasica,
    required this.diagnostico,
    required this.saude,
    required this.preferencias,
    required this.rotina,
    required this.reconhecimentoFacial,
  });

  String get nomeCompleto => infoBasica.nomeCompleto;
  String get diagnosticoPrincipal => diagnostico.principal;
  List<String> get medicamentos => saude.medicamentos;

  factory CriancaModel.fromJson(Map<String, dynamic> json) => CriancaModel(
    id: json['id'] as String? ?? '',
    infoBasica: InfoBasica.fromJson(_map(json['info_basica']) ?? json),
    diagnostico: Diagnostico.fromJson(_map(json['diagnostico']) ?? json),
    saude: Saude.fromJson(_map(json['saude']) ?? json),
    preferencias: Preferencias.fromJson(_map(json['preferencias']) ?? {}),
    rotina: Rotina.fromJson(_map(json['rotina']) ?? {}),
    reconhecimentoFacial: ReconhecimentoFacial.fromJson(
      _map(json['reconhecimento_facial']) ?? {},
    ),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'info_basica': infoBasica.toJson(),
    'diagnostico': diagnostico.toJson(),
    'saude': saude.toJson(),
    'preferencias': preferencias.toJson(),
    'rotina': rotina.toJson(),
    'reconhecimento_facial': reconhecimentoFacial.toJson(),
  };
}

class UsuarioModel {
  final String id;
  final String nomeCompleto;
  final String email;
  final CriancaModel?
  perfilCrianca; // Nulo se for Admin ou se o cadastro estiver incompleto

  const UsuarioModel({
    required this.id,
    required this.nomeCompleto,
    required this.email,
    this.perfilCrianca,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as String? ?? '',
      nomeCompleto: json['nome_completo'] as String? ?? '',
      email: json['email'] as String? ?? '',
      perfilCrianca: json['perfil_crianca'] is Map
          ? CriancaModel.fromJson(
              Map<String, dynamic>.from(json['perfil_crianca'] as Map),
            )
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nome_completo': nomeCompleto,
    'email': email,
    'perfil_crianca': perfilCrianca?.toJson(),
  };
}

DateTime? _dateFromJson(Object? value) =>
    value is String ? DateTime.tryParse(value) : null;
Map<String, dynamic>? _map(Object? value) =>
    value is Map ? Map<String, dynamic>.from(value) : null;
List<String> _stringList(Object? value) =>
    value is List ? value.whereType<String>().toList() : const [];
