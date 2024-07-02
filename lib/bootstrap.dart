import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:local_storage_todos_api/local_storage_todos_api.dart';
import 'package:todos_app/app/app.dart';
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

void bootstrap({required LocalStorageTodosApi todosApi}) {
  FlutterError.onError = (details) => log(
        details.exceptionAsString(),
        stackTrace: details.stack,
      );

  Bloc.observer = const AppBlocObserver();

  final todosRepository = TodosRepository(todosApi: todosApi);

  runZonedGuarded(
    () => runApp(App(todosRepository: todosRepository)),
    (error, stacktrace) => log(
      error.toString(),
      stackTrace: stacktrace,
    ),
  );
}
