import 'package:equatable/equatable.dart';

import '../../domain/enities/movie.dart';

abstract class MovieEvent extends Equatable {}

class LoadMovies extends MovieEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ToggleFavoriteMovie extends MovieEvent {
  final Movie movie;

  ToggleFavoriteMovie(this.movie);

  @override
  // TODO: implement props
  List<Object?> get props => [movie];
}

class SearchMovies extends MovieEvent {
  final String query;

  SearchMovies(this.query);

  @override
  // TODO: implement props
  List<Object?> get props => [query];
}

class LoadFavorites extends MovieEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckConnectionAndLoadMovies extends MovieEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
