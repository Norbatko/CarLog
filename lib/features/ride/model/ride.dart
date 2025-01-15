class Ride {
  String id;
  String userId;
  String userName;
  DateTime startedAt;
  DateTime finishedAt;
  String rideType;  // Enum: 'Business', 'Personal', 'Other'
  int distance;     // Distance in kilometers
  String locationStart;
  String locationEnd;

  Ride({
    this.id = '',
    required this.userId,
    this.userName = '',
    DateTime? startedAt,
    DateTime? finishedAt,
    this.rideType = '',
    this.distance = 0,
    this.locationStart = '',
    this.locationEnd = '',
  })  : startedAt = startedAt ?? DateTime.now(),
        finishedAt = finishedAt ?? DateTime.now();

  factory Ride.fromMap(String id, Map<String, dynamic> data) {
    return Ride(
      id: id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      startedAt: DateTime.tryParse(data['startedAt'] ?? '') ?? DateTime.now(),
      finishedAt: DateTime.tryParse(data['finishedAt'] ?? '') ?? DateTime.now(),
      rideType: data['rideType'] ?? '',
      distance: (data['distance'] ?? 0) as int,
      locationStart: data['locationStart'] ?? '',
      locationEnd: data['locationEnd'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'startedAt': startedAt.toIso8601String(),
      'finishedAt': finishedAt.toIso8601String(),
      'rideType': rideType,
      'distance': distance,
      'locationStart': locationStart,
      'locationEnd': locationEnd,
    };
  }
  Ride copyWith({
    String? id,
    String? userId,
    String? userName,
    DateTime? startedAt,
    DateTime? finishedAt,
    String? rideType,
    int? distance,
    String? locationStart,
    String? locationEnd,
  }) {
    return Ride(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      startedAt: startedAt ?? this.startedAt,
      finishedAt: finishedAt ?? this.finishedAt,
      rideType: rideType ?? this.rideType,
      distance: distance ?? this.distance,
      locationStart: locationStart ?? this.locationStart,
      locationEnd: locationEnd ?? this.locationEnd,
    );
  }
}