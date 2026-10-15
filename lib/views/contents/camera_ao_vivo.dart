
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:neurai_app/models/camera_frame_model.dart';
import 'package:neurai_app/services/camera_stream_service.dart';


class CameraAoVivoCard extends StatefulWidget {
  final String cameraId;
  final String token;
  final String nomeCamera;

  const CameraAoVivoCard({
    super.key,
    required this.cameraId,
    required this.token,
    this.nomeCamera = 'Câmera cadastrada',
  });

  @override
  State<CameraAoVivoCard> createState() =>
      _CameraAoVivoCardState();
}

class _CameraAoVivoCardState extends State<CameraAoVivoCard> {
  late final CameraStreamService _service;
  StreamSubscription<CameraFrame>? _subscription;

  CameraFrame? _frame;
  String? _erro;
  bool _conectando = true;

  @override
  void initState() {
    super.initState();

    _service = CameraStreamService();

    _subscription = _service.frames.listen(
      (frame) {
        if (!mounted) return;

        setState(() {
          _frame = frame;
          _erro = null;
          _conectando = false;
        });
      },
      onError: (Object error) {
        if (!mounted) return;

        setState(() {
          _erro = 'Erro ao receber imagens da câmera.';
          _conectando = false;
        });
      },
    );

    _conectar();
  }

  Future<void> _conectar() async {
    try {
      await _service.connect(
        cameraId: widget.cameraId,
        token: widget.token,
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _erro = 'Não foi possível conectar à câmera.';
        _conectando = false;
      });
    }
  }

  Uint8List? _decodificarImagem(String base64Imagem) {
    if (base64Imagem.isEmpty) return null;

    try {
      // Aceita tanto Base64 puro quanto data:image/jpeg;base64,...
      final conteudo = base64Imagem.contains(',')
          ? base64Imagem.substring(base64Imagem.indexOf(',') + 1)
          : base64Imagem;

      return base64Decode(
        base64.normalize(conteudo.trim()),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _service.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagem = _frame == null
        ? null
        : _decodificarImagem(_frame!.imagemBase64);

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF5298FF),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Monitoramento ao vivo',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                widget.nomeCamera,
                style: const TextStyle(
                  fontSize: 9,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          const SizedBox(height: 7),

          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    color: const Color(0xFFDDF2FF),
                    child: imagem != null
                        ? Image.memory(
                            imagem,
                            fit: BoxFit.cover,
                            gaplessPlayback: true,
                            errorBuilder: (_, __, ___) =>
                                const Center(
                              child: Icon(
                                Icons.broken_image_outlined,
                                size: 40,
                              ),
                            ),
                          )
                        : Center(
                            child: _conectando
                                ? const CircularProgressIndicator()
                                : Icon(
                                    _erro != null
                                        ? Icons.wifi_off
                                        : Icons.videocam_outlined,
                                    size: 42,
                                    color: Colors.blueGrey,
                                  ),
                          ),
                  ),

                  // Indicador da transmissão
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 7,
                            color: imagem != null
                                ? Colors.red
                                : Colors.orange,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            imagem != null
                                ? 'AO VIVO'
                                : _erro ?? 'CONECTANDO',
                            style: const TextStyle(
                              fontSize: 9,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Estado da IA
                  if (_frame != null)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'IA: ${_frame!.statusIa}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                          ),
                        ),
                      ),
                    ),

                  // Abrir a câmera em tela cheia
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CameraAoVivoPage(
                                cameraId: widget.cameraId,
                                token: widget.token,
                                nomeCamera: widget.nomeCamera,
                              ),
                            ),
                          );
                        },
                        child: const Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(7),
                            child: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 21,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          if (_frame != null) ...[
            const SizedBox(height: 6),
            Text(
              'Detecções: ${_frame!.caixas.length}',
              style: const TextStyle(
                fontSize: 10,
                color: Colors.black54,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Página ampliada reutilizando o mesmo cartão.
class CameraAoVivoPage extends StatelessWidget {
  final String cameraId;
  final String token;
  final String nomeCamera;

  const CameraAoVivoPage({
    super.key,
    required this.cameraId,
    required this.token,
    required this.nomeCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F6FF),
      appBar: AppBar(
        title: Text(nomeCamera),
        backgroundColor: const Color(0xFFE8F6FF),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: CameraAoVivoCard(
            cameraId: cameraId,
            token: token,
            nomeCamera: nomeCamera,
          ),
        ),
      ),
    );
  }
}
