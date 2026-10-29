import 'package:flutter/material.dart';
import 'package:neurai_app/services/auth_service.dart';
import 'package:neurai_app/views/agenda_page.dart';
import 'package:neurai_app/views/historico_page.dart';
import 'package:neurai_app/views/perfil_page.dart';
import 'package:neurai_app/views/relatorios_page.dart';

import 'contents/camera_monitoramento.dart';
import 'contents/home_bottom_nav.dart';
import 'contents/resumo_card.dart';
import 'contents/status_card.dart';

class HomePage extends StatefulWidget {
  final String cameraId;
  final String token;

  const HomePage({super.key, required this.cameraId, required this.token});

  static const String cameraNome = 'Câmera da sala';

  static const Color fundo = Color(0xFFE8F6FF);
  static const Color azul = Color(0xFF5298FF);
  static const Color roxo = Color(0xFF8054D9);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();

  String _nomeUsuario = 'usuário';
  List<dynamic> _alertas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final perfil = await _authService.getPerfil();
      final alertas = await _authService.getAlertas();

      if (!mounted) return;

      setState(() {
        _nomeUsuario = _buscarNome(perfil);
        _alertas = alertas;
        _carregando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível carregar os dados.';
        _carregando = false;
      });

      debugPrint('Erro ao carregar dados da Home: $e');
    }
  }

  String _buscarNome(Map<String, dynamic> dados) {
    dynamic usuario = dados['usuario'] ?? dados['perfil'] ?? dados;

    if (usuario is Map) {
      final nome =
          usuario['nome_completo'] ?? usuario['nome'] ?? usuario['first_name'];

      if (nome is String && nome.trim().isNotEmpty) {
        return nome.trim().split(' ').first;
      }
    }

    return 'usuário';
  }

  List<dynamic> get _alertasDeHoje {
    final agora = DateTime.now();

    return _alertas.where((alerta) {
      if (alerta is! Map) return false;

      final valorData = alerta['timestamp'];
      if (valorData == null) return false;

      final data = DateTime.tryParse(valorData.toString());
      if (data == null) return false;

      final dataLocal = data.toLocal();

      return dataLocal.year == agora.year &&
          dataLocal.month == agora.month &&
          dataLocal.day == agora.day;
    }).toList();
  }

  String _formatarData(dynamic valor) {
    if (valor == null) return 'Data não informada';

    final data = DateTime.tryParse(valor.toString());
    if (data == null) return 'Data não informada';

    final local = data.toLocal();
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    if (local.year == DateTime.now().year &&
        local.month == DateTime.now().month &&
        local.day == DateTime.now().day) {
      return 'Hoje, $hora:$minuto';
    }

    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');

    return '$dia/$mes, $hora:$minuto';
  }

  String _descricaoUltimoAlerta(Map alerta) {
    final detalhes = alerta['detalhes'];
    final tipo = alerta['tipo_crise'];

    if (detalhes is String && detalhes.trim().isNotEmpty) {
      return detalhes;
    }

    if (tipo is String && tipo.trim().isNotEmpty) {
      return tipo.replaceAll('_', ' ');
    }

    return 'Alerta registrado';
  }

  @override
  Widget build(BuildContext context) {
    final ultimoAlerta = _alertas.isNotEmpty && _alertas.first is Map
        ? _alertas.first as Map
        : null;

    return Scaffold(
      backgroundColor: HomePage.fundo,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _carregarDados,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
            children: [
              // CABEÇALHO
              Row(
                children: [
                  Image.asset(
                    'assets/group_neurai.png',
                    width: 135,
                    height: 50,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: HomePage.azul, width: 0.8),
                    ),
                    child: const CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xFFD5EFFF),
                      child: Icon(Icons.person, size: 25, color: HomePage.azul),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Olá, $_nomeUsuario!',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 3),

              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'Vamos cuidar juntos hoje.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ),

              const SizedBox(height: 11),

              // CÂMERA
              CameraMonitoramentoCard(
                cameraId: widget.cameraId,
                token: widget.token,
                nomeCamera: HomePage.cameraNome,
              ),

              const SizedBox(height: 9),

              // STATUS
              StatusCard(
                icone: Icons.verified_user_outlined,
                titulo: _carregando ? 'Carregando status' : 'Monitoramento',
                descricao: _carregando
                    ? 'Consultando os dados...'
                    : _erro != null
                    ? 'Não foi possível consultar os dados da API.'
                    : 'Dados atualizados pela plataforma NeurAi.',
                cor: const Color(0xFF078653),
                fundoIcone: const Color(0xFFC8F5D9),
              ),

              const SizedBox(height: 15),

              // ÚLTIMO ALERTA
              StatusCard(
                icone: Icons.gpp_maybe_outlined,
                titulo: 'Último alerta',
                descricao: _carregando
                    ? 'Carregando alertas...'
                    : _erro != null
                    ? 'Não foi possível carregar os alertas.'
                    : ultimoAlerta == null
                    ? 'Nenhum alerta registrado.'
                    : '${_formatarData(ultimoAlerta['timestamp'])}\n'
                          '${_descricaoUltimoAlerta(ultimoAlerta)}',
                cor: const Color(0xFFB60000),
                fundoIcone: const Color(0xFFFFD6D6),
              ),

              const SizedBox(height: 15),

              // RESUMOS
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ResumoCard(
                      icone: Icons.calendar_month_outlined,
                      titulo: 'Eventos hoje',
                      valor: _carregando
                          ? '...'
                          : '${_alertasDeHoje.length} eventos',
                      acao: 'Ver histórico →',
                      cor: HomePage.roxo,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: ResumoCard(
                      icone: Icons.access_time,
                      titulo: 'Tempo\nacompanhado',
                      valor: 'Em breve',
                      acao: 'Ver relatório →',
                      cor: HomePage.azul,
                    ),
                  ),
                ],
              ),

              if (_erro != null) ...[
                const SizedBox(height: 12),
                Text(
                  _erro!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: _carregarDados,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                  ),
                ),
              ],

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      // MENU INFERIOR
      bottomNavigationBar: HomeBottomNav(
        paginaSelecionada: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoricoPage()),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AgendaPage(),
                ),
              );
              break;
            case 3:
              Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RelatoriosScreen(),
              ),
            );
              break;
            case 4:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PerfilPage(
                    cameraId: widget.cameraId,
                    token: widget.token,
                  ),
                ),
              );
              break;
          }
        },
      ),
    );
  }
}
