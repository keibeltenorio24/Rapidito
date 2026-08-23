import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerState.dart';

class ClientMapSeekerPage extends StatefulWidget {
  ClientMapSeekerPage({Key? key}) : super(key: key);

  @override
  _ClientMapSeekerPageState createState() => _ClientMapSeekerPageState();
}

class _ClientMapSeekerPageState extends State<ClientMapSeekerPage> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ClientMapSeekerBloc>().add(ClientMapSeekerInitEvent());
      context.read<ClientMapSeekerBloc>().add(FindPosition());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ClientMapSeekerBloc, ClientMapSeekerState>(
        listenWhen: (previous, current) =>
            previous.position != current.position && current.position != null,
        listener: (context, state) {
          if (state.controller != null && state.controller!.isCompleted) {
            context.read<ClientMapSeekerBloc>().add(
              ChangeMapCameraPosition(
                latitude: state.position!.latitude,
                longitude: state.position!.longitude,
              ),
            );
          }
        },
        child: BlocBuilder<ClientMapSeekerBloc, ClientMapSeekerState>(
          builder: (context, state) {
            if (state.error != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.location_off, size: 60, color: Colors.red),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        state.error!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ClientMapSeekerBloc>().add(FindPosition());
                      },
                      child: const Text('Reintentar / Dar Permisos'),
                    ),
                  ],
                ),
              );
            }
            if (state.position == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return GoogleMap(
              mapType: MapType.normal,
              markers: state.marker != null ? {state.marker!} : {},
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  state.position!.latitude,
                  state.position!.longitude,
                ),
                zoom: 16,
              ),
              onMapCreated: (GoogleMapController controller) {
                if (state.controller != null &&
                    !state.controller!.isCompleted) {
                  state.controller!.complete(controller);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
