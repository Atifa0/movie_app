import 'package:flutter/material.dart';
import 'package:movie_app/MovieDetails.dart';

class MoreLikeThisSection extends StatelessWidget {
  final List<dynamic> movies;

  MoreLikeThisSection({required this.movies});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: movies.map((movie) {
            final String posterPath = movie['poster_path'] ?? '';
            final String title = movie['title'] ?? '';
            final String releaseDate = movie['release_date'] ?? '';
            final double rating = movie['vote_average']?.toDouble() ?? 0.0;
            final int movieId = movie['id'] ?? 0;

            return Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
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
                        actors: [],
                        genres: [],
                      ),
                    ),
                  );
                },
                child: MovieCard(
                  title: title,
                  year: releaseDate.split('-').first,
                  rating: rating.toString(),
                  posterPath: posterPath,
                  runtime: 'N/A',
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
      width: 110,
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF282A28),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500$posterPath',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 18,
                ),
                SizedBox(width: 4),
                Text(
                  '$rating',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  year,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
                Text(
                  runtime,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
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
