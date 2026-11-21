import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/history_cubit.dart';
import 'history_screen.dart';

class HistoryScreenProvider extends StatelessWidget {
  const HistoryScreenProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HistoryCubit>(
      create: (_) => HistoryCubit(),
      child: const HistoryScreen(),
    );
  }
}