import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/map/bloc/DriverMapState.dart';

import 'package:rapidito/src/presentation/pages/driver/receiveRequest/DriverReceiveRequestPage.dart';

class DriverMapPage extends StatefulWidget {
  const DriverMapPage({super.key});

  @override
  State<DriverMapPage> createState() => _DriverMapPageState();
}

class _DriverMapPageState extends State<DriverMapPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DriverMapBloc>().add(DriverMapInitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<DriverMapBloc, DriverMapState>(
        listenWhen: (previous, current) =>
            previous.newRideRequest != current.newRideRequest &&
            current.newRideRequest != null,
        listener: (context, state) {
          if (state.newRideRequest != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DriverReceiveRequestPage(
                  rideRequest: state.newRideRequest!,
                ),
              ),
            );
          }
        },
        child: BlocBuilder<DriverMapBloc, DriverMapState>(
          builder: (context, state) {
            if (state.position == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      state.position!.latitude,
                      state.position!.longitude,
                    ),
                    zoom: 16.0,
                  ),
                  markers: state.marker != null ? {state.marker!} : {},
                  onMapCreated: (GoogleMapController controller) {
                    if (state.controller != null &&
                        !state.controller!.isCompleted) {
                      state.controller!.complete(controller);
                    }
                  },
                ),

                // Botón de Conectarse/Desconectarse
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: SafeArea(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<DriverMapBloc>().add(ToggleConnectEvent());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: state.isActive
                            ? Colors.red
                            : Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 5,
                      ),
                      child: Text(
                        state.isActive ? 'DESCONECTARSE' : 'CONECTARSE',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
    );
  }
}
