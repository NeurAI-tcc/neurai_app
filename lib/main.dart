import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CadastroCameraScreen(),
    );
  }
}

class CadastroCameraScreen extends StatefulWidget {
  const CadastroCameraScreen({super.key});

  @override
  State<CadastroCameraScreen> createState() => _CadastroCameraScreenState();
}

class _CadastroCameraScreenState extends State<CadastroCameraScreen> {
  late WebSocketChannel channel;
  final TextEditingController _ipController = TextEditingController();
  bool _aguardandoVideo = false;

  @override
  void initState() {
    super.initState();
    // Use 10.0.2.2 para emulador Android ou seu IP local real para celular físico
    final wsUrl = Uri.parse('ws://127.0.0.1:8000/ws/camera/');
    channel = WebSocketChannel.connect(wsUrl);
  }

  @override
  void dispose() {
    channel.sink.close();
    _ipController.dispose();
    super.dispose();
  }

  void _salvarEAssistir() {
    if (_ipController.text.isNotEmpty) {
      channel.sink.add(jsonEncode({'ip_camera': _ipController.text}));

      setState(() {
        _aguardandoVideo = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: const Text('Cadastrar e Monitorizar')),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: 'IP (ex: 0 para webcam local)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _salvarEAssistir,
                  child: const Text('Salvar'),
                ),
              ],
            ),
          ),

          Expanded(
            child: _aguardandoVideo
                ? StreamBuilder(
                    stream: channel.stream,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final dadosJson = jsonDecode(snapshot.data as String);
                        final bytesImagem = base64Decode(
                          dadosJson['imagem_base64'],
                        );

                        return Image.memory(
                          bytesImagem,
                          gaplessPlayback: true,
                          fit: BoxFit.contain,
                          width: double.infinity,
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.blue),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Escreva o IP em cima para iniciar.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
