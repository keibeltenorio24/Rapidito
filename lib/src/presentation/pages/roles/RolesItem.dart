import 'package:flutter/material.dart';
import 'package:rapidito/src/domain/models/Role.dart';

class RolesItem extends StatelessWidget {
  final Role role;

  const RolesItem({Key? key, required this.role}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/${role.route}',
          (route) => false,
        );
      },
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 20, top: 15),
            height: 160,
            child: Image.asset(
              role.id == 'CLIENT'
                  ? 'assets/img/role_client.png'
                  : (role.id == 'DRIVER'
                        ? 'assets/img/role_driver.png'
                        : 'assets/img/no-image.png'),
              fit: BoxFit.contain,
            ),
          ),
          Text(
            role.name,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 25),
        ],
      ),
    );
  }
}
