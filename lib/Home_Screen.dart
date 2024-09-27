import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/MovieDetails.dart';

class Home_Screen extends StatefulWidget {
  static const String RouteName = 'HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<Home_Screen> {
  final String apiKey = '3393282c6b48f18ca19bcce45e903966';
  final String baseUrl = 'https://api.themoviedb.org/3';

  List popularMovies = [];
  List upcomingMovies = [];
  List topRatedMovies = [];
  dynamic featuredMovie;

  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    await fetchPopularMovies();
    await fetchUpcomingMovies();
    await fetchTopRatedMovies();
  }

  Future<void> fetchPopularMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/popular?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      setState(() {
        popularMovies = json.decode(response.body)['results'];
        if (popularMovies.isNotEmpty) {
          featuredMovie = popularMovies[0];
        }
      });
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  Future<void> fetchUpcomingMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      setState(() {
        upcomingMovies = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<void> fetchTopRatedMovies() async {
    final response = await http.get(
      Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey'),
    );
    if (response.statusCode == 200) {
      setState(() {
        topRatedMovies = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load top-rated movies');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff121312),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featuredMovie != null)
              FeaturedMovieSection(movie: featuredMovie),
            SizedBox(height: 100),
            CategorySection(title: 'New Releases', movies: upcomingMovies),
            SizedBox(height: 20),
            CategorySection(title: 'Recommended', movies: topRatedMovies),
            SizedBox(height: 20),
            CategorySection(title: 'Popular Movies', movies: popularMovies),
          ],
        ),
      ),
    );
  }
}

class FeaturedMovieSection extends StatelessWidget {
  final dynamic movie;
  final String imageUrl = 'https://image.tmdb.org/t/p/w500';

  FeaturedMovieSection({required this.movie});

  Future<String> fetchCertification() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}/release_dates?api_key=3393282c6b48f18ca19bcce45e903966'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      final usCertification = data.firstWhere(
            (element) => element['iso_3166_1'] == 'US',
        orElse: () => null,
      );

      if (usCertification != null) {
        final releaseDates = usCertification['release_dates'] as List;
        if (releaseDates.isNotEmpty) {
          return releaseDates.first['certification'] ?? 'NR';
        }
      }
      return 'NR';
    } else {
      throw Exception('Failed to load certification');
    }
  }

  Future<String> fetchDuration() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}?api_key=3393282c6b48f18ca19bcce45e903966'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int runtime = data['runtime'] ?? 0;
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;
      return '${hours}h ${minutes}m';
    } else {
      throw Exception('Failed to load movie duration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage('$imageUrl${movie['backdrop_path']}'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ),
        Center(
          child: Icon(
            Icons.play_circle_fill,
            size: 80,
            color: Colors.white,
          ),
        ),
        Positioned(
          left: 10,
          bottom: -70,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 220,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '$imageUrl${movie['poster_path']}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie['title'] ?? 'No title',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    FutureBuilder<String>(
                      future: fetchCertification(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text(
                            '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} Fetching...',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 16),
                          );
                        } else if (snapshot.hasError) {
                          return Text(
                            '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} NR',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 16),
                          );
                        } else {
                          return FutureBuilder<String>(
                            future: fetchDuration(),
                            builder: (context, durationSnapshot) {
                              if (durationSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} Fetching...',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                );
                              } else if (durationSnapshot.hasError) {
                                return Text(
                                  '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} 0h 0m',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                );
                              } else {
                                return Text(
                                  '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} ${durationSnapshot.data}',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CategorySection extends StatelessWidget {
  final String title;
  final List movies;

  CategorySection({required this.title, required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF282A28),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 250,
            child: movies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];
                return MovieCard(movie: movie);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final dynamic movie;
  final String imageUrl = 'https://image.tmdb.org/t/p/w500';

  MovieCard({required this.movie});

  Future<String> fetchCertification() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}/release_dates?api_key=3393282c6b48f18ca19bcce45e903966'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['results'] as List;
      final usCertification = data.firstWhere(
            (element) => element['iso_3166_1'] == 'US',
        orElse: () => null,
      );

      if (usCertification != null) {
        final releaseDates = usCertification['release_dates'] as List;
        if (releaseDates.isNotEmpty) {
          return releaseDates.first['certification'] ?? 'NR';
        }
      }
      return 'NR';
    } else {
      throw Exception('Failed to load certification');
    }
  }

  Future<String> fetchDuration() async {
    final response = await http.get(
      Uri.parse(
          'https://api.themoviedb.org/3/movie/${movie['id']}?api_key=3393282c6b48f18ca19bcce45e903966'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      int runtime = data['runtime'] ?? 0;
      int hours = runtime ~/ 60;
      int minutes = runtime % 60;
      return '${hours}h ${minutes}m';
    } else {
      throw Exception('Failed to load movie duration');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MovieDetailScreen(
              movieId: movie['id'],
              title: movie['title'] ?? 'No title',
              overview: movie['overview'] ?? 'No overview available.',
              posterPath: movie['poster_path'] ?? '',
              releaseDate: movie['release_date'] ?? 'Unknown release date',
              rating: (movie['vote_average'] as num?)?.toDouble() ?? 0.0,
              runtime: '',
              actors: [],
              genres: [],
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Color(0xFF343534),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: movie['poster_path'] != null
                  ? Image.network(
                '$imageUrl${movie['poster_path']}',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              )
                  : Container(
                height: 150,
                color: Colors.grey,
                child: Icon(Icons.movie, color: Colors.white, size: 50),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      SizedBox(width: 5),
                      Text(
                        '${movie['vote_average']}',
                        style: TextStyle(color: Colors.white70, fontSize: 10),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    movie['title'] ?? 'No Title',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  FutureBuilder<String>(
                    future: fetchCertification(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          'Fetching...',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'NR',
                          style: TextStyle(color: Colors.white70, fontSize: 10),
                        );
                      } else {
                        return FutureBuilder<String>(
                          future: fetchDuration(),
                          builder: (context, durationSnapshot) {
                            if (durationSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} ...',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              );
                            } else if (durationSnapshot.hasError) {
                              return Text(
                                '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} 0h 0m',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              );
                            } else {
                              return Text(
                                '${movie['release_date']?.substring(0, 4) ?? 'Unknown'} ${snapshot.data} ${durationSnapshot.data}',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 10),
                              );
                            }
                          },
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}