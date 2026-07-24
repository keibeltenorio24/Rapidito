abstract class ClientHomeEvent {}

class ChangePageEvent extends ClientHomeEvent {
  final int pageIndex;

  ChangePageEvent({required this.pageIndex});
}

class ClientLogoutEvent extends ClientHomeEvent {}
