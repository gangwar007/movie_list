import '../enities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> fetchMovies();
  Future<void> saveFavorites(List<Movie> favorites);
  Future<List<Movie>> loadFavorites();
}
