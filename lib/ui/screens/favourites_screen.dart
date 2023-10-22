import 'package:flutter/material.dart';

import 'package:pokemon_app/helpers/data.dart';
import 'package:pokemon_app/helpers/packages_export.dart';

class FavoritesScreen extends StatefulWidget {
  final List<dynamic> favoritePokemon;
  final List<String> images;

  const FavoritesScreen(this.favoritePokemon, this.images, {super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Set<String> favorites = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.amber,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Favourites',
          style: TextStyle(
            fontSize: 40,
            letterSpacing: 2,
            fontFamily: 'Pokemon',
            color: Colors.amber,
          ),
        ),
      ),
      body: GridView.builder(
        itemCount: widget.favoritePokemon.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4.0, mainAxisSpacing: 4.0),
        itemBuilder: (context, index) {
          final pokemon = widget.favoritePokemon[index];
          final pokemonName = pokemon['name'];
          final pokemonImage = widget.images[widget.favoritePokemon
              .indexWhere((element) => element['name'] == pokemonName)];

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
                    pokemonImage,
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
                        pokemonName,
                        style: GoogleFonts.pressStart2p(),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}
