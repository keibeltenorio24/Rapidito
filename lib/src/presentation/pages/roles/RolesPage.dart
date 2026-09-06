import 'package:flutter/material.dart';
import 'package:rapidito/src/domain/models/Role.dart';
import 'package:rapidito/src/presentation/pages/roles/RolesItem.dart';

class RolesPage extends StatefulWidget {
  final List<Role> roles;

  const RolesPage({Key? key, required this.roles}) : super(key: key);

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '¿Cómo quieres ingresar?',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: ListView(
          children: widget.roles.map((role) {
            return RolesItem(role: role);
          }).toList(),
        ),
      ),
    );
  }
}
