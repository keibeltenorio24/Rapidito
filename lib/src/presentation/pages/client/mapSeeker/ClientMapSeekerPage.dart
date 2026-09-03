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

  final TextEditingController _originController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();
  final FocusNode _originFocus = FocusNode();
  final FocusNode _destinationFocus = FocusNode();
  bool _isOriginActive = true;

  LatLng? _cameraPosition;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<ClientMapSeekerBloc>().add(ClientMapSeekerInitEvent());
      context.read<ClientMapSeekerBloc>().add(FindPosition());
    });

    _originFocus.addListener(() {
      if (_originFocus.hasFocus) {
        context.read<ClientMapSeekerBloc>().add(OnCancelRoute());
      }
    });

    _destinationFocus.addListener(() {
      if (_destinationFocus.hasFocus) {
        context.read<ClientMapSeekerBloc>().add(OnCancelRoute());
      }
    });
  }

  @override
  void dispose() {
    _originController.dispose();
    _destinationController.dispose();
    _originFocus.dispose();
    _destinationFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ClientMapSeekerBloc, ClientMapSeekerState>(
        listenWhen: (previous, current) =>
            (previous.placemarkName != current.placemarkName &&
            current.placemarkName != null),
        listener: (context, state) {
          if (state.placemarkName != null) {
            if (_isOriginActive) {
              _originController.text = state.placemarkName!;
            } else {
              _destinationController.text = state.placemarkName!;
            }
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
                  padding: EdgeInsets.only(
                    top: 130,
                    bottom: state.polylines.isNotEmpty ? 280 : 80,
                  ),
                  polylines: state.polylines.values.toSet(),
                  markers: state.polylines.isNotEmpty
                      ? {
                          if (state.marker != null) state.marker!,
                          if (state.destinationMarker != null)
                            state.destinationMarker!,
                        }
                      : {},
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
                  onCameraMove: (CameraPosition position) {
                    _cameraPosition = position.target;
                  },
                  onCameraIdle: () {
                    if (_cameraPosition != null) {
                      context.read<ClientMapSeekerBloc>().add(
                        OnMapMoved(
                          latitude: _cameraPosition!.latitude,
                          longitude: _cameraPosition!.longitude,
                          isOrigin: _isOriginActive,
                        ),
                      );
                    }
                  },
                ),
                if (state.polylines.isEmpty)
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 35.0),
                      child: Image.asset(
                        'assets/img/location_blue.png',
                        width: 40,
                        height: 40,
                      ),
                    ),
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
                                controller: _originController,
                                focusNode: _originFocus,
                                text: 'Lugar de origen',
                                icon: Icons.location_on,
                                backgroundColor: Colors.white,
                                hasBorders: false,
                                verticalPadding: 5,
                                onChanged: (text) {
                                  _isOriginActive = true;
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
                                controller: _destinationController,
                                focusNode: _destinationFocus,
                                text: 'Destino',
                                icon: Icons.flag,
                                backgroundColor: Colors.white,
                                hasBorders: false,
                                verticalPadding: 5,
                                onChanged: (text) {
                                  _isOriginActive = false;
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
                          elevation: 2,
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
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                leading: const Icon(
                                  Icons.location_on,
                                  color: Colors.black54,
                                ),
                                title: Text(
                                  prediction['description'] ?? '',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                onTap: () {
                                  // Update text field
                                  if (_isOriginActive) {
                                    _originController.text =
                                        prediction['description'] ?? '';
                                  } else {
                                    _destinationController.text =
                                        prediction['description'] ?? '';
                                  }
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
                if (state.originPosition != null &&
                    state.destinationPosition != null &&
                    state.polylines.isEmpty)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: SafeArea(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          context.read<ClientMapSeekerBloc>().add(
                            OnDrawRoute(
                              origin: state.originPosition!,
                              destination: state.destinationPosition!,
                            ),
                          );
                        },
                        child: const Text(
                          'Confirmar Viaje',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                if (state.polylines.isNotEmpty && state.distanceText != null)
                  Positioned(
                    bottom: 20,
                    left: 20,
                    right: 20,
                    child: SafeArea(
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
                              const Text(
                                'Detalles del Viaje',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.directions_car,
                                        color: Colors.blue,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        state.distanceText!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        color: Colors.orange,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        state.durationText!,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Estimado:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '\$${state.price}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
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
                                  onPressed: () {
                                    // Todo: Continuar a solicitar viaje
                                  },
                                  child: const Text(
                                    'Solicitar Viaje',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
