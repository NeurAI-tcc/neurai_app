import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoCapture extends StatefulWidget {
  final ValueChanged<XFile> onFotoSelecionada;

  const PhotoCapture({
    super.key,
    required this.onFotoSelecionada,
  });

  @override
  State<PhotoCapture> createState() => _PhotoCaptureState();
}

class _PhotoCaptureState extends State<PhotoCapture> {
  final ImagePicker _picker = ImagePicker();

  Future<void> tirarFoto() async {
    final XFile? imagem = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (imagem == null) {
      return;
    }

    widget.onFotoSelecionada(imagem);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 45,
      child: ElevatedButton.icon(
        onPressed: tirarFoto,
        icon: const Icon(
          Icons.camera_alt_outlined,
          size: 18,
        ),
        label: const Text(
          'Tirar foto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4B91ED),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}