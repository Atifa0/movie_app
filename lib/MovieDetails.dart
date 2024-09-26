import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'More_Like_This.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double rating;
  final String runtime;
  final List<String> actors;

  MovieDetailScreen({
    required this.movieId,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.rating,
    required this.runtime,
    required this.actors,
    required List genres,
  });

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> similarMovies = [];
  List<String> genres = [];

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchSimilarMovies();
  }

  Future<void> fetchMovieDetails() async {
    final String apiKey = '3393282c6b48f18ca19bcce45e903966';
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movieId}?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          genres =
              List<String>.from(data['genres'].map((genre) => genre['name']));
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load movie details';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSimilarMovies() async {
    final String apiKey = '3393282c6b48f18ca19bcce45e903966';
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movieId}/similar?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          similarMovies = json.decode(response.body)['results'];
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load similar movies';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff121312),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          widget.title.isEmpty ? 'Loading...' : widget.title,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: Color(0xff121312),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(
                    child:
                        Text(errorMessage, style: TextStyle(color: Colors.red)))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            widget.posterPath.isNotEmpty
                                ? Image.network(
                                    'https://image.tmdb.org/t/p/w500${widget.posterPath}',
                                    height: 400,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  )
                                : CircularProgressIndicator(),
                            Icon(
                              Icons.play_circle_outline,
                              color: Colors.white,
                              size: 100,
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            widget.title.isEmpty ? 'Loading...' : widget.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 120,
                                child: widget.posterPath.isNotEmpty
                                    ? Image.network(
                                        'https://image.tmdb.org/t/p/w500${widget.posterPath}',
                                        height: 180,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        height: 180, color: Colors.grey[800]),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                widget.runtime.isNotEmpty
                                                    ? widget.runtime
                                                    : '',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          widget.releaseDate.isNotEmpty
                                              ? widget.releaseDate
                                                  .split('-')
                                                  .first
                                              : '',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8.0,
                                      children: genres.map((genre) {
                                        return Chip(
                                          label: Text(
                                            genre,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(0xff121312),
                                          shape: RoundedRectangleBorder(
                                            side: BorderSide(
                                                color: Color(0xff514F4F),
                                                width: 2),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Overview',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      widget.overview.isNotEmpty
                                          ? widget.overview
                                          : 'No overview available.',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 20,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          widget.rating != 0.0
                                              ? widget.rating.toString()
                                              : '',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          color: Color(0xFF282A28),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'More Like This',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                similarMovies.isNotEmpty
                                    ? MoreLikeThisSection(movies: similarMovies)
                                    : Text(
                                        'No similar movies found',
                                        style: TextStyle(color: Colors.white),
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
