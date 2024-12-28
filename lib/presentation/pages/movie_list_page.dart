import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_list_example/presentation/block/movie_list_state.dart';

import '../../domain/enities/movie.dart';
import '../block/movie_list_bloc.dart';
import '../block/movie_list_event.dart';
import 'movie_card.dart';
import 'movie_detail_page.dart';

class MovieListPage extends StatefulWidget {
  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _currentSearchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      final newQuery = _searchController.text;

      log('queryy==>$newQuery');
      if (newQuery != _currentSearchQuery) {
        _currentSearchQuery = newQuery;
        context.read<MovieBloc>().add(SearchMovies(_currentSearchQuery));
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Trigger loading data when the app is loaded
    return Scaffold(
        appBar: AppBar(
          title: const Text('Movies'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MoviesLoading) {
              // Show a loading spinner
              return const Center(child: CircularProgressIndicator());
            } else if (state is MoviesError) {
              // Show an error message
              return Center(child: Text(state.error));
            } else if (state is MoviesLoaded) {
              // Show movies in a grid view
              return movieList(state.movies);
            } else if (state is MoviesOffline) {
              // Show movies in a grid view

              return movieList(state.favorites);
            } else if (state is SearchMovie) {
              // Show movies in a grid view
              if (state.filteredMovie.isEmpty) {
                return Center(child: Text('No movies found.'));
              }
              return movieList(state.filteredMovie);
            }
            return Center(child: Text('No data available.'));
          },
        ));
  }

  Widget movieList(List<Movie> movies) {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.7, // Adjust card size ratio
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        log('sjfsdfjsfkjns===>>>${movie.title}');
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailPage(movie: movie),
              ),
            );
          },
          child: MovieCard(
            movie: movie,
          ),
        );
      },
    );
  }
}
