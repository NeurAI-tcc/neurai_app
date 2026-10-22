import 'package:flutter/material.dart';

const Color azul = Color(0xFF4595FF);
const Color fundo = Color(0xFFEAF7FF);
const Color texto = Color(0xFF30343B);
const Color cinza = Color(0xFF858B94);
const Color verde = Color(0xFF36B96B);

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  int paginaSelecionada = 4;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      backgroundColor: fundo,
      body: SafeArea(
        bottom: false,
        child: Column( 
          children: [
            Expanded( 
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  children: [
                    _cabecalho(),
                    const SizedBox(height: 12),
                    _cartaoSobre(),
                    const SizedBox(height: 12),
                    _cartaoClinico(),
                    const SizedBox(height: 22),
                    _cartaoSeguranca(),
                    const SizedBox(height: 20),
                    _botaoSair(),
                  ],
                ),
              ),
            ),
            _navegacaoInferior(),
          ],
        ),
      ),
    );
  }

    Widget _cabecalho() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                _mensagem('edição do perfil');
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 20,
                color: texto,
              ),
            ),
          ),
          Transform.translate(
            offset: const Offset(0, -8),
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: azul, width: 1.5),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFD5E9F8),
                        child: Icon(
                          Icons.person,
                          size: 43,
                          color: Color(0xFF83A9CA),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -3,
                      bottom: 0,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: azul,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'Luiza Sonza',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF30343B),
                  ),
                ),

                const SizedBox(height: 1),

                const Text(
                  '6 anos - TEA - Nível 1',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF30343B),
                  ),
                ),
                const SizedBox(height: 2),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.circle, size: 7, color: verde),
                    SizedBox(width: 4),
                    Text(
                      'Monitoramento ativo',
                      style: TextStyle(
                        fontSize: 10,
                        color: texto,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartao({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(10),
  }) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: azul, width: 0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.09),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _tituloCartao(IconData icone, String titulo) {
    return Row(
      children: [
        Container(
          width: 31,
          height: 31,
          decoration: const BoxDecoration(
            color: Color(0xFFE3F2FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icone,
            color: azul,
            size: 20,
          ),
        ),
        const SizedBox(width: 7),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: texto,
          ),
        ),
      ],
    );
  }

  Widget _campo({
    required String titulo,
    required String valor,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 1, right: 1, top: 7, bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 8,
                    color: cinza,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 9,
                    color: texto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _cartaoSobre() {
    return _cartao(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      child: Column(
        children: [
          _tituloCartao(Icons.person, 'Sobre'),
          const SizedBox(height: 3),
          _campo(
            titulo: 'Data de nascimento',
            valor: '12/04/2017',
          ),
          const Divider(height: 1, thickness: 0.7),
          _campo(
            titulo: 'Responsável principal',
            valor: 'Ariana (Mãe)',
            trailing: Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: Color(0xFFE3F2FF),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  _mensagem('contato do responsável');
                },
                icon: const Icon(
                  Icons.phone_in_talk_outlined,
                  color: azul,
                  size: 18,
                ),
              ),
            ),
          ),
          const Divider(height: 1, thickness: 0.7),
          _campo(
            titulo: 'E-mail',
            valor: 'ariana@gmail.com',
          ),
        ],
      ),
    );
  }

  Widget _linhaClinica({
    required IconData icone,
    required String titulo,
    required String valor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FF),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icone,
              size: 19,
              color: azul,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontSize: 8,
                    color: cinza,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 9,
                    color: texto,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cartaoClinico() {
    return _cartao(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
      child: Column(
        children: [
          _tituloCartao(
            Icons.favorite,
            'Informações clínicas',
          ),
          const SizedBox(height: 4),
          _linhaClinica(
            icone: Icons.monitor_heart,
            titulo: 'Diagnóstico',
            valor: 'TEA - Nível 1',
          ),
          const Divider(height: 1, thickness: 0.7),
          _linhaClinica(
            icone: Icons.hearing,
            titulo: 'Sensibilidades',
            valor: 'Luz, barulho alto, texturas',
          ),
          const Divider(height: 1, thickness: 0.7),
          _linhaClinica(
            icone: Icons.star,
            titulo: 'Preferências',
            valor: 'Músicas, brinquedos, rotina fixa',
          ),
        ],
      ),
    );
  }

  Widget _opcaoSeguranca({
    required String titulo,
    required String valor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 1,
          vertical: 9,
        ),
        child: Row(
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 8,
                color: cinza,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                valor,
                style: const TextStyle(
                  fontSize: 8,
                  color: texto,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right,
              size: 16,
              color: azul,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cartaoSeguranca() {
    return _cartao(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 6),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 31,
                height: 31,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shield,
                  color: azul,
                  size: 18,
                ),
              ),
              const SizedBox(width: 7),
              const Expanded(
                child: Text(
                  'Conta e segurança',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: texto,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                size: 17,
                color: Color(0xFF8D72FF),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _opcaoSeguranca(
            titulo: 'E-mail',
            valor: 'anapaula@gmail.com',
            onTap: () => _mensagem('alteração de e-mail'),
          ),
          const Divider(height: 1, thickness: 0.7),
          _opcaoSeguranca(
            titulo: 'Senha',
            valor: '',
            onTap: () => _mensagem('alteração de senha'),
          ),
          const Divider(height: 1, thickness: 0.7),
          _opcaoSeguranca(
            titulo: 'Privacidade',
            valor: 'Gerenciar compartilhamentos',
            onTap: () => _mensagem('configurações de privacidade'),
          ),
        ],
      ),
    );
  }

  Widget _botaoSair() {
    return SizedBox(
      width: double.infinity,
      height: 28,
      child: OutlinedButton.icon(
        onPressed: () {
          _confirmarSaida();
        },
        icon: const Icon(
          Icons.logout,
          size: 17,
          color: azul,
        ),
        label: const Text(
          'Sair da Conta',
          style: TextStyle(
            fontSize: 9,
            color: texto,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: azul, width: 0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _navegacaoInferior() {
    const itens = [
      _ItemNav(Icons.home_outlined, 'Início'),
      _ItemNav(Icons.history, 'Histórico'),
      _ItemNav(Icons.calendar_month_outlined, 'Agenda'),
      _ItemNav(Icons.edit_note, 'Relatórios'),
      _ItemNav(Icons.person_outline, 'Perfil'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: azul, width: 0.8),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(12),
        ),
      ),
      padding: EdgeInsets.only(
        top: 6,
        bottom: MediaQuery.of(context).padding.bottom > 0 ? 5 : 8,
      ),
      child: Row(
        children: List.generate(itens.length, (index) {
          final item = itens[index];
          final selecionado = index == paginaSelecionada;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  paginaSelecionada = index;
                });

                if (index != 4) {
                  _mensagem('navegação para ${item.titulo}');
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icone,
                    size: 21,
                    color: selecionado ? const Color(0xFF31B8C3) : cinza,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.titulo,
                    style: TextStyle(
                      fontSize: 8,
                      color: selecionado
                          ? const Color(0xFF31B8C3)
                          : cinza,
                      fontWeight: selecionado
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  void _mensagem(String funcionalidade) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$funcionalidade ainda precisa ser conectada.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _confirmarSaida() async {
    final sair = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('sair da conta?'),
        content: const Text(
          'tem certeza de que deseja sair da sua conta?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('sair'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (sair == true) {
      _mensagem('encerramento de sessão');
    }
  }
}

class _ItemNav {
  final IconData icone;
  final String titulo;

  const _ItemNav(this.icone, this.titulo);
}
