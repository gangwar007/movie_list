import '../../data/repositories/movie_repository_imp.dart';
import '../enities/movie.dart';

class FetchFavorite {
  final MovieRepositoryImp repository;

  FetchFavorite(this.repository);

  Future<List<Movie>> call(Movie movie, List<Movie> currentFavorites) async {
    movie.isFavorite = !movie.isFavorite;

    if (movie.isFavorite) {
      currentFavorites.add(movie);
    } else {
      currentFavorites.removeWhere((m) => m.id == movie.id);
    }

    await repository.saveFavorites(currentFavorites);
    return currentFavorites;
  }
}
