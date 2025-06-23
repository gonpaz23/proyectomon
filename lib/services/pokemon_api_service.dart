import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectomon/models/favorite_model.dart';
import '../models/pokemon_model.dart';

class PokemonApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  Future<List<Pokemon>> fetchPokemons({int limit = 20, int offset = 0}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      
      List<Pokemon> pokemons = [];
      for (var result in results) {
        final pokemon = await fetchPokemonDetails(result['url']);
        pokemons.add(pokemon);
      }
      return pokemons;
    } else {
      throw Exception('Failed to load pokemons');
    }
  }

  Future<Pokemon> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pokemon.fromJson(data);
    } else {
      throw Exception('Failed to load pokemon details');
    }
  }

  Future<List<Pokemon>> searchPokemon(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/pokemon?limit=1000'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      
      final matches = results.where((pokemon) => 
          pokemon['name'].toString().toLowerCase().contains(query.toLowerCase()));
      
      List<Pokemon> pokemons = [];
      for (var match in matches) {
        final pokemon = await fetchPokemonDetails(match['url']);
        pokemons.add(pokemon);
      }
      return pokemons;
    } else {
      throw Exception('Failed to search pokemons');
    }
  }
  Future<List<Pokemon>> fetchPokemonDetailsForFavorites(List<Favorite> favorites) async {
  List<Pokemon> pokemons = [];
  for (var favorite in favorites) {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon/${favorite.pokemonId}'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        pokemons.add(Pokemon.fromJson(data));
      }
    } catch (e) {
      print('Error fetching pokemon ${favorite.pokemonId}: $e');
    }
  }
  return pokemons;
  }
}