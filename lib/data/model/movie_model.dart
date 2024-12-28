import '../../domain/enities/movie.dart';

class MovieModel extends Movie {
  MovieModel({
    required int id,
    required String title,
    required String posterPath,
    required String overview,
    bool isFavorite = false,
  }) : super(
          id: id,
          title: title,
          posterPath: posterPath,
          overview: overview,
          isFavorite: isFavorite,
        );

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'],
      overview: json['overview'],
      isFavorite: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'overview': overview,
      'isFavorite': isFavorite,
    };
  }
}
