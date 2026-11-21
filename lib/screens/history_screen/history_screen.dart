import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/history_cubit.dart';
import 'cubit/history_state.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _fmt(dynamic v) {
    final d = (v as num).toDouble();
    if (d == d.roundToDouble()) return d.toInt().toString();
    return d
        .toStringAsFixed(4)
        .replaceAll(RegExp(r'0+$'), '')
        .replaceAll(RegExp(r'\.$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('История решений'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            tooltip: 'Очистить историю',
            onPressed: () async {
              final ok = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Очистить всю историю?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Очистить'),
                    ),
                  ],
                ),
              );
              if (ok == true && context.mounted) {
                context.read<HistoryCubit>().clearAll();
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) {
          if (state is HistoryLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is HistoryErrorState) {
            return Center(child: Text(state.message));
          }
          final items = (state as HistoryLoadedState).items;
          if (items.isEmpty) {
            return const Center(child: Text('История пуста'));
          }
          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final row = items[i];
              final dt = DateTime.tryParse(row['created_at'] as String? ?? '');
              return ListTile(
                leading: CircleAvatar(child: Text('${i + 1}')),
                title: Text(
                  '${_fmt(row['a'])}x² + ${_fmt(row['b'])}x + '
                  '${_fmt(row['c'])} = 0',
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(row['result'] as String? ?? ''),
                    if (dt != null)
                      Text(
                        '${dt.day.toString().padLeft(2, '0')}.'
                        '${dt.month.toString().padLeft(2, '0')}.'
                        '${dt.year} '
                        '${dt.hour.toString().padLeft(2, '0')}:'
                        '${dt.minute.toString().padLeft(2, '0')}',
                        style: const TextStyle(fontSize: 11),
                      ),
                  ],
                ),
                isThreeLine: true,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () =>
                      context.read<HistoryCubit>().deleteItem(row['id'] as int),
                ),
              );
            },
          );
        },
      ),
    );
  }
}