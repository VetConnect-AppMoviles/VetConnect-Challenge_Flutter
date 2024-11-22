import 'package:flutter/material.dart';
import 'package:py_integrador_pokemon/utils/db_helper.dart';
import 'package:py_integrador_pokemon/utils/http_helper.dart';
import 'package:py_integrador_pokemon/models/Pokemon.dart';
import 'package:py_integrador_pokemon/ui/pokemon_detail.dart';

class PokemonList extends StatefulWidget {
  @override
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<Pokemon> pokemons = [];
  int page = 1;
  bool loading = true;
  late HttpHelper helper;
  ScrollController? _scrollController;

  Future initialize() async {
    if (helper != null) {
      List<Pokemon>? fetchedPokemons = await helper.getPokemons(page);
      setState(() {
        pokemons = fetchedPokemons!;
        loadMore();
        initScrollController();
      });
    }
  }

  @override
  void initState() {
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Pokedex",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black, // Set background color to black
      body: ListView.builder(
        controller: _scrollController,
        itemCount: pokemons.length,
        itemBuilder: (BuildContext context, int index) {
          return PokemonRow(pokemons[index]);
        },
      ),
    );
  }

  void loadMore() {
    helper.getPokemons(page).then((value) {
      setState(() {
        for (var pokemon in value) {
          if (!pokemons.any((p) => p.id == pokemon.id)) {
            pokemons.add(pokemon);
          }
        }
        page++;
      });

      if (pokemons.length % 20 > 0) {
        loading = false;
      }
    });
  }

  void initScrollController() {
    _scrollController = ScrollController();
    _scrollController!.addListener(() {
      if ((_scrollController!.position.pixels ==
              _scrollController!.position.maxScrollExtent) &&
          loading) {
        loadMore();
      }
    });
  }
}

class PokemonRow extends StatefulWidget {
  final Pokemon pokemon;
  PokemonRow(this.pokemon);

  @override
  State<PokemonRow> createState() => _PokemonRowState(pokemon);
}

class _PokemonRowState extends State<PokemonRow> {
  final Pokemon pokemon;
  _PokemonRowState(this.pokemon);

  bool? favorite;
  DbHelper? dbHelper;

  @override
  void initState() {
    favorite = false;
    dbHelper = DbHelper();
    isFavorite(pokemon);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.redAccent,
      elevation: 2,
      child: ListTile(
        leading: Hero(
          tag: 'pokemon_' + widget.pokemon.id.toString(),
          child: Image.network(widget.pokemon.imageUrl.toString()),
        ),
        title: Text(
          widget.pokemon.name.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    PokemonDetail(widget.pokemon)),
          ).then((value) {
            isFavorite(pokemon);
          });
        },
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: favorite! ? Colors.black : Colors.white,
          onPressed: () {
            favorite!
                ? dbHelper!.deletePokemon(pokemon)
                : dbHelper!.insertPokemon(pokemon);
            setState(() {
              favorite = !favorite!;
              pokemon.isFavorite = favorite;
            });
          },
        ),
      ),
    );
  }

  Future isFavorite(Pokemon pokemon) async {
    await dbHelper!.openDb();
    favorite = await dbHelper!.isFavorite(pokemon);
    setState(() {
      pokemon.isFavorite = favorite;
    });
  }
}
