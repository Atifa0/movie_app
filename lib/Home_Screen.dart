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
  final String apiKey =
      '3393282c6b48f18ca19bcce45e903966'; // Replace with your TMDB API key
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
          featuredMovie = popularMovies[
              0]; // Set the first popular movie as the featured movie
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
      backgroundColor: Color(0xff121312), // Set the background color
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (featuredMovie != null)
              FeaturedMovieSection(movie: featuredMovie),
            SizedBox(height: 100),
            // Added to move the Popular Movies section down
            CategorySection(title: 'New Releases', movies: upcomingMovies),
            // Changed order here
            SizedBox(height: 20),
            CategorySection(title: 'Recommended', movies: topRatedMovies),
            // Changed order here
            SizedBox(height: 20),
            CategorySection(title: 'Popular Movies', movies: popularMovies),
            // Changed order here
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // To allow poster overflow
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
        // Play button in the center
        Center(
          child: Icon(
            Icons.play_circle_fill, // Example icon
            size: 80,
            color: Colors.white,
          ),
        ),
        // Small poster and text
        Positioned(
          left: 10,
          bottom: -70,
          // Position the bottom half of the poster on the background
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Increased small poster size
              Container(
                width: 150, // Increased width
                height: 220, // Increased height
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
              // Movie title and release year
              Padding(
                padding: const EdgeInsets.only(top: 150),
                // Adjusted to move the title down
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
                    Text(
                      '${movie['release_date']?.substring(0, 4) ?? 'Unknown'}',
                      // Display only the year
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16, // Slightly smaller font for release year
                      ),
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
      // Add some margin between categories
      decoration: BoxDecoration(
        color: Color(0xFF282A28), // Rectangle background color for the category
        borderRadius:
            BorderRadius.circular(10), // Rounded corners for the rectangle
      ),
      padding: EdgeInsets.all(10),
      // Padding inside the rectangle
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category title
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
            height: 250, // Adjusted height for the category section
            child: movies.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      return MovieCard(
                          movie: movies[index]); // Changed card size here
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
              // You can fetch runtime separately if required
              actors: [],
              // Fetch actors if needed
              genres: [], // Fetch genres if needed
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        // Decreased width of the card
        margin: EdgeInsets.symmetric(horizontal: 4),
        // Decrease horizontal margin
        decoration: BoxDecoration(
          color: Color(0xFF343534), // Card background color
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
                      height: 150, // Reduced height
                      width: double.infinity, // Fill the width
                      fit: BoxFit.cover, // Ensure the image covers the space
                    )
                  : Container(
                      height: 150, // Placeholder height
                      color: Colors.grey,
                      child: Icon(Icons.movie, color: Colors.white, size: 50),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie['title'] ?? 'No title',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, // Adjust font size
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        '${movie['vote_average']}',
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10), // Keep text color as white
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.star, color: Colors.yellow, size: 14),
                      // Yellow star icon
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${movie['release_date']?.substring(0, 4) ?? 'Unknown'}',
                    // Display only the year
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10), // Adjust font size
                  ),
                  Text(
                    'Runtime: ${movie['runtime'] ?? 'N/A'}',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 10), // Adjust font size
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
