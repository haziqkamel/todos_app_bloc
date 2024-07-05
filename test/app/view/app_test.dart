import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todos_app/app/bloc/app_bloc.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  group('AppBloc', () {
    late AuthenticationRepository authenticationRepository;
    late MockUser firebaseUser;
    late User user;

    setUp(() async {
      authenticationRepository = MockAuthenticationRepository();
      firebaseUser = MockUser(
        uid: 'someuid',
        email: 'bob@somedomain.com',
        displayName: 'Bob',
      );
      user = User(
        id: firebaseUser.uid,
        email: firebaseUser.email,
        name: firebaseUser.displayName,
      );

      // when(() => user.isNotEmpty).thenReturn(true);
      when(() => authenticationRepository.currentUser).thenReturn(user);
      when(() => authenticationRepository.user)
          .thenAnswer((_) => Stream.value(user));
    });

    blocTest<AppBloc, AppState>(
      'initializes with authenticated state when user is not empty',
      build: () => AppBloc(authenticationRepository: authenticationRepository),
      verify: (bloc) => expect(bloc.state, AppState.authenticated(user)),
    );

    blocTest<AppBloc, AppState>(
      'emits [AppState.authenticated] when user is not empty',
      build: () => AppBloc(authenticationRepository: authenticationRepository),
      expect: () => <AppState>[AppState.authenticated(user)],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppState.unauthenticated] when user is empty',
      setUp: () {
        when(() => authenticationRepository.currentUser).thenReturn(User.empty);
        when(() => authenticationRepository.user)
            .thenAnswer((_) => Stream.value(User.empty));
      },
      build: () => AppBloc(authenticationRepository: authenticationRepository),
      expect: () => <AppState>[const AppState.unauthenticated()],
    );

    blocTest<AppBloc, AppState>(
      'emits [AppState.unauthenticated] on AppLogOutRequested',
      skip: 1,
      setUp: () {
        when(() => authenticationRepository.logOut())
            .thenAnswer((_) => Future.value());
      },
      build: () => AppBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const AppLogOutRequested()),
      // ignore: inference_failure_on_collection_literal
      expect: () => [],
    );

    blocTest<AppBloc, AppState>(
      'emits new state with updated themeMode on AppThemeChanged event',
      build: () => AppBloc(authenticationRepository: authenticationRepository),
      act: (bloc) => bloc.add(const AppThemeChanged(ThemeMode.dark)),
      expect: () => [
        AppState.authenticated(user).copyWith(themeMode: ThemeMode.dark),
        AppState.authenticated(user).copyWith(themeMode: ThemeMode.system),
      ],
    );
  });
}
