import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rapidito/src/presentation/pages/profile/info/ProfileInfoContent.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoBloc.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoEvent.dart';
import 'package:rapidito/src/presentation/pages/profile/info/bloc/ProfileInfoState.dart';

class ProfileInfoPage extends StatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  State<ProfileInfoPage> createState() => ProfileInfoPageState();
}

class ProfileInfoPageState extends State<ProfileInfoPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileInfoBloc>().add(GetUserInfo());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileInfoBloc, ProfileInfoState>(
        builder: (context, state) {
          return ProfileInfoContent(user: state.user);
        },
      ),
    );
  }
}
