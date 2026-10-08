import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoSelect extends StatefulWidget {
  const PhotoSelect({super.key});

  @override
  State<PhotoSelect> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoSelect> {
  final ImagePicker picker = ImagePicker();

  Uint8List? imagem;

  // =========================
  // SELECIONAR FOTO
  // =========================

  Future<void> selecionarFoto(ImageSource origem) async {
    try {
      final XFile? foto = await picker.pickImage(
        source: origem,
        imageQuality: 80,
      );

      if (foto == null) {
        return;
      }

      final Uint8List bytes = await foto.readAsBytes();

      setState(() {
        imagem = bytes;
      });
    } catch (e) {
      debugPrint('Erro ao selecionar imagem: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Não foi possível selecionar a imagem.',
          ),
        ),
      );
    }
  }

  // =========================
  // OPÇÕES
  // =========================

  void abrirOpcoes() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Adicionar foto',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.camera_alt_outlined,
                  color: Color(0xFF5796E8),
                ),
                title: const Text('Tirar foto'),
                onTap: () {
                  Navigator.pop(context);

                  selecionarFoto(
                    ImageSource.camera,
                  );
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.photo_library_outlined,
                  color: Color(0xFF5796E8),
                ),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.pop(context);

                  selecionarFoto(
                    ImageSource.gallery,
                  );
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: abrirOpcoes,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Color(0xFFD9F2FF),
                    shape: BoxShape.circle,
                  ),
                  child: imagem == null
                      ? const Icon(
                          Icons.person,
                          size: 45,
                          color: Color(0xFF5796E8),
                        )
                      : ClipOval(
                          child: Image.memory(
                            imagem!,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),

                Positioned(
                  right: -3,
                  bottom: -3,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Color(0xFF5796E8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 7),

          const Text(
            'Adicionar foto',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF438FD8),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}