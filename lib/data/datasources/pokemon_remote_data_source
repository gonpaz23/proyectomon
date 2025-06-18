import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectomon/data/models/pokemon_model.dart';

class PokemonRemoteDataSource {
  final http.Client client;
  static const baseUrl = 'https://pokeapi.co/api/v2';

  PokemonRemoteDataSource({required this.client});

  Future<List <Pokemon> > fetchPokemonList(int limit, int offset) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon?limit=$limit&offset=$offset'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      
      // Fetch details for each Pokémon in parallel
      final pokemons = await Future.wait(
        results.map((result) => fetchPokemonDetails(result['url'])),
      );
      
      return pokemons;
    } else {
      throw Exception('Failed to load Pokémon list');
    }
  }

  Future<Pokemon> fetchPokemonDetails(String url) async {
    final response = await client.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  Future<Pokemon> searchPokemon(String name) async {
    final response = await client.get(
      Uri.parse('$baseUrl/pokemon/$name'),
    );

    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Pokémon not found');
    }
  }
}