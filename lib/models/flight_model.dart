class Flight {
  final String id;
  final String airline;
  final String flightNumber;
  final String fromCity;
  final String fromCode;
  final String toCity;
  final String toCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final String travelClass;
  final int price;
  final int seatsAvailable;

  Flight({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.fromCity,
    required this.fromCode,
    required this.toCity,
    required this.toCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.travelClass,
    required this.price,
    required this.seatsAvailable,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      id: json['_id'] ?? '',
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      fromCity: json['fromCity'] ?? '',
      fromCode: json['fromCode'] ?? '',
      toCity: json['toCity'] ?? '',
      toCode: json['toCode'] ?? '',
      departureTime: json['departureTime'] ?? '',
      arrivalTime: json['arrivalTime'] ?? '',
      duration: json['duration'] ?? '',
      travelClass: json['travelClass'] ?? 'Economy Class',
      price: (json['price'] as num?)?.toInt() ?? 0,
      seatsAvailable: (json['seatsAvailable'] as num?)?.toInt() ?? 0,
    );
  }
}