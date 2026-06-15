class ProtocolDocument {
  final int id;
  final String number;
  final DateTime adoptionDate;
  final DateTime? effectiveDate;
  final DateTime? expiryDate;
  final String title;
  final String? author;
  final String? signedBy;
  final DateTime? publicationDate;
  final String status;
  final int? techLevelId;
  final String? approving;
  final String? legalBasis;

  ProtocolDocument({
    required this.id,
    required this.number,
    required this.adoptionDate,
    this.effectiveDate,
    this.expiryDate,
    required this.title,
    this.author,
    this.signedBy,
    this.publicationDate,
    required this.status,
    this.techLevelId,
    this.approving,
    this.legalBasis,
  });

  factory ProtocolDocument.fromJson(Map<String, dynamic> json) {
    return ProtocolDocument(
      id: json['id'],
      number: json['number'],
      adoptionDate: DateTime.parse(json['adoption_date']),
      effectiveDate: json['effective_date'] != null
          ? DateTime.parse(json['effective_date'])
          : null,
      expiryDate: json['expiry_date'] != null
          ? DateTime.parse(json['expiry_date'])
          : null,
      title: json['title'],
      author: json['author'],
      signedBy: json['signed_by'],
      publicationDate: json['publication_date'] != null
          ? DateTime.parse(json['publication_date'])
          : null,
      status: json['status'],
      techLevelId: json['tech_level_id'],
      approving: json['approving'],
      legalBasis: json['legal_basis'],
    );
  }
}