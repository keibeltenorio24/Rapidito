import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';

class ClientSearchingDriverPage extends StatefulWidget {
  final RideRequest rideRequest;
  final String rideRequestId;

  const ClientSearchingDriverPage({
    Key? key,
    required this.rideRequest,
    required this.rideRequestId,
  }) : super(key: key);

  @override
  State<ClientSearchingDriverPage> createState() =>
      _ClientSearchingDriverPageState();
}

class _ClientSearchingDriverPageState extends State<ClientSearchingDriverPage> {
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    // Escuchar cambios en la solicitud de viaje en Firestore
    _subscription = FirebaseFirestore.instance
        .collection('ride_requests')
        .doc(widget.rideRequestId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final status = data['status'];

        if (status == 'accepted') {
          // El conductor aceptó el viaje
          _subscription?.cancel();
          if (mounted) {
            // Mostrar diálogo y luego ir a otra pantalla o volver al mapa
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                title: const Text('¡Viaje Aceptado!'),
                content: const Text('Un conductor va en camino.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar dialogo
                      Navigator.pop(context); // Volver al mapa (temporalmente hasta tener la pantalla de viaje del cliente)
                    },
                    child: const Text('OK'),
                  )
                ],
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.translate(
                    offset: const Offset(-15, 0),
                    child: Lottie.asset(
                      'assets/lottie/Sedan_animation.json',
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Buscando al conductor más cercano...',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.redAccent,
                    ),
                    onPressed: () {
                      // Opcional: Cambiar estado a cancelado en Firestore antes de salir
                      FirebaseFirestore.instance
                          .collection('ride_requests')
                          .doc(widget.rideRequestId)
                          .update({'status': 'cancelled'});
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancelar Solicitud',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
