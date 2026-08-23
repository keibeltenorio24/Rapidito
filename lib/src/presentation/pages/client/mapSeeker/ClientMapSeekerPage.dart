import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerBloc.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerEvent.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/bloc/ClientMapSeekerState.dart';
import 'package:rapidito/src/presentation/widgets/DefaultTextField.dart';

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
            return Stack(
              children: [
                GoogleMap(
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
                ),
                Positioned(
                  top: 20, // Moved up
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Card(
                        elevation: 5,
                        margin: EdgeInsets.zero, // Remove bottom margin
                        shape: RoundedRectangleBorder(
                          borderRadius: state.placesPredictions.isNotEmpty
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                )
                              : BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DefaultTextField(
                                text: 'Lugar de origen',
                                icon: Icons.location_on,
                                backgroundColor: Colors.white,
                                verticalPadding: 10,
                                onChanged: (text) {
                                  context.read<ClientMapSeekerBloc>().add(
                                    OnSearchPlace(query: text),
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 1),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DefaultTextField(
                                text: 'Destino',
                                icon: Icons.flag,
                                backgroundColor: Colors.white,
                                verticalPadding: 10,
                                onChanged: (text) {
                                  context.read<ClientMapSeekerBloc>().add(
                                    OnSearchPlace(query: text),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.placesPredictions.isNotEmpty)
                        Card(
                          margin: EdgeInsets
                              .zero, // Remove top margin so it attaches to the input card
                          elevation: 5,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(0),
                            itemCount: state.placesPredictions.length,
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemBuilder: (context, index) {
                              final prediction = state.placesPredictions[index];
                              return ListTile(
                                leading: const Icon(
                                  Icons.location_city,
                                  color: Colors.black54,
                                ),
                                title: Text(
                                  prediction['description'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  context.read<ClientMapSeekerBloc>().add(
                                    OnSelectPlace(
                                      placeId: prediction['place_id'],
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                    ],
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
