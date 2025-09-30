class Group {
  final String id;
  List<String> memberIDs;
  final int groupNumber;
  final String categoryID;

  Group({
    required this.id,
    required this.categoryID,
    required this.memberIDs,
    this.groupNumber = 0,
  });

  // Constructor de fábrica para crear una instancia de Group desde un mapa JSON.
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['_id'] as String,
      // La API devuelve un List<dynamic>, que se convierte a List<String>
      memberIDs: (json['memberIDs'] as List<dynamic>)
          .map((id) => id as String)
          .toList(),
      categoryID: json['categoryID'] as String,
    );
  }

  // Método para convertir una instancia de Group en un mapa JSON.
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'memberIDs': memberIDs,
      'categoryID': categoryID,
      'groupNumber': groupNumber,
    };
  }
}