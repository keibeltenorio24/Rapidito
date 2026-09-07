import 'package:equatable/equatable.dart';
import 'package:rapidito/src/domain/models/Role.dart';

class DriverHomeState extends Equatable {
  final int pageIndex;
  final List<Role>? roles;

  const DriverHomeState({this.pageIndex = 0, this.roles});

  DriverHomeState copyWith({int? pageIndex, List<Role>? roles}) {
    return DriverHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      roles: roles ?? this.roles,
    );
  }

  @override
  List<Object?> get props => [pageIndex, roles];
}