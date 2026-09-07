import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/injection.dart';
import 'package:rapidito/src/domain/models/RideRequest.dart';
import 'package:rapidito/src/domain/useCases/geolocator/GeolocatorUseCases.dart';
import 'package:rapidito/src/domain/useCases/rides/RidesUseCases.dart';
import 'package:rapidito/src/presentation/pages/driver/receiveRequest/bloc/DriverReceiveRequestBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/receiveRequest/bloc/DriverReceiveRequestEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/receiveRequest/bloc/DriverReceiveRequestState.dart';
import 'package:rapidito/src/presentation/pages/driver/trip/DriverTripPage.dart';

class DriverReceiveRequestPage extends StatefulWidget {
  final RideRequest rideRequest;

  const DriverReceiveRequestPage({Key? key, required this.rideRequest})
    : super(key: key);

  @override
  State<DriverReceiveRequestPage> createState() =>
      _DriverReceiveRequestPageState();
}

class _DriverReceiveRequestPageState extends State<DriverReceiveRequestPage> {
  late DriverReceiveRequestBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DriverReceiveRequestBloc(
      geolocatorUseCases: locator<GeolocatorUseCases>(),
      ridesUseCases: locator<RidesUseCases>(),
    );
    _bloc.add(DriverReceiveRequestInitEvent(rideRequest: widget.rideRequest));
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: BlocListener<DriverReceiveRequestBloc, DriverReceiveRequestState>(
          listenWhen: (previous, current) =>
              previous.isAccepted != current.isAccepted,
          listener: (context, state) {
            if (state.isAccepted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      DriverTripPage(rideRequest: widget.rideRequest),
                ),
              );
            }
          },
          child: BlocBuilder<DriverReceiveRequestBloc, DriverReceiveRequestState>(
            builder: (context, state) {
              return Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    padding: const EdgeInsets.only(bottom: 350),
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
                            CameraUpdate.newLatLngBounds(
                              bounds,
                              100.0,
                            ), // Aumentado para no pegar la ruta a los bordes
                          );
                        });
                      }
                    },
                  ),
                  SafeArea(
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, left: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black),
                        onPressed: () => Navigator.pop(
                          context,
                        ), // Back to searching or previous screen
                      ),
                    ),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Origen',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        widget.rideRequest.originName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.flag, color: Colors.black87),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Destino',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        widget.rideRequest.destinationName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(Icons.timer, color: Colors.black87),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Tiempo y distancia',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${widget.rideRequest.durationText} - ${widget.rideRequest.distanceText}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const Divider(height: 20),
                            Row(
                              children: [
                                const Icon(
                                  Icons.attach_money,
                                  color: Colors.black87,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Precio aproximado del viaje',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '\$${widget.rideRequest.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: Colors.cyan,
                                ),
                                onPressed: state.isAccepting
                                    ? null
                                    : () {
                                        if (widget.rideRequest.id != null) {
                                          context
                                              .read<DriverReceiveRequestBloc>()
                                              .add(
                                                AcceptRideRequestEvent(
                                                  rideRequestId:
                                                      widget.rideRequest.id!,
                                                ),
                                              );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Error: No se encontró el ID del viaje.',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                child: state.isAccepting
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'ACEPTAR VIAJE',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
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
