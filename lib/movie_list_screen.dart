import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/MovieDetails.dart';

class MovieListScreen extends StatefulWidget {
  final int genreId;
  final String genreName;

  MovieListScreen({required this.genreId, required this.genreName});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  List<dynamic> movies = [];
  final String apiKey = '3393282c6b48f18ca19bcce45e903966';
  final String baseUrl = 'https://api.themoviedb.org/3';

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    final url =
        '$baseUrl/discover/movie?api_key=$apiKey&with_genres=${widget.genreId}';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        movies = data['results'];
      });
    } else {
      throw Exception('Failed to load movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.genreName),
        backgroundColor: Colors.black,
      ),
      body: movies.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return ListTile(
                  leading: CachedNetworkImage(
                    imageUrl:
                        'https://image.tmdb.org/t/p/w500${movie['poster_path']}',
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  title: Text(
                    movie['title'],
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    movie['release_date'] ?? 'Unknown',
                    style: TextStyle(color: Colors.white70),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetailScreen(
                          movieId: movie['id'],
                          title: movie['title'],
                          overview: movie['overview'] ?? '',
                          posterPath: movie['poster_path'] ?? '',
                          releaseDate: movie['release_date'] ?? '',
                          rating: movie['vote_average'] ?? 0.0,
                          runtime: 'N/A',
                          actors: [],
                          genres: [],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
