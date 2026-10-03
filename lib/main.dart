import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Шепеленко Д.И. Вариант 7',
      home: const FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final _formKey = GlobalKey<FormState>();

  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();

  bool _agreement = false;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите число';
    }
    if (double.tryParse(value.replaceAll(',', '.')) == null) {
      return 'Некорректное число';
    }
    return null;
  }

  String? _validateA(String? value) {
    final baseError = _validateNumber(value);
    if (baseError != null) return baseError;

    final a = double.tryParse(value!.replaceAll(',', '.'));
    if (a == 0) {
      return 'a не может быть 0';
    }
    return null;
  }

  void _goToResult() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final a = double.parse(_aController.text.replaceAll(',', '.'));
    final b = double.parse(_bController.text.replaceAll(',', '.'));
    final c = double.parse(_cController.text.replaceAll(',', '.'));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecondScreen(a: a, b: b, c: c),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Шепеленко Д.И. Вариант 7'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Решение квадратного уравнения'),
              const SizedBox(height: 8),
              const Text('ax² + bx + c = 0'),
              const SizedBox(height: 16),

              TextFormField(
                controller: _aController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(labelText: 'Коэффициент a'),
                validator: _validateA,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _bController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(labelText: 'Коэффициент b'),
                validator: _validateNumber,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _cController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: const InputDecoration(labelText: 'Коэффициент c'),
                validator: _validateNumber,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _agreement,
                    onChanged: (value) {
                      setState(() {
                        _agreement = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text('Я согласен на обработку данных'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ElevatedButton(
                onPressed: _agreement ? _goToResult : null,
                child: const Text('Рассчитать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final double a;
  final double b;
  final double c;

  const SecondScreen({
    super.key,
    required this.a,
    required this.b,
    required this.c,
  });

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    final D = b * b - 4 * a * c;

    String result;
    if (D > 0) {
      final x1 = (-b + sqrt(D)) / (2 * a);
      final x2 = (-b - sqrt(D)) / (2 * a);
      result = 'D = ${_formatNumber(D)}\n'
          'x1 = ${_formatNumber(x1)}\n'
          'x2 = ${_formatNumber(x2)}';
    } else if (D == 0) {
      final x = -b / (2 * a);
      result = 'D = 0\n'
          'x = ${_formatNumber(x)}';
    } else {
      result = 'D = ${_formatNumber(D)}\n'
          'Нет действительных корней';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Результат'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Уравнение: ${_formatNumber(a)}x² + '
              '${_formatNumber(b)}x + ${_formatNumber(c)} = 0',
            ),
            const SizedBox(height: 16),
            Text(result),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }
}