import 'package:flutter/material.dart';
import '../../models/agenda_model.dart';

class EventoFormDialog extends StatefulWidget {
  final DateTime dataInicial;

  const EventoFormDialog({super.key, required this.dataInicial});

  @override
  State<EventoFormDialog> createState() => _EventoFormDialogState();
}

class _EventoFormDialogState extends State<EventoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _localController = TextEditingController();
  late DateTime _data;
  TimeOfDay _inicio = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _fim = const TimeOfDay(hour: 10, minute: 0);

  @override
  void initState() {
    super.initState();
    _data = DateTime(
      widget.dataInicial.year,
      widget.dataInicial.month,
      widget.dataInicial.day,
    );
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _localController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (data != null) setState(() => _data = data);
  }

  Future<void> _selecionarHorario({required bool inicio}) async {
    final horario = await showTimePicker(
      context: context,
      initialTime: inicio ? _inicio : _fim,
    );
    if (horario == null) return;
    setState(() {
      if (inicio) {
        _inicio = horario;
      } else {
        _fim = horario;
      }
    });
  }

  DateTime _combinar(TimeOfDay horario) => DateTime(
    _data.year,
    _data.month,
    _data.day,
    horario.hour,
    horario.minute,
  );

  void _salvar() {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;
    final inicio = _combinar(_inicio);
    final fim = _combinar(_fim);
    if (!fim.isAfter(inicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O horário final deve ser após o inicial.'),
        ),
      );
      return;
    }
    Navigator.pop(
      context,
      EventoModel(
        id: '',
        titulo: _tituloController.text.trim(),
        inicio: inicio,
        fim: fim,
        localizacao: _localController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Novo evento'),
    content: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe o título'
                  : null,
            ),
            TextFormField(
              controller: _localController,
              decoration: const InputDecoration(labelText: 'Localização'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Informe a localização'
                  : null,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Data'),
              subtitle: Text(
                '${_data.day.toString().padLeft(2, '0')}/'
                '${_data.month.toString().padLeft(2, '0')}/${_data.year}',
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: _selecionarData,
            ),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Início'),
                    subtitle: Text(_inicio.format(context)),
                    onTap: () => _selecionarHorario(inicio: true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Fim'),
                    subtitle: Text(_fim.format(context)),
                    onTap: () => _selecionarHorario(inicio: false),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _salvar, child: const Text('Salvar')),
    ],
  );
}
