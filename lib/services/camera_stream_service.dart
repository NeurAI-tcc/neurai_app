import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/camera_frame_model.dart';

class CameraStreamService {
  final Uri baseUri;
  final Duration reconnectDelay;

  final StreamController<CameraFrame> _frames =
      StreamController<CameraFrame>.broadcast();

  WebSocketChannel? _channel;
  Timer? _reconnectTimer;

  String? _cameraId;
  String? _cameraIp;
  String? _token;

  Map<String, dynamic>? _ultimoResultadoIA;

  bool _disposed = false;
  bool _conectando = false;

  CameraStreamService({
    Uri? baseUri,
    this.reconnectDelay = const Duration(seconds: 3),
  }) : baseUri =
           baseUri ??
           Uri.parse(
             const String.fromEnvironment(
               'NEURAI_WS_URL',
               defaultValue: 'ws://10.161.94.46:8000/ws/camera/',
             ),
           );

  Stream<CameraFrame> get frames => _frames.stream;

  Future<void> connect({
    required String cameraId,
    required String token,
  }) async {
    _cameraId = cameraId;
    _token = token;
    _reconnectTimer?.cancel();
    await _open();
  }

  Future<void> connectWithCameraIp({
    required String cameraId,
    required String cameraIp,
    required String token,
  }) async {
    _cameraIp = cameraIp;
    await connect(cameraId: cameraId, token: token);
  }

  Future<void> _open() async {
    if (_disposed ||
        _conectando ||
        _cameraId == null ||
        _cameraIp == null ||
        _token == null ||
        _cameraIp!.isEmpty) {
      return;
    }

    _conectando = true;

    try {
      await _channel?.sink.close();

      final uri = baseUri.replace(
        path:
            '${baseUri.path.replaceFirst(RegExp(r'/$'), '')}/${Uri.encodeComponent(_cameraId!)}/',
        queryParameters: {'token': _token!, 'camera_ip': _cameraIp!},
      );

      final channel = WebSocketChannel.connect(uri);
      _channel = channel;

      channel.stream.listen(
        _onMessage,
        onError: (error) {
          print('ERRO NO WEBSOCKET: $error');
          _scheduleReconnect();
        },
        onDone: () {
          print('WEBSOCKET DESCONECTADO');
          _scheduleReconnect();
        },
        cancelOnError: true,
      );

      await channel.ready;
      print('WEBSOCKET CONECTADO: $uri');
    } catch (error) {
      print('FALHA AO CONECTAR WEBSOCKET: $error');
      _scheduleReconnect();
    } finally {
      _conectando = false;
    }
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String);

      if (decoded is! Map) return;

      final data = Map<String, dynamic>.from(decoded);
      final tipo = data['type'];

      if (tipo == 'camera_status') {
        print('STATUS DA CÂMERA: ${data['status']}');
        return;
      }

      if (tipo == 'ai_result') {
        final resultado = data['result'];

        if (resultado is Map) {
          _ultimoResultadoIA = Map<String, dynamic>.from(resultado);

          print('RESULTADO DA IA RECEBIDO: $_ultimoResultadoIA');
        }

        return;
      }

      if (tipo == 'video_frame') {
        final metadata = data['metadata'] is Map
            ? Map<String, dynamic>.from(data['metadata'])
            : <String, dynamic>{};

        metadata['imagem_base64'] = data['frame'] ?? '';
        metadata['status_ia'] = 'normal';

        // Resultado da IA para desenhar o quadrado.
        metadata['caixas'] = _ultimoResultadoIA != null
            ? [_ultimoResultadoIA]
            : [];

        metadata['timestamp'] = DateTime.now().toIso8601String();

        _frames.add(CameraFrame.fromJson(metadata));
        return;
      }

      // Compatibilidade com o formato antigo.
      if (tipo == 'video_frames') {
        final frames = data['frames'];
        if (frames is! List) return;

        for (final item in frames) {
          if (item is! Map) continue;

          final frameData = Map<String, dynamic>.from(item);

          final metadata = frameData['metadata'] is Map
              ? Map<String, dynamic>.from(frameData['metadata'])
              : <String, dynamic>{};

          metadata['imagem_base64'] = frameData['frame'] ?? '';

          metadata['caixas'] = _ultimoResultadoIA != null
              ? [_ultimoResultadoIA]
              : [];

          metadata['timestamp'] = DateTime.now().toIso8601String();

          _frames.add(CameraFrame.fromJson(metadata));
        }
      }
    } catch (error, stackTrace) {
      print('ERRO AO RECEBER PACOTE: $error');
      print(stackTrace);
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer?.isActive == true) {
      return;
    }

    _reconnectTimer = Timer(reconnectDelay, () {
      _reconnectTimer = null;
      _open();
    });
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;

    final channel = _channel;
    _channel = null;

    await channel?.sink.close();
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _frames.close();
  }
}
