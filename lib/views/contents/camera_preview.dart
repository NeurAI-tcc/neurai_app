
import 'package:flutter/material.dart';
import 'camera_ao_vivo.dart';

class CameraPreview extends StatelessWidget {
  final String cameraId;
  final String cameraIp;
  final String token;
  final bool compacto;

  const CameraPreview({
    super.key,
    required this.cameraId,
    required this.cameraIp,
    required this.token,
    this.compacto = false,
  });

  @override
  Widget build(BuildContext context) {
    return CameraAoVivoCard(
      cameraId: cameraId,
      cameraIp: cameraIp,
      token: token,
      compacto: compacto,
    );
  }
}
