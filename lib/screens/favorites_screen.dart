import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectomon/models/favorite_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../models/pokemon_model.dart';
import '../services/pokemon_api_service.dart';
import '../widgets/pokemon_card.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.getCurrentUser()?.uid ?? '';
    final firestoreService = Provider.of<FirestoreService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Favoritos'),
      ),
      body: StreamBuilder<List<Favorite>>(
        stream: firestoreService.getFavorites(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No tienes Pokémon favoritos aún'));
          }

          final favorites = snapshot.data!;

          return FutureBuilder<List<Pokemon>>(
            future: Provider.of<PokemonApiService>(context, listen: false)
                .fetchPokemonDetailsForFavorites(favorites),
            builder: (context, pokemonSnapshot) {
              if (pokemonSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!pokemonSnapshot.hasData) {
                return const Center(child: Text('Error al cargar favoritos'));
              }

              final pokemons = pokemonSnapshot.data!;

              return GridView.builder(
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: pokemons.length,
                itemBuilder: (context, index) {
                  return PokemonCard(pokemon: pokemons[index]);
                },
              );
            },
          );
        },
      ),
    );
  }
}