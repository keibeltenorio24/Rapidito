import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rapidito/src/domain/models/AuthResponse.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/RegisterContent.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterState.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<RegisterBloc, RegisterState>(
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
              msg: '¡Registro exitoso!',
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 14.0,
            );
            final authResponse = response.data as AuthResponse;
            context.read<RegisterBloc>().add(SaveUserSession(authResponse: authResponse));
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/client/home',
              (route) => false,
            );
          }
        },
        child: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, state) {
            final response = state.response;
            if (response is Loading) {
              return const Center(child: CircularProgressIndicator());
            }
            return const RegisterContent();
          },
        ),
      ),
    );
  }
}
