import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';
import 'package:rapidito/src/presentation/widgets/DefaultIconBack.dart';
import 'package:rapidito/src/presentation/widgets/DefaultTextField.dart';
import 'package:rapidito/src/presentation/widgets/DefaultButton.dart';

class ProfileUpdateContent extends StatelessWidget {
  User? user;
  ProfileUpdateState? state;

  ProfileUpdateContent({this.state, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            _HeaderProfile(context),
            Column(
              children: [
                _cardUserInfo(context),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: DefaultButton(
                    text: 'ACTUALIZAR DATOS',
                    color: Colors.cyan,
                    textColor: Colors.white,
                    onPressed: () {
                      if (state?.formKey?.currentState?.validate() ?? false) {
                        context.read<ProfileUpdateBloc>().add(FormSubmit());
                      }
                    },
                  ),
                ),
                SizedBox(height: 40),
              ],
            ),
            DefaultIconBack(margin: EdgeInsets.only(top: 40, left: 15)),
          ],
        ),
      ),
    );
  }

  Widget _cardUserInfo(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 90),
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
        bottom: 20,
      ), // Add some bottom padding inside the container or card
      child: Card(
        color: Colors.white,
        shadowColor: const Color.fromARGB(140, 0, 0, 0),
        child: Form(
          key: state?.formKey,
          child: Column(
            children: [
              Container(
                width: 115,
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      ClipOval(
                        child: GestureDetector(
                          onTap: () {
                            _showImagePicker(context);
                          },
                          child: Container(
                            width: double.infinity,
                            height: double.infinity,
                            child: state?.image != null
                                ? Image.file(state!.image!, fit: BoxFit.cover)
                                : (user?.image != null &&
                                      user!.image!.isNotEmpty)
                                ? FadeInImage.assetNetwork(
                                    placeholder: 'assets/img/user_image.png',
                                    image: user!.image!,
                                    fit: BoxFit.cover,
                                    fadeInDuration: Duration(seconds: 1),
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
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            _showImagePicker(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.cyan,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DefaultTextField(
                  text: "Nombre",
                  icon: Icons.person,
                  onChanged: (text) {
                    context.read<ProfileUpdateBloc>().add(
                      NameChanged(name: BlocformItem(value: text)),
                    );
                  },
                  validator: (value) {
                    return state?.name.error;
                  },
                  initialValue: user?.name,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DefaultTextField(
                  text: "Apellido",
                  icon: Icons.person,
                  onChanged: (text) {
                    context.read<ProfileUpdateBloc>().add(
                      LastNameChanged(lastName: BlocformItem(value: text)),
                    );
                  },
                  validator: (value) {
                    return state?.lastname.error;
                  },
                  initialValue: user?.lastName,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: DefaultTextField(
                  text: "Telefono",
                  icon: Icons.phone,
                  onChanged: (text) {
                    context.read<ProfileUpdateBloc>().add(
                      PhoneChanged(phone: BlocformItem(value: text)),
                    );
                  },
                  validator: (value) {
                    return state?.phone.error;
                  },
                  initialValue: user?.phone,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _HeaderProfile(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(top: 50),
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

  void _showImagePicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Selecciona una opción'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galería'),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50,
                    maxWidth: 800,
                  );
                  if (image != null) {
                    context.read<ProfileUpdateBloc>().add(
                      UpdateImagePicked(image: File(image.path)),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Cámara'),
                onTap: () async {
                  Navigator.pop(dialogContext);
                  final ImagePicker picker = ImagePicker();
                  final XFile? image = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50,
                    maxWidth: 800,
                  );
                  if (image != null) {
                    context.read<ProfileUpdateBloc>().add(
                      UpdateImagePicked(image: File(image.path)),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
