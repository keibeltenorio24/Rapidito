import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/LoginContent.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginState.dart';
import 'package:rapidito/src/presentation/pages/roles/RolesPage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //hot reload: ctrl + s
  //hot restart: ctrl + shift + f5
  //full restart: ctrl + f5

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listenWhen: (previous, current) =>
            previous.response != current.response,
        listener: (context, state) {
          final response = state.response;
          if (response is ErrorData) {
            Fluttertoast.showToast(
              msg: (response as ErrorData).message,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0,
            );
          } else if (response is Success) {
            Fluttertoast.showToast(
              msg: '¡Inicio exitoso!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            final authResponse = response.data as AuthResponse;
            context.read<LoginBloc>().add(
              SaveUserSession(authResponse: authResponse),
            );
            
            if (authResponse.user.roles != null && authResponse.user.roles!.length > 1) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => RolesPage(roles: authResponse.user.roles!),
                ),
                (route) => false,
              );
            } else {
              final String route = authResponse.user.roles?.first.route ?? 'client/home';
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/$route',
                (route) => false,
              );
            }
          }
        },
        child: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, state) {
            final response = state.response;
            if (response is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            // Pasamos el state tal cual lo hace tu profesor
            return LoginContent(state: state);
          },
        ),
      ),
    );
  }
}
