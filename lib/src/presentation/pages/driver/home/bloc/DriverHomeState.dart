import 'package:equatable/equatable.dart';
import 'package:rapidito/src/domain/models/Role.dart';
import 'package:rapidito/src/domain/models/user.dart';

class DriverHomeState extends Equatable {
  final int pageIndex;
  final List<Role>? roles;
  final User? user;

  const DriverHomeState({this.pageIndex = 0, this.roles, this.user});

  DriverHomeState copyWith({int? pageIndex, List<Role>? roles, User? user}) {
    return DriverHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      roles: roles ?? this.roles,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [pageIndex, roles, user];
}
