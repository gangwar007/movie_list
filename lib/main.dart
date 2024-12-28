import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_list_example/data/model/movie_hive_model.dart';
import 'package:movie_list_example/presentation/block/movie_list_bloc.dart';
import 'package:movie_list_example/presentation/block/movie_list_event.dart';
import 'package:movie_list_example/presentation/pages/movie_list_page.dart';

import 'data/datasource/movie_local_data_source.dart';
import 'data/datasource/movie_remote_data_source_impl.dart';
import 'data/repositories/movie_repository_imp.dart';
import 'domain/usecases/fetch_favorites.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(MovieHiveModelAdapter());

  final favoritesBox = await Hive.openBox<MovieHiveModel>('favorites');

  runApp(MyApp(favoritesBox: favoritesBox));
}

class MyApp extends StatelessWidget {
  final Box<MovieHiveModel> favoritesBox;

  MyApp({required this.favoritesBox});

  @override
  Widget build(BuildContext context) {
    final repository = MovieRepositoryImp(
        remoteDataSource: MovieRemoteDataSource(),
        localDataSource: MovieLocalDataSource(),
        favoritesBox: favoritesBox);
    final fetchFavorite = FetchFavorite(repository);
    return MaterialApp(
      title: 'Movies App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => MovieBloc(
          fetchFavorite: fetchFavorite,
          repository: repository,
        )..add(CheckConnectionAndLoadMovies()),
        child: MovieListPage(),
      ),
    );
  }
}
