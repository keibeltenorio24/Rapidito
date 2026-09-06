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
            height: 100,
            child: FadeInImage(
              placeholder: const AssetImage('assets/img/no-image.png'),
              image: NetworkImage(role.image),
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 50),
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset('assets/img/no-image.png');
              },
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
