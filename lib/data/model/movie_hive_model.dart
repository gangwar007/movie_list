import 'package:hive/hive.dart';

part 'movie_hive_model.g.dart';

@HiveType(typeId: 32)
class MovieHiveModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String overview;

  @HiveField(3)
  final String posterPath;

  @HiveField(4)
  bool isFavorite = false;

  MovieHiveModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.isFavorite,
  });

  // Helper method to update isFavorite
  void toggleFavorite() {
    isFavorite = !isFavorite;
    save(); // Save changes to Hive
  }
}
