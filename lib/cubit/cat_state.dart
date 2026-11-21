import '../models/cat_image.dart';

abstract class CatState {}

class CatLoadingState extends CatState {}

class CatLoadedState extends CatState {
  final List<CatImage> images;
  CatLoadedState(this.images);
}

class CatErrorState extends CatState {
  final String message;
  CatErrorState(this.message);
}