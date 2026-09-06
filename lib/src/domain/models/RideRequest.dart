import 'package:google_maps_flutter/google_maps_flutter.dart';

class RideRequest {
  final String? id;
  final String? clientId;
  final String? driverId;
  final String originName;
  final String destinationName;
  final LatLng originPosition;
  final LatLng destinationPosition;
  final String distanceText;
  final String durationText;
  final double price;
  final List<LatLng> polylineCoordinates;
  final String status; // 'pending', 'accepted', 'completed', 'cancelled'

  RideRequest({
    this.id,
    this.clientId,
    this.driverId,
    required this.originName,
    required this.destinationName,
    required this.originPosition,
    required this.destinationPosition,
    required this.distanceText,
    required this.durationText,
    required this.price,
    required this.polylineCoordinates,
    this.status = 'pending',
  });

  Map<String, dynamic> toJson() {
    return {
      'clientId': clientId,
      'driverId': driverId,
      'originName': originName,
      'destinationName': destinationName,
      'originLat': originPosition.latitude,
      'originLng': originPosition.longitude,
      'destinationLat': destinationPosition.latitude,
      'destinationLng': destinationPosition.longitude,
      'distanceText': distanceText,
      'durationText': durationText,
      'price': price,
      'status': status,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
  }

  factory RideRequest.fromJson(Map<String, dynamic> json, String documentId) {
    return RideRequest(
      id: documentId,
      clientId: json['clientId'],
      driverId: json['driverId'],
      originName: json['originName'] ?? '',
      destinationName: json['destinationName'] ?? '',
      originPosition: LatLng(json['originLat'] ?? 0.0, json['originLng'] ?? 0.0),
      destinationPosition: LatLng(json['destinationLat'] ?? 0.0, json['destinationLng'] ?? 0.0),
      distanceText: json['distanceText'] ?? '',
      durationText: json['durationText'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      polylineCoordinates: [], // Usually we don't save full polyline in realtime DB to save space, we redraw it
    );
  }
}
