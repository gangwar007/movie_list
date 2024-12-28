import 'package:dio/dio.dart';

import '../model/movie_model.dart';

class MovieRemoteDataSource {
  final Dio dio = Dio();

  Future<List<MovieModel>> fetchMovies() async {
    try {
      final response = await dio.get(
          'https://api.themoviedb.org/3/movie/popular?api_key=bd6068532563fcd7a4739289cf0aad20');
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> results = data['results'];
        return results
            .map((movie) => MovieModel.fromJson(movie as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } on DioException catch (dioError) {
      // Handle DioError based on its type
      switch (dioError.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception('Connection timed out. Please try again.');
        case DioExceptionType.sendTimeout:
          throw Exception('Request send timeout. Please try again.');
        case DioExceptionType.receiveTimeout:
          throw Exception('Server took too long to respond. Please try again.');
        case DioExceptionType.badResponse:
          throw Exception('Server error: ${dioError.response?.statusCode}');
        case DioExceptionType.cancel:
          throw Exception('Request was cancelled.');
        case DioExceptionType.unknown:
          throw Exception('No internet connection. Please check your network.');
        default:
          throw Exception('Unexpected error occurred: $dioError');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
}
