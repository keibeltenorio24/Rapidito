import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterBloc.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterEvent.dart';
import 'package:rapidito/src/presentation/pages/authentication/register/bloc/RegisterState.dart';
import 'package:rapidito/src/presentation/utils/BlocFormItem.dart';
import 'package:rapidito/src/presentation/widgets/DefaultButton.dart';
import 'package:rapidito/src/presentation/widgets/DefaultTextField.dart';

// 1. Lo convertimos a StatefulWidget
class RegisterContent extends StatefulWidget {
  const RegisterContent({super.key});

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  // 2. Creamos la llave del formulario aquí
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // 3. Envolvemos la pantalla en un Form
    return Form(
      key: _formKey,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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

                  const Text(
                    'Registro',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                  const SizedBox(height: 20),

                  // Animación (fuera del BlocBuilder para que no se trabe)
                  Lottie.asset(
                    'assets/lottie/Sedan_animation.json',
                    height: 100,
                    repeat: true,
                  ),

                  // 4. BlocBuilder que envuelve SOLO los campos de texto
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          // input de nombre
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                NameChanged(name: BlocformItem(value: text)),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Ingrese el Nombre';
                              return null;
                            },
                            text: 'Nombre',
                            icon: Icons.person,
                            isPassword: false,
                            verticalPadding: 15,
                          ),
                          const SizedBox(height: 15),

                          // input de apellido
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                LastNameChanged(lastName: BlocformItem(value: text)),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Ingrese el Apellido';
                              return null;
                            },
                            text: 'Apellido',
                            icon: Icons.person_outline,
                            isPassword: false,
                            verticalPadding: 15,
                          ),
                          const SizedBox(height: 15),

                          // input de correo
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                EmailChanged(email: BlocformItem(value: text)),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese el Correo electrónico';
                              }
                              // 👇 Expresión regular que valida que tenga un '@' y un dominio válido
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
                            keyboardType: TextInputType
                                .emailAddress, // Muestra el teclado con el '@' a mano
                          ),
                          const SizedBox(height: 15),

                          // input de numero de telefono
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                PhoneChanged(phone: BlocformItem(value: text)),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ingrese el Número de teléfono';
                              }
                              if (value.length < 11) {
                                // Puedes cambiar el 10 según los números de tu país
                                return 'Número muy corto';
                              }

                              return null;
                            },
                            text: 'Número de teléfono',
                            icon: Icons.phone,
                            isPassword: false,
                            verticalPadding: 15,
                            // 👇 Le decimos que muestre el teclado numérico
                            keyboardType: TextInputType.phone,
                            // 👇 Y esto bloquea físicamente que puedan pegar o escribir letras
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                          ),
                          const SizedBox(height: 15),

                          // input de contraseña
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                PasswordChanged(
                                  password: BlocformItem(value: text),
                                ),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Ingrese la Contraseña';
                              if (value.length < 6)
                                return 'Mínimo 6 caracteres';
                              return null;
                            },
                            text: 'Contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                            verticalPadding: 15,
                          ),
                          const SizedBox(height: 15),

                          // input de confirmacion de contraseña
                          DefaultTextField(
                            onChanged: (text) {
                              context.read<RegisterBloc>().add(
                                ConfirmPasswordChanged(
                                  confirmPassword: BlocformItem(value: text),
                                ),
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Confirma la contraseña';
                              if (value.length < 6)
                                return 'Mínimo 6 caracteres';
                              // Aquí sí usamos el BLoC para comparar en tiempo real con la primera clave
                              if (value != state.password.value)
                                return 'Las contraseñas no coinciden';
                              return null;
                            },
                            text: 'Confirmar contraseña',
                            icon: Icons.lock,
                            isPassword: true,
                            verticalPadding: 15,
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 30),

                  // 🚀 Botón de Registrarse
                  DefaultButton(
                    onPressed: () {
                      // 5. Validamos con la llave local en lugar de la del estado
                      if (_formKey.currentState?.validate() ?? false) {
                        context.read<RegisterBloc>().add(FormSubmit());
                      }
                    },
                    text: 'Registrarse',
                    color: Colors.cyan,
                    textColor: Colors.white,
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          '¿Ya tienes una cuenta?',
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        TextButton(
                          onPressed: () {
                            // 6. Usamos POP para destruir esta pantalla y volver al Login
                            // Así evitamos apilar pantallas infinitamente
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Inicia sesión',
                            style: TextStyle(color: Colors.cyan, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
