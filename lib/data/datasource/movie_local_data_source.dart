import 'package:hive/hive.dart';
import 'package:movie_list_example/data/model/movie_hive_model.dart';

import '../model/movie_model.dart';

class MovieLocalDataSource {
  Future<List<MovieHiveModel>> loadFavorites() async {
    final box = await Hive.openBox<MovieHiveModel>('favorites');
    return box.values.toList();
  }

  Future<void> saveFavorites(List<MovieModel> movies) async {
    final box = await Hive.openBox<MovieModel>('favorites');
    await box.clear(); // Clear existing favorites
    await box.addAll(movies);
  }
}
