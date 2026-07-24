class ClientHomeState {
  final int pageIndex;

  ClientHomeState({this.pageIndex = 0});

  ClientHomeState copyWith({int? pageIndex}) {
    return ClientHomeState(pageIndex: pageIndex ?? this.pageIndex);
  }

  @override
  List<Object> get props => [pageIndex];
}
