import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/repository/RideRequestRepository.dart';

class FirebaseRideRequestRepositoryImpl implements RideRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'ride_requests';

  @override
  Future<String> createRideRequest(RideRequest rideRequest) async {
    try {
      final docRef = await _firestore
          .collection(collectionName)
          .add(rideRequest.toJson());
      return docRef.id;
    } catch (e) {
      throw Exception('Error creating ride request: $e');
    }
  }

  @override
  Stream<List<RideRequest>> getActiveRideRequestsStream() {
    return _firestore
        .collection(collectionName)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return RideRequest.fromJson(doc.data(), doc.id);
          }).toList();
        });
  }

  @override
  Future<void> updateRideRequestStatus(
    String requestId,
    String status,
    String driverId,
  ) async {
    try {
      await _firestore.collection(collectionName).doc(requestId).update({
        'status': status,
        'driverId': driverId,
      });
    } catch (e) {
      throw Exception('Error updating ride request status: $e');
    }
  }

  @override
  Stream<RideRequest?> getRideRequestStream(String requestId) {
    return _firestore.collection(collectionName).doc(requestId).snapshots().map(
      (snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          return RideRequest.fromJson(snapshot.data()!, snapshot.id);
        }
        return null;
      },
    );
  }
}
