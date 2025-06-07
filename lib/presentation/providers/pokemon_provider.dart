import 'package:flutter/foundation.dart';

class PokemonProvider with ChangeNotifier {
  final PokemonRepository _pokemonRepository;
  final FavoritesRepository _favoritesRepository;

  List<Pokemon> _pokemonList = [];
  bool _isLoading = false;
  String _errorMessage = '';

  PokemonProvider({
    required PokemonRepository pokemonRepository,
    required FavoritesRepository favoritesRepository,
  })  : _pokemonRepository = pokemonRepository,
        _favoritesRepository = favoritesRepository;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchPokemonList(int limit, int offset) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final pokemons = await _pokemonRepository.fetchPokemonList(limit, offset);
      _pokemonList = pokemons;
    } catch (e) {
      _errorMessage = 'Failed to load Pokémon: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMorePokemon(int limit, int offset) async {
    _isLoading = true;
    notifyListeners();

    try {
      final morePokemons = await _pokemonRepository.fetchPokemonList(limit, offset);
      _pokemonList.addAll(morePokemons);
    } catch (e) {
      _errorMessage = 'Failed to load more Pokémon: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchPokemon(String name) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final pokemon = await _pokemonRepository.searchPokemon(name.toLowerCase());
      _pokemonList = [pokemon];
    } catch (e) {
      _errorMessage = 'Pokémon not found';
      _pokemonList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Pokemon pokemon) async {
    try {
      final isFavorite = await _favoritesRepository.isFavorite(pokemon.id);
      if (isFavorite) {
        await _favoritesRepository.removeFavorite(pokemon.id);
      } else {
        await _favoritesRepository.addFavorite(pokemon);
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update favorites: ${e.toString()}';
      notifyListeners();
    }
  }
}