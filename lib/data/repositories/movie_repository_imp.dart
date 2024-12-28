import 'package:hive/hive.dart';
import 'package:movie_list_example/domain/repositories/movie_repository.dart';

import '../../domain/enities/movie.dart';
import '../datasource/movie_local_data_source.dart';
import '../datasource/movie_remote_data_source_impl.dart';
import '../model/movie_hive_model.dart';

class MovieRepositoryImp implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final Box<MovieHiveModel> favoritesBox;

  MovieRepositoryImp(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.favoritesBox});

  Future<List<Movie>> fetchMovies() async {
    try {
      return await remoteDataSource.fetchMovies();
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<void> saveFavorites(List<Movie> favorites) async {
    final hiveFavorites = favorites.map((movie) => MovieHiveModel(
          id: movie.id,
          title: movie.title,
          overview: movie.overview,
          posterPath: movie.posterPath,
          isFavorite: movie.isFavorite,
        ));

    await favoritesBox.clear();
    await favoritesBox.addAll(hiveFavorites);
  }

  Future<List<Movie>> loadFavorites() async {
    final favorites = favoritesBox.values.map((hiveModel) => Movie(
          id: hiveModel.id,
          title: hiveModel.title,
          overview: hiveModel.overview,
          posterPath: hiveModel.posterPath,
          isFavorite: hiveModel.isFavorite,
        ));

    return favorites.toList();
  }
}
