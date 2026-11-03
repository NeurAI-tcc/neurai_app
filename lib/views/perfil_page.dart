import 'package:flutter/material.dart';
import 'package:neurai_app/views/agenda_page.dart';
import 'package:neurai_app/views/historico_page.dart';

import 'package:neurai_app/views/home.dart';
import 'package:neurai_app/views/configuracoes_page.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/home_bottom_nav.dart';
import 'contents/perfil_header.dart';
import 'contents/perfil_sobre.dart';
import 'contents/perfil_clinico.dart';
import 'contents/perfil_seguranca.dart';
import 'contents/perfil_botao_sair.dart';
import 'login_page.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../models/usuario_model.dart';

class PerfilPage extends StatefulWidget {
  final String cameraId;
  final String token;

  const PerfilPage({super.key, required this.cameraId, required this.token});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final ApiService _api = ApiService();
  UsuarioModel? _usuario;
  String? _erro;
  bool _carregando = true;

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    try {
      final token = widget.token.isNotEmpty
          ? widget.token
          : await AuthService().token ?? '';
      if (token.isEmpty) {
        throw Exception('Token não encontrado. Faça login novamente.');
      }
      final usuario = await _api.buscarPerfil(token: token);
      if (mounted) setState(() => _usuario = usuario);
    } catch (error) {
      if (mounted) setState(() => _erro = error.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _abrirConfiguracoes(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const ConfiguracoesPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fundo,

      body: SafeArea(
        bottom: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // CABEÇALHO DO PERFIL
                    _carregando
                        ? const SizedBox(
                            height: 170,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : PerfilHeader(
                            nome: _nomeCrianca,
                            resumo: _resumoCrianca,
                            monitoramentoAtivo: widget.cameraId.isNotEmpty,
                          ),

                    const SizedBox(height: 16),

                    // BOTÃO DE CONFIGURAÇÕES
                    _botaoConfiguracoes(context),

                    const SizedBox(height: 16),

                    // INFORMAÇÕES SOBRE O USUÁRIO
                    PerfilSobre(
                      dataNascimento: _dataNascimento,
                      responsavel: _nomeResponsavel,
                      email: _usuario?.email ?? 'Não informado',
                    ),

                    const SizedBox(height: 12),

                    // INFORMAÇÕES CLÍNICAS
                    PerfilClinico(
                      diagnostico: _diagnostico,
                      sensibilidades: _sensibilidades,
                      preferencias: _preferencias,
                    ),

                    if (_erro != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Column(
                          children: [
                            Text(
                              _erro!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            TextButton.icon(
                              onPressed: _carregarPerfil,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Tentar novamente'),
                            ),
                          ],
                        ),
                      ),

                    const SizedBox(height: 20),

                    // SEGURANÇA DA CONTA
                    const PerfilSeguranca(),

                    const SizedBox(height: 20),

                    // SAIR DA CONTA
                    PerfilBotaoSair(
                      onConfirmarSaida: () async {
                        try {
                          await AuthService().logout();

                          if (!context.mounted) return;

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        } catch (e) {
                          if (!context.mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Não foi possível sair da conta.'),
                            ),
                          );
                        }
                      },
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      HomePage(cameraId: widget.cameraId, token: widget.token),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoricoPage(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AgendaPage(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RelatoriosScreen(
                    token: widget.token,
                    cameraId: widget.cameraId,
                  ),
                ),
              );
              break;
            case 4:
              // Já está na página de perfil
              break;
          }
        },
      ),
    );
  }

  // BOTÃO DE CONFIGURAÇÕES
  Widget _botaoConfiguracoes(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: () => _abrirConfiguracoes(context),
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: azul.withValues(alpha: 0.3), width: 1),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: fundo,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.settings_outlined,
                  color: azul,
                  size: 27,
                ),
              ),

              const SizedBox(width: 14),

              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configurações',
                      style: TextStyle(
                        color: Color(0xFF263746),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Personalize sua experiência no NeurAI',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right_rounded, color: azul, size: 28),
            ],
          ),
        ),
      ),
    );
  }

  CriancaModel? get _crianca => _usuario?.perfilCrianca;

  String get _nomeCrianca => _crianca?.nomeCompleto.isNotEmpty == true
      ? _crianca!.nomeCompleto
      : 'Perfil da criança';

  String get _nomeResponsavel => _usuario?.nomeCompleto.isNotEmpty == true
      ? _usuario!.nomeCompleto
      : 'Não informado';

  String get _resumoCrianca {
    final diagnostico = _crianca?.diagnosticoPrincipal;
    final idade = _crianca?.infoBasica.dataNascimento;
    final idadeTexto = idade == null ? '' : '${_calcularIdade(idade)} anos';
    return [
      idadeTexto,
      diagnostico ?? '',
    ].where((item) => item.isNotEmpty).join(' - ');
  }

  String get _dataNascimento {
    final data = _crianca?.infoBasica.dataNascimento;
    if (data == null) return 'Não informado';
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  String get _diagnostico => _crianca?.diagnosticoPrincipal.isNotEmpty == true
      ? _crianca!.diagnosticoPrincipal
      : 'Não informado';

  String get _sensibilidades {
    final valores = _crianca?.preferencias.sensibilidades ?? const [];
    return valores.isEmpty ? 'Não informado' : valores.join(', ');
  }

  String get _preferencias {
    final valores = _crianca?.preferencias.atividadesFavoritas ?? const [];
    return valores.isEmpty ? 'Não informado' : valores.join(', ');
  }

  int _calcularIdade(DateTime nascimento) {
    final hoje = DateTime.now();
    var idade = hoje.year - nascimento.year;
    if (hoje.month < nascimento.month ||
        (hoje.month == nascimento.month && hoje.day < nascimento.day)) {
      idade--;
    }
    return idade;
  }
}
