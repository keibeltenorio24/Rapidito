import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/presentation/pages/profile/update/ProfileUpdateContent.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateBloc.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateEvent.dart';
import 'package:rapidito/src/presentation/pages/profile/update/bloc/ProfileUpdateState.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  State<ProfileUpdatePage> createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  User? user;

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInit) {
      user = ModalRoute.of(context)?.settings.arguments as User?;
      if (user != null) {
        context.read<ProfileUpdateBloc>().add(ProfileUpdateInitEvent(user: user));
      }
      _isInit = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    user = ModalRoute.of(context)?.settings.arguments as User;
    return Scaffold(
      body: BlocListener<ProfileUpdateBloc, ProfileUpdateState>(
        listenWhen: (previous, current) =>
            previous.response != current.response,
        listener: (context, state) {
          final response = state.response;
          if (response is ErrorData) {
            Fluttertoast.showToast(
              msg: response.message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          } else if (response is Success) {
            Fluttertoast.showToast(
              msg: '¡Datos actualizados!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            Navigator.pop(context, response.data);
          }
        },
        child: BlocBuilder<ProfileUpdateBloc, ProfileUpdateState>(
          builder: (context, state) {
            final response = state.response;
            if (response is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return ProfileUpdateContent(user: user, state: state);
          },
        ),
      ),
    );
  }
}
