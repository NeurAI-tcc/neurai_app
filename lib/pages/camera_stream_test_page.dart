import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../models/camera_frame_model.dart';
import '../services/camera_stream_service.dart';

class CameraStreamTestPage extends StatefulWidget {
  const CameraStreamTestPage({
    super.key,
    this.webSocketUri = 'ws://127.0.0.1:8000/ws/camera/',
    this.token = 'token-de-teste',
    this.streamService,
  });

  final String webSocketUri;
  final String token;
  final CameraStreamService? streamService;

  @override
  State<CameraStreamTestPage> createState() => _CameraStreamTestPageState();
}

class _CameraStreamTestPageState extends State<CameraStreamTestPage> {
  late final TextEditingController _nomeController;
  late final TextEditingController _ipController;
  late final CameraStreamService _streamService;

  final _formKey = GlobalKey<FormState>();
  String? _cameraId;
  String? _erro;
  bool _salvando = false;
  bool _conectando = false;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController();
    _ipController = TextEditingController();
    _streamService =
        widget.streamService ??
        CameraStreamService(baseUri: Uri.parse(widget.webSocketUri));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _ipController.dispose();
    _streamService.dispose();
    super.dispose();
  }

  Future<void> _ligarEGuardar() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _salvando = true;
      _conectando = false;
      _erro = null;
    });

    try {
      final cameraId = await _guardarCameraNoBackend(
        nome: _nomeController.text.trim(),
        enderecoIp: _ipController.text.trim(),
      );

      if (!mounted) return;
      setState(() {
        _cameraId = cameraId;
        _salvando = false;
        _conectando = true;
      });

      await _streamService.connect(cameraId: cameraId, token: widget.token);

      if (!mounted) return;
      setState(() => _conectando = false);
    } on Object catch (error) {
      if (!mounted) return;
      setState(() {
        _salvando = false;
        _conectando = false;
        _erro = error.toString();
      });
    }
  }

  Future<String> _guardarCameraNoBackend({
    required String nome,
    required String enderecoIp,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return enderecoIp;
  }

  Future<void> _desligar() async {
    await _streamService.disconnect();
    if (!mounted) return;
    setState(() {
      _cameraId = null;
      _conectando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Teste da câmara IP')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _nomeController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Câmara',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o nome da câmara'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ipController,
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Endereço IP',
                    hintText: '192.168.0.10',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'Informe o endereço IP'
                      : null,
                  onFieldSubmitted: (_) => _ligarEGuardar(),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _salvando || _conectando
                            ? null
                            : _ligarEGuardar,
                        icon: const Icon(Icons.link),
                        label: Text(
                          _salvando
                              ? 'A guardar...'
                              : _conectando
                              ? 'A ligar...'
                              : 'Ligar e Guardar',
                        ),
                      ),
                    ),
                    if (_cameraId != null) ...[
                      const SizedBox(width: 8),
                      IconButton(
                        tooltip: 'Desligar',
                        onPressed: _desligar,
                        icon: const Icon(Icons.link_off),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                _StatusCard(
                  cameraId: _cameraId,
                  connecting: _conectando,
                  stream: _streamService.frames,
                  error: _erro,
                ),
                const SizedBox(height: 12),
                _VideoPanel(stream: _streamService.frames),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.cameraId,
    required this.connecting,
    required this.stream,
    required this.error,
  });

  final String? cameraId;
  final bool connecting;
  final Stream<CameraFrame> stream;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<CameraFrame>(
      stream: stream,
      builder: (context, snapshot) {
        final text = error != null
            ? error!
            : connecting
            ? 'A ligar ao backend...'
            : cameraId == null
            ? 'A câmara ainda não foi registada.'
            : snapshot.hasData
            ? 'Streaming ativo: ${snapshot.data!.statusIa}'
            : 'Ligado. A aguardar frames...';
        final color = error != null
            ? theme.colorScheme.error
            : snapshot.hasData
            ? Colors.green
            : theme.colorScheme.onSurfaceVariant;

        return Row(
          children: [
            Icon(Icons.circle, size: 12, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(text)),
          ],
        );
      },
    );
  }
}

class _VideoPanel extends StatelessWidget {
  const _VideoPanel({required this.stream});

  final Stream<CameraFrame> stream;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        ),
        child: StreamBuilder<CameraFrame>(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Erro no streaming: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'O vídeo aparecerá aqui',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }

            final frame = snapshot.data!;
            return _FrameView(frame: frame);
          },
        ),
      ),
    );
  }
}

class _FrameView extends StatelessWidget {
  const _FrameView({required this.frame});

  final CameraFrame frame;

  @override
  Widget build(BuildContext context) {
    Uint8List bytes;
    try {
      bytes = base64Decode(frame.imagemBase64);
    } on FormatException {
      return const Center(
        child: Text(
          'Frame Base64 inválido',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.memory(bytes, fit: BoxFit.contain, gaplessPlayback: true),
        for (final caixa in frame.caixas)
          Positioned(
            left: caixa.left,
            top: caixa.top,
            width: caixa.width,
            height: caixa.height,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.redAccent, width: 2),
              ),
              child: Align(
                alignment: Alignment.topLeft,
                child: ColoredBox(
                  color: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      '${caixa.label} ${(caixa.confidence * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white, fontSize: 11),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
