import 'package:flutter/material.dart';
import 'package:movie_app/MovieDetails.dart';

class MoreLikeThisSection extends StatelessWidget {
  final List<dynamic> movies;

  MoreLikeThisSection({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0), // Added padding for better spacing
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: movies.map((movie) {
            final String posterPath = movie['poster_path'] ?? '';
            final String title = movie['title'] ?? '';
            final String releaseDate = movie['release_date'] ?? '';
            final double rating = movie['vote_average']?.toDouble() ?? 0.0;
            final int movieId = movie['id'] ?? 0; // Get the movie ID

            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  // Navigate to the Movie Detail Screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailScreen(
                        movieId: movieId,
                        title: title,
                        overview: movie['overview'] ?? '',
                        posterPath: posterPath,
                        releaseDate: releaseDate,
                        rating: rating,
                        runtime: 'N/A',
                        // Pass 'N/A' for runtime
                        actors: [],
                        genres: [], // Pass an empty list for actors
                      ),
                    ),
                  );
                },
                child: MovieCard(
                  title: title,
                  year: releaseDate.split('-').first,
                  rating: rating.toString(),
                  posterPath: posterPath,
                  runtime: 'N/A', // Placeholder for runtime
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String year;
  final String rating;
  final String posterPath;
  final String runtime;

  MovieCard({
    required this.title,
    required this.year,
    required this.rating,
    required this.posterPath,
    required this.runtime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, // Reduced width for smaller cards
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF282A28), // Background color for the whole card
        borderRadius: BorderRadius.circular(12), // Curved border
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(2, 3), // Shadow position
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Movie Poster with curved corners
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500$posterPath',
              height: 150, // Adjusted height for smaller cards
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 6),
          // Movie Rating with yellow star
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow, // Yellow color for the star
                  size: 18, // Size of the star
                ),
                SizedBox(width: 4), // Space between star and rating
                Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text for contrast
                  ),
                ),
              ],
            ),
          ),
          // Movie Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white, // White text for contrast
              ),
              overflow: TextOverflow.ellipsis, // Handle long titles
            ),
          ),
          SizedBox(height: 4),
          // Release Year and Duration in the same line
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  year,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white, // White text for contrast
                  ),
                ),
                Text(
                  runtime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white, // White text for contrast
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 6),
        ],
      ),
    );
  }
}
