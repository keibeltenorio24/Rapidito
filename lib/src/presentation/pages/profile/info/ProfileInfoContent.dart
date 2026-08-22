import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';

class ProfileInfoContent extends StatelessWidget {
  final User? user;
  const ProfileInfoContent({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            _HeaderProfile(context),
            Spacer(),
            _actionProfile('EDITAR PERFIL', Icons.edit, () async {
              final result = await Navigator.pushNamed(
                context,
                '/profile/update',
                arguments: user,
              );
              if (result != null) {
                context.read<ProfileInfoBloc>().add(GetUserInfo());
              }
            }),
            _actionProfile('CERRAR SESION', Icons.logout, () {}),
            SizedBox(height: 200),
          ],
        ),
        _cardUserInfo(context),
      ],
    );
  }

  Widget _cardUserInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 70),
      width: MediaQuery.sizeOf(context).width,
      height: 230,
      child: Card(
        color: Colors.white,
        shadowColor: const Color.fromARGB(140, 0, 0, 0),
        child: Column(
          children: [
            Container(
              width: 115,
              margin: EdgeInsets.only(top: 15, bottom: 15),
              child: AspectRatio(
                aspectRatio: 1,
                child: ClipOval(
                  child: user?.image != null
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/img/user_image.png',
                          image: user!.image!,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(seconds: 1),
                        )
                      : Container(),
                ),
              ),
            ),
            Text(
              '${user?.name} ${user?.lastName}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(user?.email ?? "", style: TextStyle(color: Colors.grey[800])),
            Text(user?.phone ?? "", style: TextStyle(color: Colors.grey[800])),
          ],
        ),
      ),
    );
  }

  Widget _actionProfile(String option, IconData icon, void Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20, top: 15),
        child: ListTile(
          title: Text(option, style: TextStyle(fontWeight: FontWeight.bold)),
          leading: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyan, Color.fromARGB(255, 0, 150, 163)],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),

              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
        ),
      ),
    );
  }

  Widget _HeaderProfile(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 30),
      height: MediaQuery.sizeOf(context).height * 0.25,
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.cyan, Color.fromARGB(255, 0, 150, 163)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Text(
        'MI PERFIL',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
