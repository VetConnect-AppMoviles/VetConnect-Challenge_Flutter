import 'package:flutter/material.dart';
import 'package:py_integrador_pokemon/ui/pokemon_list.dart';

void main() {
  runApp(MyPokemonApp());
}

class MyPokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pokémon App",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PokemonList(),
    );
  }
}