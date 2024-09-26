import 'dart:convert';
import 'package:http/http.dart' as http;

class MovieService {
  final String _apiKey = '3393282c6b48f18ca19bcce45e903966';
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<dynamic>> searchMovies(String query) async {
    final url =
        Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['results'];
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
