class Group {
  final String id;
  final int maxMembers;
  List<String> memberIDs;

  Group({
    required this.id,
    required this.maxMembers,
    required this.memberIDs,
  });

  // Constructor de fábrica para crear una instancia de Group desde un mapa JSON.
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] as String,
      maxMembers: json['maxMembers'] as int,
      // La API devuelve un List<dynamic>, que se convierte a List<String>
      memberIDs: (json['memberIDs'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
    );
  }

  // Método para convertir una instancia de Group en un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'maxMembers': maxMembers,
      'memberIDs': memberIDs,
    };
  }
}