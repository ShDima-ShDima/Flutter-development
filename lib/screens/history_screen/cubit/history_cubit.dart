import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/db_provider.dart';
import 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryLoadingState()) {
    loadHistory();
  }

  /// Загрузка всех расчётов из SQflite
  Future<void> loadHistory() async {
    emit(HistoryLoadingState());
    try {
      final rows = await DBProvider.db.getAllEquations();
      emit(HistoryLoadedState(rows));
    } catch (e) {
      emit(HistoryErrorState('Не удалось загрузить историю: $e'));
    }
  }

  /// Удалить одну запись
  Future<void> deleteItem(int id) async {
    await DBProvider.db.deleteEquation(id);
    await loadHistory();
  }

  /// Очистить всю историю
  Future<void> clearAll() async {
    await DBProvider.db.deleteAll();
    await loadHistory();
  }
}