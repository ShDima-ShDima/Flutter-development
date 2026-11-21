import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../history_screen/history_screen_provider.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _formKey = GlobalKey<FormState>();
  final _aController = TextEditingController();
  final _bController = TextEditingController();
  final _cController = TextEditingController();
  bool _agreement = false;
  bool _prefilled = false;

  @override
  void dispose() {
    _aController.dispose();
    _bController.dispose();
    _cController.dispose();
    super.dispose();
  }

  /// Подстановка сохранённых значений из SharedPreferences (только один раз)
  void _prefillIfPossible(MainScreenInitialState state) {
    if (_prefilled) return;
    if (state.lastA == null && state.lastB == null && state.lastC == null) {
      return;
    }
    _aController.text = state.lastA ?? '';
    _bController.text = state.lastB ?? '';
    _cController.text = state.lastC ?? '';
    _prefilled = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.history),
          tooltip: 'История решений',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HistoryScreenProvider(),
              ),
            );
          },
        ),
        title: const Text('Шепеленко Д.И. Вариант 7'),
      ),
      body: BlocBuilder<MainScreenCubit, MainScreenState>(
        builder: (context, state) {
          if (state is MainScreenResultState) {
            return _buildResultView(context, state);
          }
          if (state is MainScreenInitialState) {
            _prefillIfPossible(state);
          }
          return _buildInputView(context, state);
        },
      ),
    );
  }

  // ---------------- Ввод ----------------
  Widget _buildInputView(BuildContext context, MainScreenState state) {
    final numberFormatter = FilteringTextInputFormatter.allow(
      RegExp(r'^-?\d*[.,]?\d*$'),
    );

    return SingleChildScrollView(
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
                  decimal: true, signed: true),
              inputFormatters: [numberFormatter],
              decoration: const InputDecoration(labelText: 'Коэффициент a'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              inputFormatters: [numberFormatter],
              decoration: const InputDecoration(labelText: 'Коэффициент b'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _cController,
              keyboardType: const TextInputType.numberWithOptions(
                  decimal: true, signed: true),
              inputFormatters: [numberFormatter],
              decoration: const InputDecoration(labelText: 'Коэффициент c'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _agreement,
                  onChanged: (v) => setState(() => _agreement = v ?? false),
                ),
                const Expanded(child: Text('Я согласен на обработку данных')),
              ],
            ),
            if (state is MainScreenErrorState) ...[
              const SizedBox(height: 12),
              Text(state.message,
                  style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _agreement
                  ? () {
                      if (!_formKey.currentState!.validate()) return;
                      context.read<MainScreenCubit>().solveEquation(
                            aText: _aController.text,
                            bText: _bController.text,
                            cText: _cController.text,
                          );
                    }
                  : null,
              child: const Text('Рассчитать'),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Результат ----------------
  Widget _buildResultView(BuildContext context, MainScreenResultState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Уравнение: ${_fmt(state.a)}x² + '
            '${_fmt(state.b)}x + ${_fmt(state.c)} = 0',
          ),
          const SizedBox(height: 16),
          Text(state.resultText),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<MainScreenCubit>().reset(),
            child: const Text('Назад'),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) {
    if (v == v.roundToDouble()) return v.toInt().toString();
    return v
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }
}