class ModelStudent {
  int? id; // Nullable, as it may not be set when creating a new student
  final String name; // Non-nullable, must always be provided
  final String phoneNumber; // Non-nullable, must always be provided
  final String city; // Non-nullable, must always be provided

  ModelStudent({
    this.id,
    required this.name,
    required this.phoneNumber,
    required this.city,
  });

  // Convert a ModelStudent object into a Map object for database storage
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'name': name,
      'phoneNumber': phoneNumber,
      'city': city,
    };
    if (id != null) {
      map['id'] = id; // Include id only if it's not null
    }
    return map;
  }

  // Extract a ModelStudent object from a Map
  factory ModelStudent.fromMap(Map<String, dynamic> map) {
    return ModelStudent(
      id: map['id'] as int?, // Cast to int? for nullable id
      name: map['name'] as String, // Cast to String
      phoneNumber: map['phoneNumber'] as String, // Cast to String
      city: map['city'] as String, // Cast to String
    );
  }
}
