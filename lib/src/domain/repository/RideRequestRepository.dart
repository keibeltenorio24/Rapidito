import 'package:rapidito/src/domain/models/RideRequest.dart';

abstract class RideRequestRepository {
  Future<String> createRideRequest(RideRequest rideRequest);
  Stream<List<RideRequest>> getActiveRideRequestsStream();
  Future<void> updateRideRequestStatus(String requestId, String status, String driverId);
  Stream<RideRequest?> getRideRequestStream(String requestId);
}
