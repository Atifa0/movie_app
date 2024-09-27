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
    required List genres,
    required this.runtime,
    required this.actors,
  });

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  bool isLoading = true;
  String errorMessage = '';
  List<dynamic> similarMovies = [];
  List<String> genres = [];
  String certification = '';
  int runtime = 0;

  @override
  void initState() {
    super.initState();
    fetchMovieDetails();
    fetchSimilarMovies();
    fetchMovieCertification();
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
          runtime = data['runtime']; // Get runtime from the API response
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

  Future<void> fetchMovieCertification() async {
    final String apiKey = '3393282c6b48f18ca19bcce45e903966';
    final url =
        'https://api.themoviedb.org/3/movie/${widget.movieId}/release_dates?api_key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final results = data['results'] as List;

        // Extract certification for US
        final usCertification = results.firstWhere(
            (element) => element['iso_3166_1'] == 'US',
            orElse: () => null);

        if (usCertification != null) {
          final releaseDates = usCertification['release_dates'] as List;
          if (releaseDates.isNotEmpty) {
            setState(() {
              certification = releaseDates[0]['certification'];
            });
          }
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load certification';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
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

  // Format release year from releaseDate
  String formatReleaseYear(String releaseDate) {
    if (releaseDate.isNotEmpty) {
      return releaseDate.split('-').first;
    }
    return 'Unknown';
  }

  // Format runtime in hours and minutes
  String formatDuration(int runtime) {
    int hours = runtime ~/ 60;
    int minutes = runtime % 60;
    return '${hours}h ${minutes}m';
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Movie title
                              Text(
                                widget.title.isEmpty
                                    ? 'Loading...'
                                    : widget.title,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    formatReleaseYear(widget.releaseDate),
                                    style: TextStyle(
                                      color: Color(0xffb5b4b4),
                                      fontSize: 12,
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  // PG Rating (Certification)
                                  if (certification.isNotEmpty)
                                    Text(
                                      certification,
                                      style: TextStyle(
                                        color: Color(0xffb5b4b4),
                                        fontSize: 12,
                                      ),
                                    ),
                                  SizedBox(width: 10),

                                  Text(
                                    formatDuration(runtime),
                                    style: TextStyle(
                                      color: Color(0xffb5b4b4),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                                        height: 180, color: Color(0xff282a2b)),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Wrap(
                                      spacing: 8.0,
                                      children: genres.map((genre) {
                                        return Chip(
                                          label: Text(
                                            genre,
                                            style: TextStyle(
                                                color: Color(0xffcbcbcb)),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                similarMovies.isNotEmpty
                                    ? MoreLikeThisSection(movies: similarMovies)
                                    : Text(
                                        'No similar movies found',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
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
