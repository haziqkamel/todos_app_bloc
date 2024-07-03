part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppLogOutRequested extends AppEvent {
  const AppLogOutRequested();
}

final class _AppUserChanged extends AppEvent {
  const _AppUserChanged(this.user);

  final User user;
}
