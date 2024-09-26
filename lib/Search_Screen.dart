import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/MovieDetails.dart';

class Search_Screen extends StatefulWidget {
  static const String RouteName = 'Search_Screen';

  @override
  _Search_ScreenState createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  final String _apiKey = '3393282c6b48f18ca19bcce45e903966';
  List<dynamic> _movies = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  Future<void> _searchMovies(String query) async {
    if (query.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    final url = Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=$_apiKey&query=${Uri.encodeQueryComponent(query)}');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _movies = data['results'];
          _isLoading = false;
        });
      } else {
        print('Error: ${response.statusCode}');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error occurred: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<String>> _fetchActors(int movieId) async {
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=$_apiKey&append_to_response=credits');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['credits']['cast'] != null
            ? (data['credits']['cast'] as List)
                .map<String>((actor) => actor['name'] as String)
                .take(3)
                .toList()
            : [];
      } else {
        print('Error fetching actors: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
    return [];
  }

  String _extractYear(String? releaseDate) {
    if (releaseDate == null || releaseDate.isEmpty) {
      return 'Unknown';
    }
    return releaseDate.split('-')[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff121312),
        elevation: 0,
        toolbarHeight: 35,
      ),
      body: Container(
        color: Color(0xff121312),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Color(0xff121312),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.search, color: Colors.white),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              onSubmitted: _searchMovies,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Search',
                                hintStyle: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _hasSearched && _movies.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                              Icon(Icons.local_movies,
                                  size: 100, color: Color(0xffB5B4B4)),
                              SizedBox(height: 20),
                              Text(
                      'No movies found',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                  ],
                ),
                        )
                      : ListView.builder(
                          itemCount: _movies.length,
                          itemBuilder: (context, index) {
                            final movie = _movies[index];
                            return Column(
                              children: [
                                ListTile(
                                  leading: Container(
                                    width: 140,
                                    height: 89,
                                    decoration: BoxDecoration(
                                      image: movie['poster_path'] != null
                                          ? DecorationImage(
                                              image: NetworkImage(
                                                  'https://image.tmdb.org/t/p/w92${movie['poster_path']}'),
                                              fit: BoxFit.fill,
                                            )
                                          : null,
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  title: Text(
                                    movie['title'],
                                    style: TextStyle(
                                        color: Color(0xffffffff), fontSize: 15),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie['release_date'] != null
                                            ? _extractYear(
                                                movie['release_date'])
                                            : 'Unknown year',
                                        style: TextStyle(
                                            color: Color(0xacffffff),
                                            fontSize: 13),
                                      ),
                                      FutureBuilder<List<String>>(
                                        future: _fetchActors(movie['id']),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Text(
                                              'Loading actors...',
                                              style: TextStyle(
                                                  color: Color(0xacffffff),
                                                  fontSize: 13),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                              'Error loading actors',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 13),
                                            );
                                          } else if (!snapshot.hasData ||
                                              snapshot.data!.isEmpty) {
                                            return Text(
                                              'No main actors available',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12),
                                            );
                                          }

                                          return Text(
                                  snapshot.data!.join(', '),
                                  style: TextStyle(
                                      color: Color(0xacffffff),
                                      fontSize: 13),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () async {
                          if (movie['id'] != null) {
                            final actors =
                            await _fetchActors(movie['id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MovieDetailScreen(
                                      movieId: movie['id'],
                                      title: movie['title'] ??
                                          'Unknown Title',
                                      overview: movie['overview'] ??
                                          'No overview available.',
                                      posterPath:
                                      movie['poster_path'] ?? '',
                                      releaseDate:
                                      movie['release_date'] != null
                                          ? _extractYear(
                                          movie['release_date'])
                                          : 'Unknown',
                                      rating: movie['vote_average'] !=
                                          null
                                          ? (movie['vote_average'] is int
                                          ? (movie['vote_average']
                                      as int)
                                          .toDouble()
                                          : (movie['vote_average']
                                      is double
                                          ? movie['vote_average']
                                      as double
                                          : 0.0))
                                          : 0.0,
                                      genres: [],
                                      runtime: '',
                                      actors: actors,
                                    ),
                              ),
                            );
                          }
                        },
                      ),
                      if (index < _movies.length - 1)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0),
                          child: Divider(
                            color: Color(0xff707070),
                            thickness: 1,
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
