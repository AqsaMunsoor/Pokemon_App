import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:pokemon_app/helpers/files_exports.dart';
import 'package:pokemon_app/helpers/packages_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokemonsList = [];
  Set<String> favorites = Set();

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
    loadFavorites();
  }

  Future<void> fetchPokemonData() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        pokemonsList = data['results'];
      });
    } else {
      // Handle error
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites')?.toSet() ?? Set();
    });
  }

  Future<void> toggleFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favorites.contains(pokemonName)) {
        favorites.remove(pokemonName);
      } else {
        favorites.add(pokemonName);
      }
      prefs.setStringList('favorites', favorites.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: Image.asset(
          'assets/icon.png',
        ),
        title: Text(
          'Home',
          style: TextStyle(
            fontSize: 40,
            letterSpacing: 2,
            fontFamily: 'Pokemon',
            color: Colors.amber,
          ),
        ),
        actions: [
          BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoggedOutState) {
                Navigator.popUntil(context, (route) => route.isFirst);
                Navigator.pushReplacement(context,
                    CupertinoPageRoute(builder: (context) => LoginScreen()));
              }
            },
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  BlocProvider.of<AuthCubit>(context).logOut();
                },
                icon: const Icon(
                  Icons.logout_outlined,
                  color: Colors.amber,
                ),
              );
            },
          ),
        ],
      ),
      body: Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
          itemCount: pokemonsList.length,
          itemBuilder: (context, index) {
            final pokemon = pokemonsList[index];
            final pokemonName = pokemon['name'];
            final isFavorite = favorites.contains(pokemonName);
            return Stack(
              children: [
                Positioned(
                  top: 50,
                  right: 5,
                  left: 5,
                  bottom: 5,
                  child: Container(
                    width: 200,
                    height: 150,
                    decoration: BoxDecoration(
                      gradient: gradients[index],
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 70,
                  left: 35,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset(
                      images[index],
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    left: 5,
                    right: 5,
                    child: Container(
                      width: 200,
                      color: Colors.white10,
                      child: Center(
                        child: Text(
                          (pokemon['name']),
                          style: GoogleFonts.pressStart2p(),
                        ),
                      ),
                    )),
                Positioned(
                  top: 30,
                  right: 5,
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      toggleFavorite(pokemonName);
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          final favoritePokemon = pokemonsList
              .where((pokemon) => favorites.contains(pokemon['name']))
              .toList();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FavoritesScreen(favoritePokemon, images),
            ),
          );
        },
        child: const Icon(
          Icons.favorite,
          color: Colors.amber,
        ),
      ),
    );
  }
}
