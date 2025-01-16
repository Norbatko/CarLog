class Receipt {
  final String id;
  final String userId;
  final DateTime date;

  Receipt({
    this.id = '',
    required this.userId,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Receipt.fromMap(String id, Map<String, dynamic> data) {
    return Receipt(
      id: id,
      userId: data['userId'] ?? '',
      date: DateTime.tryParse(data['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'date': date.toIso8601String(),
    };
  }
}
