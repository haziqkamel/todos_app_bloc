import 'package:flutter/widgets.dart';
import 'package:todos_app/app/bloc/app_bloc.dart';
import 'package:todos_app/features/home/view/view.dart';
import 'package:todos_app/features/login/view/view.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.authenticated:
      return [
        HomePage.page(),
      ];
    case AppStatus.unauthenticated:
      return [
        LoginPage.page(),
      ];
  }
}
