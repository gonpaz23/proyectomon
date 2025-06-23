import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Añadir Pokémon a favoritos
  Future<void> addFavorite(Favorite favorite) async {
    await _firestore
        .collection('favorites')
        .doc('${favorite.userId}_${favorite.pokemonId}')
        .set(favorite.toMap());
  }

  // Eliminar Pokémon de favoritos
  Future<void> removeFavorite(String userId, int pokemonId) async {
    await _firestore
        .collection('favorites')
        .doc('${userId}_$pokemonId')
        .delete();
  }

  // Obtener todos los favoritos de un usuario
  Stream<List<Favorite>> getFavorites(String userId) {
    return _firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Favorite.fromMap(doc.data()))
            .toList());
  }

  // Verificar si un Pokémon es favorito
  Future<bool> isFavorite(String userId, int pokemonId) async {
    final doc = await _firestore
        .collection('favorites')
        .doc('${userId}_$pokemonId')
        .get();
    return doc.exists;
  }
}