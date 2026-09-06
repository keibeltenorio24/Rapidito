import 'package:equatable/equatable.dart';

class DriverHomeState extends Equatable {
  final int pageIndex;

  const DriverHomeState({this.pageIndex = 0});

  DriverHomeState copyWith({int? pageIndex}) {
    return DriverHomeState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object> get props => [pageIndex];
}
