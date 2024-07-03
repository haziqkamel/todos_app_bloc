import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_app/app/app.dart';
import 'package:todos_app/firebase_options.dart';
import 'package:todos_repository/todos_repository.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap({required LocalStorageTodosApi todosApi}) async {
  FlutterError.onError = (details) => log(
        details.exceptionAsString(),
        stackTrace: details.stack,
      );

  Bloc.observer = const AppBlocObserver();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (error) {
    log('Firebase.initializeApp() failed', error: error);
  }

  final authenticationRepository = AuthenticationRepository();
  final todosRepository = TodosRepository(todosApi: todosApi);

  // Initiate the User object
  await authenticationRepository.user.first;

  runApp(
    App(
      todosRepository: todosRepository,
      authenticationRepository: authenticationRepository,
    ),
  );
}
