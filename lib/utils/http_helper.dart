import 'package:http/http.dart' as http;
import "package:py_integrador_pokemon/models/Pokemon.dart";
import 'dart:convert';
import 'dart:io';

class HttpHelper {
  final String urlBase = "https://pokeapi.co/api/v2/pokemon";
  final String urlPage = "?offset=";

  Future<List<Pokemon>> getPokemons(int page) async {
    final String url = urlBase + urlPage + (page * 20).toString();

    http.Response result = await http.get(Uri.parse(url));

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final pokemonsMap = jsonResponse['results'];

      List<Pokemon> pokemons = [];
      for (var pokemon in pokemonsMap) {
        final pokemonDetail = await http.get(Uri.parse(pokemon['url']));
        if (pokemonDetail.statusCode == HttpStatus.ok) {
          final pokemonJson = json.decode(pokemonDetail.body);
          pokemons.add(Pokemon.fromJson(pokemonJson));
        }
      }
      return pokemons;
    } else {
      print(result.body);
      return [];
    }
  }
}