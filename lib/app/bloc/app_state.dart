part of 'app_bloc.dart';

enum AppStatus {
  authenticated,
  unauthenticated,
}

final class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.themeMode = ThemeMode.system,
  });

  const AppState.authenticated(User user)
      : this._(status: AppStatus.unauthenticated, user: user);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final ThemeMode themeMode;

  AppState copyWith({
    AppStatus? status,
    User? user,
    ThemeMode? themeMode,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  List<Object> get props => [status, user, themeMode];
}
