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
  String? _token;
  bool _disposed = false;

  CameraStreamService({
    Uri? baseUri,
    this.reconnectDelay = const Duration(seconds: 3),
  }) : baseUri = baseUri ?? Uri.parse('ws://192.168.0.65:8000/ws/camera/');
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

  Future<void> _open() async {
    if (_disposed || _cameraId == null || _token == null) return;
    await _channel?.sink.close();
    final uri = baseUri.replace(
      queryParameters: {'camera_id': _cameraId!, 'token': _token!},
    );
    final channel = WebSocketChannel.connect(uri);
    _channel = channel;
    channel.stream.listen(
      _onMessage,
      onError: (_) => _scheduleReconnect(),
      onDone: _scheduleReconnect,
      cancelOnError: true,
    );
  }

  void _onMessage(dynamic message) {
    try {
      final decoded = jsonDecode(message as String);
      if (decoded is Map)
        _frames.add(CameraFrame.fromJson(Map<String, dynamic>.from(decoded)));
    } on Object catch (error, stackTrace) {
      _frames.addError(error, stackTrace);
    }
  }

  void _scheduleReconnect() {
    if (_disposed || _reconnectTimer?.isActive == true) return;
    _reconnectTimer = Timer(reconnectDelay, _open);
  }

  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    await _channel?.sink.close();
    _channel = null;
  }

  Future<void> dispose() async {
    _disposed = true;
    await disconnect();
    await _frames.close();
  }
}
