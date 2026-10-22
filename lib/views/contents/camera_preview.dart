
import 'package:flutter/material.dart';

class CameraPreview extends StatelessWidget {
  final String cameraId;
  final String token;

  const CameraPreview({
    super.key,
    required this.cameraId,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    // Placeholder visual.
    // A transmissão real deve ser conectada aqui.
    return Container(
      color: Colors.black12,
      child: const Center(
        child: Icon(
          Icons.videocam,
          size: 50,
          color: Colors.black38,
        ),
      ),
    );
  }
}
