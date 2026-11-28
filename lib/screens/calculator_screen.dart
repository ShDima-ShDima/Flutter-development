import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/weather_model.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _controller = TextEditingController();
  final _box = Hive.box<CalcHistoryItem>('calc_history');
  String _result = '—';
  bool _cToF = true; // true: °C→°F, false: °F→°C

  void _convert() {
    final value = double.tryParse(_controller.text.trim());
    if (value == null) {
      setState(() => _result = 'Введите число');
      return;
    }
    final res = _cToF ? (value * 9 / 5) + 32 : (value - 32) * 5 / 9;
    final unit = _cToF ? '°F' : '°C';
    final inputStr = '${value.toStringAsFixed(1)} ${_cToF ? '°C' : '°F'}';
    final resultStr = '${res.toStringAsFixed(1)} $unit';

    _box.add(CalcHistoryItem(
      input: inputStr,
      result: resultStr,
      createdAt: DateTime.now(),
    ));
    setState(() => _result = resultStr);
  }

  void _clearHistory() => _box.clear();

  @override
  Widget build(BuildContext context) {
    final history = _box.values.toList().reversed.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Конвертер температур')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('°C → °F')),
                ButtonSegment(value: false, label: Text('°F → °C')),
              ],
              selected: {_cToF},
              onSelectionChanged: (s) => setState(() => _cToF = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              decoration: InputDecoration(
                labelText: _cToF ? 'Температура в °C' : 'Температура в °F',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _convert,
              icon: const Icon(Icons.sync_alt),
              label: const Text('Конвертировать'),
            ),
            const SizedBox(height: 20),
            Text('Результат: $_result',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('История расчётов',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: _clearHistory,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Очистить'),
                ),
              ],
            ),
            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text('История пуста'))
                  : ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (_, i) => ListTile(
                        leading: const Icon(Icons.swap_vert),
                        title: Text('${history[i].input} → ${history[i].result}'),
                        subtitle: Text(
                          '${history[i].createdAt.hour.toString().padLeft(2, '0')}:'
                          '${history[i].createdAt.minute.toString().padLeft(2, '0')} '
                          '${history[i].createdAt.day.toString().padLeft(2, '0')}.'
                          '${history[i].createdAt.month.toString().padLeft(2, '0')}.'
                          '${history[i].createdAt.year}',
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}