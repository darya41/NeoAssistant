import 'dart:convert';

class Calculator {
  final int id;
  final String name;
  final String type;
  final String description;
  final Map<String, dynamic> config;
  final List<dynamic> possibleResults;

  Calculator({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.config,
    required this.possibleResults,
  });

  factory Calculator.fromJson(Map<String, dynamic> json) {
    return Calculator(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'] ?? '',
      config: json['config'] is String
          ? jsonDecode(json['config'])
          : json['config'] ?? {},
      possibleResults: json['possible_results'] is String
          ? jsonDecode(json['possible_results'])
          : json['possible_results'] ?? [],
    );
  }
}