import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/injection.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/client/trip/bloc/ClientTripBloc.dart';
import 'package:rapidito/src/presentation/pages/client/trip/bloc/ClientTripEvent.dart';
import 'package:rapidito/src/presentation/pages/client/trip/bloc/ClientTripState.dart';

class ClientTripPage extends StatefulWidget {
  final RideRequest rideRequest;

  const ClientTripPage({Key? key, required this.rideRequest}) : super(key: key);

  @override
  State<ClientTripPage> createState() => _ClientTripPageState();
}

class _ClientTripPageState extends State<ClientTripPage> {
  late ClientTripBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ClientTripBloc(
      geolocatorUseCases: locator<GeolocatorUseCases>(),
      ridesUseCases: locator<RidesUseCases>(),
    );
    _bloc.add(ClientTripInitEvent(rideRequest: widget.rideRequest));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocListener<ClientTripBloc, ClientTripState>(
          listenWhen: (previous, current) =>
              previous.rideRequest?.status != current.rideRequest?.status,
          listener: (context, state) {
            if (state.rideRequest?.status == 'completed') {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('¡Viaje Finalizado!')),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                'client/home',
                (route) => false,
              );
            }
          },
          child: BlocBuilder<ClientTripBloc, ClientTripState>(
            builder: (context, state) {
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    padding: const EdgeInsets.only(bottom: 250),
                    polylines: state.polylines.values.toSet(),
                    markers: {
                      if (state.originMarker != null) state.originMarker!,
                      if (state.destinationMarker != null)
                        state.destinationMarker!,
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        widget.rideRequest.originPosition.latitude,
                        widget.rideRequest.originPosition.longitude,
                      ),
                      zoom: 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      if (state.controller != null &&
                          !state.controller!.isCompleted) {
                        state.controller!.complete(controller);
                      }

                      // Ajustar cámara
                      if (widget.rideRequest.polylineCoordinates.isNotEmpty) {
                        double minLat =
                            widget.rideRequest.originPosition.latitude;
                        double minLng =
                            widget.rideRequest.originPosition.longitude;
                        double maxLat =
                            widget.rideRequest.originPosition.latitude;
                        double maxLng =
                            widget.rideRequest.originPosition.longitude;

                        for (var point
                            in widget.rideRequest.polylineCoordinates) {
                          if (point.latitude < minLat) minLat = point.latitude;
                          if (point.latitude > maxLat) maxLat = point.latitude;
                          if (point.longitude < minLng)
                            minLng = point.longitude;
                          if (point.longitude > maxLng)
                            maxLng = point.longitude;
                        }

                        LatLngBounds bounds = LatLngBounds(
                          southwest: LatLng(minLat, minLng),
                          northeast: LatLng(maxLat, maxLng),
                        );

                        Future.delayed(const Duration(milliseconds: 300), () {
                          controller.animateCamera(
                            CameraUpdate.newLatLngBounds(bounds, 100.0),
                          );
                        });
                      }
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'El conductor está en camino',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const CircularProgressIndicator(color: Colors.cyan),
                            const SizedBox(height: 20),
                            const Text(
                              'Por favor, espera en el punto de encuentro.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
