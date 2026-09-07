import 'package:rapidito/src/domain/models/Role.dart';
import 'package:equatable/equatable.dart';

class ClientHomeState extends Equatable {
  final int pageIndex;
  final List<Role>? roles;

  ClientHomeState({this.pageIndex = 0, this.roles});

  ClientHomeState copyWith({int? pageIndex, List<Role>? roles}) {
    return ClientHomeState(
      pageIndex: pageIndex ?? this.pageIndex,
      roles: roles ?? this.roles,
    );
  }

  @override
  List<Object?> get props => [pageIndex, roles];
}
