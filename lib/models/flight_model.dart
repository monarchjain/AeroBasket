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

class ConnectingItinerary {
  final List<Flight> legs;
  final int layoverMinutes;
  final String layoverCity;
  final int totalPrice;

  ConnectingItinerary({
    required this.legs,
    required this.layoverMinutes,
    required this.layoverCity,
    required this.totalPrice,
  });

  factory ConnectingItinerary.fromJson(Map<String, dynamic> json) {
    return ConnectingItinerary(
      legs: (json['legs'] as List).map((l) => Flight.fromJson(l)).toList(),
      layoverMinutes: (json['layoverMinutes'] as num?)?.toInt() ?? 0,
      layoverCity: json['layoverCity'] ?? '',
      totalPrice: (json['totalPrice'] as num?)?.toInt() ?? 0,
    );
  }

  String get layoverLabel {
    final h = layoverMinutes ~/ 60;
    final m = layoverMinutes % 60;
    if (h > 0 && m > 0) return '${h}h ${m}m layover in $layoverCity';
    if (h > 0) return '${h}h layover in $layoverCity';
    return '${m}m layover in $layoverCity';
  }
}