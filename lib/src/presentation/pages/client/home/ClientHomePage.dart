import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginBloc.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeBloc.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeEvent.dart';
import 'package:rapidito/src/presentation/pages/client/home/bloc/ClientHomeState.dart';
import 'package:rapidito/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:rapidito/src/presentation/pages/client/mapSeeker/ClientMapSeekerPage.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});

  @override
  State<ClientHomePage> createState() => ClientHomePageState();
}

class ClientHomePageState extends State<ClientHomePage> {
  bool _isMapReady = false;

  @override
  void initState() {
    super.initState();
    // Wait 1.5 seconds for route transition + native surface to be ready
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isMapReady = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapidito')),
      body: BlocBuilder<ClientHomeBloc, ClientHomeState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.pageIndex,
            children: [
              _isMapReady
                  ? ClientMapSeekerPage()
                  : const Center(child: CircularProgressIndicator()),
              const Center(child: Text("Historial de Viajes")),
              const ProfileInfoPage(),
            ],
          );
        },
      ),
      drawer: BlocBuilder<ClientHomeBloc, ClientHomeState>(
        builder: (context, state) {
          return Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.cyan, Color.fromARGB(255, 0, 150, 163)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Text(
                    'Menú',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.black87),
                  title: const Text(
                    'Perfil',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  selected: state.pageIndex == 2,
                  onTap: () {
                    context.read<ClientHomeBloc>().add(
                      ChangePageEvent(pageIndex: 2),
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.directions_car,
                    color: Colors.black87,
                  ),
                  title: const Text(
                    'Viajar',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  selected: state.pageIndex == 0,
                  onTap: () {
                    context.read<ClientHomeBloc>().add(
                      ChangePageEvent(pageIndex: 0),
                    );
                    Navigator.pop(context); // Cierra el Drawer
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history, color: Colors.black87),
                  title: const Text(
                    'Mis Viajes',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  selected: state.pageIndex == 1,
                  onTap: () {
                    context.read<ClientHomeBloc>().add(
                      ChangePageEvent(pageIndex: 1),
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black87),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    context.read<ClientHomeBloc>().add(ClientLogoutEvent());
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
