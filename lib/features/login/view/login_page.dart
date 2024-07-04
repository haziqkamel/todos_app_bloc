import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/app/bloc/app_bloc.dart';
import 'package:todos_app/features/login/cubit/login_cubit.dart';
import 'package:todos_app/features/login/view/view.dart';
import 'package:todos_app/l10n/l10n.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Page<void> page() => const MaterialPage<void>(child: LoginPage());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.loginAppBarTitle),
        actions: [
          // Set current context to dark or light mode
          IconButton(
            icon: Icon(
              theme.brightness == Brightness.dark
                  ? Icons.sunny
                  : Icons.nightlight_round,
            ),
            onPressed: () {
              context.read<AppBloc>().add(
                    AppThemeChanged(
                      theme.brightness == Brightness.dark
                          ? ThemeMode.light
                          : ThemeMode.dark,
                    ),
                  );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          // Dependency Injection AuthenticationRepository into LoginCubit
          create: (_) => LoginCubit(context.read<AuthenticationRepository>()),
          child: const LoginForm(),
        ),
      ),
    );
  }
}
