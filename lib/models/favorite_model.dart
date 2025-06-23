class Favorite {
  final String userId;
  final int pokemonId;
  final String pokemonName;
  final String pokemonImage;

  Favorite({
    required this.userId,
    required this.pokemonId,
    required this.pokemonName,
    required this.pokemonImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'pokemonId': pokemonId,
      'pokemonName': pokemonName,
      'pokemonImage': pokemonImage,
    };
  }

  factory Favorite.fromMap(Map<String, dynamic> map) {
    return Favorite(
      userId: map['userId'],
      pokemonId: map['pokemonId'],
      pokemonName: map['pokemonName'],
      pokemonImage: map['pokemonImage'],
    );
  }
}