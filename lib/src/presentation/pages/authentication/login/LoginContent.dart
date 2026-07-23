import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/login/bloc/LoginState.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/presentation/widgets/DefaultButton.dart';
import 'package:rapidito/src/presentation/widgets/DefaultTextField.dart';

// 1. Cambiamos a StatefulWidget
class LoginContent extends StatefulWidget {
  final LoginState state;

  const LoginContent({super.key, required this.state});

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  // 2. Creamos la llave del formulario aquí, en el estado de la vista
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey, // Asignamos la llave
      // NOTA: No ponemos el autovalidateMode general para que no se ponga todo rojo de golpe
      child: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                const Text(
                  'Bienvenido a Rapidito',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 33,
                    fontStyle: FontStyle.italic,
                    color: Color.fromARGB(255, 43, 203, 231),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Iniciar sesión',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),

                const SizedBox(height: 20),

                // 🚗 ¡Esta animación ya NO se va a trabar!
                Lottie.asset(
                  'assets/lottie/Sedan_animation.json',
                  height: 150,
                  repeat: true,
                ),

                const SizedBox(height: 20),

                // 3. El BlocBuilder AHORA solo envuelve los Inputs
                BlocBuilder<LoginBloc, LoginState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        DefaultTextField(
                          onChanged: (text) {
                            context.read<LoginBloc>().add(
                              EmailChanged(email: BlocformItem(value: text)),
                            );
                          },
                          // 👇 Validación en tiempo real y Regex para el Login
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese el Correo electrónico';
                            }
                            final emailRegExp = RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                            );
                            if (!emailRegExp.hasMatch(value)) {
                              return 'Ingrese un correo válido (ej: usuario@correo.com)';
                            }
                            return null;
                          },
                          text: 'Correo electrónico',
                          icon: Icons.email,
                          isPassword: false,
                          verticalPadding: 15,
                          // 👇 Teclado con el arroba a la mano
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 15),

                        DefaultTextField(
                          onChanged: (text) {
                            context.read<LoginBloc>().add(
                              PasswordChanged(
                                password: BlocformItem(value: text),
                              ),
                            );
                          },
                          // 👇 Validación de contraseña vacía
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Ingrese la Contraseña';
                            }
                            return null;
                          },
                          text: 'Contraseña',
                          icon: Icons.lock,
                          isPassword: true,
                          verticalPadding: 15,
                        ),
                      ],
                    );
                  },
                ), // Fin del BlocBuilder

                const SizedBox(height: 30),

                // 🚀 Botón de iniciar sesion
                DefaultButton(
                  onPressed: () {
                    // 4. Validamos visualmente antes de mandar el evento
                    if (_formKey.currentState?.validate() ?? false) {
                      context.read<LoginBloc>().add(FormSubmit());
                    }
                  },
                  text: 'Iniciar sesión',
                  color: Colors.cyan,
                  textColor: Colors.white,
                ),

                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '¿No tienes una cuenta?',
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      TextButton(
                        onPressed: () {
                          // 5. Al regresar del registro, limpiamos todo
                          Navigator.pushNamed(context, '/register').then((_) {
                            _formKey.currentState?.reset();
                            // Recuerda que debes tener creado ResetLoginForm() en tus eventos
                            context.read<LoginBloc>().add(ResetLoginForm());
                          });
                        },
                        child: const Text(
                          'Regístrate',
                          style: TextStyle(color: Colors.cyan, fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
