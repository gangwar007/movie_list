import 'package:equatable/equatable.dart';

import '../../domain/enities/movie.dart';

abstract class MovieState extends Equatable {}

class MoviesInitial extends MovieState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MoviesLoading extends MovieState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class MoviesLoaded extends MovieState {
  final List<Movie> movies;

  MoviesLoaded(this.movies);

  @override
  // TODO: implement props
  List<Object?> get props => [movies];
}

class MoviesOffline extends MovieState {
  final List<Movie> favorites;

  MoviesOffline(this.favorites);

  @override
  // TODO: implement props
  List<Object?> get props => [favorites];
}

class SearchMovie extends MovieState {
  final List<Movie> filteredMovie;

  SearchMovie(this.filteredMovie);

  @override
  // TODO: implement props
  List<Object?> get props => [filteredMovie];
}

class MoviesError extends MovieState {
  final String error;

  MoviesError(this.error);

  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
