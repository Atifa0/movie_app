import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = '3393282c6b48f18ca19bcce45e903966';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> searchMovies(String query) async {
    final url = Uri.parse(
        '$_baseUrl/search/movie?api_key=$_apiKey&query=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }

// Function to fetch genres
  Future<List<dynamic>> fetchGenres() async {
    final url = '$_baseUrl/genre/movie/list?api_key=$_apiKey&language=en-US';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['genres']; // List of genres
    } else {
      throw Exception('Failed to load genres');
    }
  }

  Future<List<dynamic>> fetchMoviesByGenre(int genreId) async {
    final url = '$_baseUrl/discover/movie?api_key=$_apiKey&with_genres=$genreId';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results']; // List of movies
    } else {
      throw Exception('Failed to load movies for genre');
    }
  }

}