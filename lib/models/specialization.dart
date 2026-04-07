class Specialization {
  final int id;
  final String name;
  final String? description;

  const Specialization({
    required this.id,
    required this.name,
    this.description,
  });

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['specialization_id'],
      name: json['name'],
      description: json['description'],
    );
  }
}