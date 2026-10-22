
import 'package:flutter/material.dart';

import 'camera_ao_vivo.dart';
import 'camera_preview.dart';

class CameraMonitoramentoCard extends StatelessWidget {
  final String cameraId;
  final String token;
  final String nomeCamera;

  const CameraMonitoramentoCard({
    super.key,
    required this.cameraId,
    required this.token,
    required this.nomeCamera,
  });

  static const Color azul = Color(0xFF5298FF);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(
          color: azul,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: azul.withValues(alpha: 0.18),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Monitoramento ao vivo',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF555555),
            ),
          ),

          const SizedBox(height: 6),

          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CameraAoVivoCard(
                    cameraId: cameraId,
                    token: token,
                    nomeCamera: nomeCamera,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: double.infinity,
                height: 170,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CameraPreview(
                      cameraId: cameraId,
                      token: token,
                    ),

                    Positioned(
                      left: 7,
                      bottom: 7,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '🔴 AO VIVO',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const Positioned(
                      right: 6,
                      top: 6,
                      child: Icon(
                        Icons.fullscreen,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
