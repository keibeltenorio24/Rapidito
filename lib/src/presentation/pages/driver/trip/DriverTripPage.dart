import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/injection.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/useCases/auth/AuthUseCases.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/bloc/DriverTripBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/bloc/DriverTripEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/bloc/DriverTripState.dart';

class DriverTripPage extends StatefulWidget {
  final RideRequest rideRequest;

  const DriverTripPage({Key? key, required this.rideRequest}) : super(key: key);

  @override
  State<DriverTripPage> createState() => _DriverTripPageState();
}

class _DriverTripPageState extends State<DriverTripPage> {
  late DriverTripBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DriverTripBloc(
      geolocatorUseCases: locator<GeolocatorUseCases>(),
      ridesUseCases: locator<RidesUseCases>(),
      authUseCases: locator<AuthUseCases>(),
    );
    _bloc.add(DriverTripInitEvent(rideRequest: widget.rideRequest));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocListener<DriverTripBloc, DriverTripState>(
          listenWhen: (previous, current) =>
              previous.isCompleted != current.isCompleted,
          listener: (context, state) {
            if (state.isCompleted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('¡Viaje Finalizado Correctamente!'),
                ),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                'driver/home',
                (route) => false,
              );
            }
          },
          child: BlocBuilder<DriverTripBloc, DriverTripState>(
            builder: (context, state) {
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    padding: const EdgeInsets.only(bottom: 120),
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
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: state.isCompleting
                            ? null
                            : () {
                                _bloc.add(FinishTripEvent());
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.cyan,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: state.isCompleting
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'FINALIZAR VIAJE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
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
