
import 'package:flutter/material.dart';

class PerfilHeader extends StatelessWidget {
  const PerfilHeader({super.key});

  static const Color azul = Color(0xFF5298FF);
  static const Color texto = Color(0xFF30343B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'conecte aqui a edição do perfil.',
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: 22,
                color: texto,
              ),
            ),
          ),
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: azul,
                          width: 1.5,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFD5E9F8),
                        child: Icon(
                          Icons.person,
                          size: 56,
                          color: Color(0xFF83A9CA),
                        ),
                      ),
                    ),
                    Positioned(
                      right: -2,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: azul,
                          borderRadius: BorderRadius.circular(9),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 17,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Luiza Sonza',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  '6 anos - TEA - Nível 1',
                  style: TextStyle(
                    fontSize: 12,
                    color: texto,
                  ),
                ),
                const SizedBox(height: 3),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 8,
                      color: Color(0xFF36B96B),
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Monitoramento ativo',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF4F5965),
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
}
