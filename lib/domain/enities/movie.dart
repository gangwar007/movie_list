class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;
  bool isFavorite = false;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.isFavorite,
  });
}
