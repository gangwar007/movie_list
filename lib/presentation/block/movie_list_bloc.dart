import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_example/domain/enities/movie.dart';
import 'package:movie_list_example/domain/usecases/fetch_favorites.dart';

import '../../data/repositories/movie_repository_imp.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final FetchFavorite fetchFavorite;
  final MovieRepositoryImp repository;

  MovieBloc({
    required this.fetchFavorite,
    required this.repository,
  }) : super(MoviesInitial()) {
    on<CheckConnectionAndLoadMovies>(_checkConnectionAndLoadMovies);
    on<LoadMovies>(_loadMovies);
    on<LoadFavorites>(_loadFavorites);
    on<ToggleFavoriteMovie>(_toggleFavorite);
    on<SearchMovies>(_filteredMovie);
  }

  Future<void> _checkConnectionAndLoadMovies(
      CheckConnectionAndLoadMovies event, Emitter<MovieState> emit) async {
    emit(MoviesLoading());
    final connectivityResult = await Connectivity().checkConnectivity();

    log('dddddd===>>>$connectivityResult');
    if (connectivityResult == ConnectivityResult.none) {
      add(LoadFavorites()); // Trigger loading favorites when offline
    } else {
      add(LoadMovies()); // Trigger loading movies when online
    }
  }

  Future<void> _loadMovies(LoadMovies event, Emitter<MovieState> emit) async {
    emit(MoviesLoading());
    try {
      final movies = await repository.fetchMovies();
      emit(MoviesLoaded(movies));
    } catch (e) {
      if (e.toString().contains('No Internet connection')) {
        add(LoadFavorites()); // Fallback to offline favorites
      } else {
        emit(MoviesError('Error: ${e.toString()}'));
      }
    }
  }

  Future<void> _loadFavorites(
      LoadFavorites event, Emitter<MovieState> emit) async {
    try {
      // Load all saved movies from the repository
      final allMovies = await repository.loadFavorites();

      // Filter only movies marked as favorites
      final favorites = allMovies.where((movie) => movie.isFavorite).toList();

      // Ensure uniqueness by movie ID
      final uniqueFavorites = {
        for (var movie in favorites) movie.id: movie,
      }.values.toList();

      log('Loaded unique favorites: ${uniqueFavorites.map((m) => m.title).toList()}');

      // Emit the MoviesOffline state with only unique favorite movies
      emit(MoviesOffline(uniqueFavorites));
    } catch (e) {
      emit(MoviesError('Failed to load favorites: $e'));
    }
  }

  Future<void> _toggleFavorite(
      ToggleFavoriteMovie event, Emitter<MovieState> emit) async {
    try {
      final currentState = state;

      if (currentState is MoviesLoaded || currentState is MoviesOffline) {
        final currentFavorites = currentState is MoviesLoaded
            ? currentState.movies
            : (currentState as MoviesOffline).favorites;

        log('sdffssff===>>>${currentFavorites.length}');

        final updatedFavorites =
            await fetchFavorite(event.movie, currentFavorites);

        emit(MoviesOffline(updatedFavorites)); // Update offline favorites
      }
    } catch (e) {
      emit(MoviesError('Failed to toggle favorite: $e'));
    }
  }

  Future<void> _filteredMovie(
      SearchMovies event, Emitter<MovieState> emit) async {
    try {
      final currentState = state;
      List<Movie> movies = [];
      if (currentState is MoviesLoaded) {
        movies = currentState.movies
            .where((movie) => movie.title
                .toLowerCase()
                .contains(event.query.trim().toLowerCase()))
            .toList();

        for (Movie aaaa in movies) {
          log('fdsfsff===>>>${aaaa.title}');
        }

        emit(SearchMovie(movies));
      }
    } catch (e) {
      emit(MoviesError('Failed to toggle favorite: $e'));
    }
  }
}
