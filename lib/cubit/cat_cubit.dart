import 'package:flutter_bloc/flutter_bloc.dart';
import '../requests/api.dart';
import 'cat_state.dart';

class CatCubit extends Cubit<CatState> {
  final CatApi _api = CatApi();

  CatCubit() : super(CatLoadingState());

  Future<void> loadData() async {
    try {
      final images = await _api.fetchCatImages(limit: 10);
      emit(CatLoadedState(images));
    } catch (e) {
      emit(CatErrorState(e.toString()));
    }
  }
}