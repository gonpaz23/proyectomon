import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/pokemon_model.dart';
import '../../presentation/providers/pokemon_provider.dart';
import '../../core/theme/pokemon_theme.dart';

class PokemonDetailsScreen extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonDetailsScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final typeColor = PokemonTheme.getTypeColor(pokemon.types.first);
    
    return Scaffold(
      backgroundColor: typeColor.withOpacity(0.2),
      appBar: AppBar(
        title: Text('#${pokemon.id.toString().padLeft(3, '0')} ${pokemon.name.toUpperCase()}'),
        backgroundColor: typeColor,
        elevation: 0,
        actions: [
          Consumer<PokemonProvider>(
            builder: (context, provider, child) {
              return FutureBuilder<bool>(
                future: provider.isFavorite(pokemon.id),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                    onPressed: () => provider.toggleFavorite(pokemon),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Imagen del Pokémon
            Container(
              padding: const EdgeInsets.all(20),
              child: Hero(
                tag: 'pokemon-${pokemon.id}',
                child: Image.network(
                  pokemon.imageUrl,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            
            // Tarjeta con información
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tipos
                    Row(
                      children: pokemon.types.map((type) {
                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: PokemonTheme.getTypeColor(type),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            type.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Descripción (simulada)
                    const Text(
                      'Pokémon de tipo básico con habilidades especiales. Puede evolucionar bajo ciertas condiciones.',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Estadísticas
                    const Text(
                      'ESTADÍSTICAS',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    ...pokemon.stats.entries.map((stat) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 120,
                              child: Text(
                                stat.key.toUpperCase(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: stat.value / 200,
                                backgroundColor: Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(typeColor),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              stat.value.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    
                    // Altura y Peso
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(
                          'Altura',
                          '${(pokemon.height * 0.1).toStringAsFixed(1)} m',
                          Icons.straighten,
                        ),
                        _buildDetailItem(
                          'Peso',
                          '${(pokemon.weight * 0.1).toStringAsFixed(1)} kg',
                          Icons.monitor_weight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Colors.grey),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
