import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'movie_list_screen.dart';

class BrowseCategoryScreen extends StatefulWidget {
  static const String RouteName = 'BrowseCategoryScreen';

  @override
  _BrowseCategoryScreenState createState() => _BrowseCategoryScreenState();
}

class _BrowseCategoryScreenState extends State<BrowseCategoryScreen> {
  List<dynamic> categories = [];
  final String apiKey = '3393282c6b48f18ca19bcce45e903966';
  final String baseUrl = 'https://api.themoviedb.org/3';

  final Map<int, String> genreImages = {
    28: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZrU-t7pjIDooqpf1A57uqniKDPmslDpLCOQ&s',
    // Action
    12: 'https://i.pinimg.com/736x/6e/bd/fc/6ebdfc138e54d4247ee095f62a0621b6.jpg',
    // Adventure
    16: 'https://i0.wp.com/i.ebayimg.com/images/g/yoYAAOSwowBbUKVs/s-l1600.jpg?ssl=1',
    // Animation
    35: 'https://i.ebayimg.com/images/g/fL0AAOSw5mlj0BWu/s-l1200.jpg',
    // Comedy
    80: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZtWHItTnO07Jh_tZ8hbSAsyeaDteYiu7BBw&s',
    // Crime
    99: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQWarY7f0Jt1q-jUIIu1QXBVTB1RxfGMkQUKQ&s',
    // Documentary
    18: 'https://www.coffeeandcigarettes.co.uk/wp-content/uploads/2018/05/kp_0002_Kew_Painkillers_1sht_Art_4D_LO.jpg.jpg',
    // Drama
    10751:
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQn3Bi79fapoOHpRrzfdexSwweLWldyywVQWA&s',
    // Family
    14: 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/epic-fantasy-movie-poster-design-template-fc2d5f7708a1a49889ac1b54a1eb2143_screen.jpg?ts=1692349525',
    // Fantasy
    36: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSani1MKEbyj1HKvhfQ-vjnCjTw_79Pg2Hziw&s',
    // History
    27: 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/horror-movie-poster-design-template-0a593d6547564a095f6166f10de24a4b_screen.jpg?ts=1679656233',
    // Horror
    10402:
        'https://images.photowall.com/products/60011/sound-of-music-2.jpg?h=699&q=85',
    // Music
    9648:
        'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/adventure-movie-poster-template-design-7b13ea2ab6f64c1ec9e1bb473f345547_screen.jpg?ts=1636999411',
    // Mystery
    10749:
        'https://ik.imagekit.io/yfnz71p9w/wp-content/uploads/2022/05/TFIOS.jpg',
    // Romance
    878:
        'https://images.squarespace-cdn.com/content/v1/5a7f41ad8fd4d236a4ad76d0/1669842753281-3T90U1EY5HUNCG43XERJ/A2_Poster_DC_v80_PAYOFF_221029_12trimHD.jpg',
    // Science Fiction
    10770:
        'https://i5.walmartimages.com/seo/Poster-2023-Movie-Posters-Prints-Bedroom-Decor-for-Wall-Art-Print-Gift-Home-Decor-Unframe-Poster-12x18Inch-30x46cm_034e95b8-2c1b-4669-a0e7-d36756281473.8057a603ef554d85b10945fa108e93bd.jpeg',
    // TV Movie
    53: 'https://www.indiewire.com/wp-content/uploads/2017/07/fury-2014.jpg?w=674',
    // Thriller
    10752:
        'https://myhotposters.com/cdn/shop/products/mL3593_1024x1024.jpg?v=1571445732',
    // War
    37: 'https://images-cdn.ubuy.co.in/63ef0a397f1d781bea0a2464-star-wars-rogue-one-movie-poster.jpg'
    // Western
  };

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final url = '$baseUrl/genre/movie/list?api_key=$apiKey&language=en-US';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        categories = data['genres'];
      });
    } else {
      throw Exception('Failed to load categories');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Browse Category'),
        backgroundColor: Colors.black,
      ),
      body: categories.isEmpty
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 16 / 9,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final genreImage = genreImages[category['id']] ??
                    'https://via.placeholder.com/500'; // Fallback to a default image if no match

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieListScreen(
                          genreId: category['id'],
                          genreName: category['name'],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.grey[850],
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CachedNetworkImage(
                          imageUrl: genreImage,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                          fit: BoxFit.cover,
                        ),
                        Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Center(
                            child: Text(
                              category['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}