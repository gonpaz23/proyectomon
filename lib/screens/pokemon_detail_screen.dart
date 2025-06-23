import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyectomon/models/favorite_model.dart';
import '../models/pokemon_model.dart';
import '../services/firestore_service.dart';
import '../services/auth_service.dart';
import '../widgets/stats_bar.dart';

class PokemonDetailScreen extends StatelessWidget {
  const PokemonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemon = ModalRoute.of(context)!.settings.arguments as Pokemon;
    final firestoreService = Provider.of<FirestoreService>(context);
    final authService = Provider.of<AuthService>(context);
    final userId = authService.getCurrentUser()?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name[0].toUpperCase() + pokemon.name.substring(1)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: _getTypeColor(pokemon.types[0]).withOpacity(0.2),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Hero(
                    tag: 'pokemon-${pokemon.id}',
                    child: Image.network(
                      pokemon.imageUrl,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: pokemon.types
                        .map((type) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: _getTypeColor(type),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '#${pokemon.id.toString().padLeft(3, '0')}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<bool>(
                        stream: firestoreService
                            .isFavorite(userId, pokemon.id)
                            .asStream(),
                        builder: (context, snapshot) {
                          final isFavorite = snapshot.data ?? false;
                          return IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : null,
                              size: 30,
                            ),
                            onPressed: () async {
                              if (isFavorite) {
                                await firestoreService.removeFavorite(
                                    userId, pokemon.id);
                              } else {
                                await firestoreService.addFavorite(Favorite(
                                  userId: userId,
                                  pokemonId: pokemon.id,
                                  pokemonName: pokemon.name,
                                  pokemonImage: pokemon.imageUrl,
                                ));
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Estadísticas',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  StatsBar(
                    label: 'HP',
                    value: pokemon.stats['hp'] ?? 0,
                    maxValue: 255,
                    color: Colors.green,
                  ),
                  StatsBar(
                    label: 'Ataque',
                    value: pokemon.stats['attack'] ?? 0,
                    maxValue: 255,
                    color: Colors.red,
                  ),
                  StatsBar(
                    label: 'Defensa',
                    value: pokemon.stats['defense'] ?? 0,
                    maxValue: 255,
                    color: Colors.blue,
                  ),
                  StatsBar(
                    label: 'Ataque Especial',
                    value: pokemon.stats['special-attack'] ?? 0,
                    maxValue: 255,
                    color: Colors.purple,
                  ),
                  StatsBar(
                    label: 'Defensa Especial',
                    value: pokemon.stats['special-defense'] ?? 0,
                    maxValue: 255,
                    color: Colors.blueAccent,
                  ),
                  StatsBar(
                    label: 'Velocidad',
                    value: pokemon.stats['speed'] ?? 0,
                    maxValue: 255,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Información',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Altura: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${pokemon.height / 10} m'),
                      const SizedBox(width: 16),
                      const Text('Peso: ',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${pokemon.weight / 10} kg'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Habilidades:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: pokemon.abilities
                        .map((ability) => Chip(
                              label: Text(ability),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'normal':
        return const Color(0xFFA8A878);
      case 'fire':
        return const Color(0xFFF08030);
      case 'water':
        return const Color(0xFF6890F0);
      case 'electric':
        return const Color(0xFFF8D030);
      case 'grass':
        return const Color(0xFF78C850);
      case 'ice':
        return const Color(0xFF98D8D8);
      case 'fighting':
        return const Color(0xFFC03028);
      case 'poison':
        return const Color(0xFFA040A0);
      case 'ground':
        return const Color(0xFFE0C068);
      case 'flying':
        return const Color(0xFFA890F0);
      case 'psychic':
        return const Color(0xFFF85888);
      case 'bug':
        return const Color(0xFFA8B820);
      case 'rock':
        return const Color(0xFFB8A038);
      case 'ghost':
        return const Color(0xFF705898);
      case 'dragon':
        return const Color(0xFF7038F8);
      case 'dark':
        return const Color(0xFF705848);
      case 'steel':
        return const Color(0xFFB8B8D0);
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return const Color(0xFF68A090);
    }
  }
}