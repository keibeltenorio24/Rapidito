import 'package:equatable/equatable.dart';

abstract class DriverHomeEvent extends Equatable {
  const DriverHomeEvent();

  @override
  List<Object> get props => [];
}

class ChangeDriverPageEvent extends DriverHomeEvent {
  final int pageIndex;

  const ChangeDriverPageEvent({required this.pageIndex});

  @override
  List<Object> get props => [pageIndex];
}

class DriverLogoutEvent extends DriverHomeEvent {}
