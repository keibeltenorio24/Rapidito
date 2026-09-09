import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeBloc.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeEvent.dart';
import 'package:rapidito/src/presentation/pages/driver/home/bloc/DriverHomeState.dart';
import 'package:rapidito/src/presentation/pages/profile/info/ProfileInfoPage.dart';
import 'package:rapidito/src/presentation/pages/history/TripHistoryPage.dart';
import 'package:rapidito/src/presentation/pages/driver/map/DriverMapPage.dart';

import 'package:rapidito/src/presentation/pages/roles/RolesPage.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  State<DriverHomePage> createState() => DriverHomePageState();
}

class DriverHomePageState extends State<DriverHomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DriverHomeBloc>().add(DriverHomeInitEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapidito Conductor')),
      body: BlocBuilder<DriverHomeBloc, DriverHomeState>(
        builder: (context, state) {
          return IndexedStack(
            index: state.pageIndex,
            children: [
              const DriverMapPage(),
              const TripHistoryPage(role: 'DRIVER'),
              const ProfileInfoPage(),
            ],
          );
        },
      ),
      drawer: BlocBuilder<DriverHomeBloc, DriverHomeState>(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Menú Conductor',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: 70,
                        height: 70,
                        child: ClipOval(
                          child:
                              (state.user?.image != null &&
                                  state.user!.image!.isNotEmpty)
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/img/user_image.png',
                                  image: state.user!.image!,
                                  fit: BoxFit.cover,
                                  fadeInDuration: const Duration(seconds: 1),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                        return Image.asset(
                                          'assets/img/user_image.png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                )
                              : Image.asset(
                                  'assets/img/user_image.png',
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ],
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
                    context.read<DriverHomeBloc>().add(
                      const ChangeDriverPageEvent(pageIndex: 2),
                    );
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.map, color: Colors.black87),
                  title: const Text(
                    'Mapa',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  selected: state.pageIndex == 0,
                  onTap: () {
                    context.read<DriverHomeBloc>().add(
                      const ChangeDriverPageEvent(pageIndex: 0),
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
                    context.read<DriverHomeBloc>().add(
                      const ChangeDriverPageEvent(pageIndex: 1),
                    );
                    Navigator.pop(context);
                  },
                ),
                if (state.roles != null && state.roles!.length > 1)
                  ListTile(
                    leading: const Icon(
                      Icons.swap_horiz,
                      color: Colors.black87,
                    ),
                    title: const Text(
                      'Cambiar de rol',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RolesPage(roles: state.roles!),
                        ),
                        (route) => false,
                      );
                    },
                  ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.black87),
                  title: const Text(
                    'Cerrar Sesión',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () {
                    context.read<DriverHomeBloc>().add(DriverLogoutEvent());
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
