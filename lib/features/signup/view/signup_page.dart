import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todos_app/features/signup/cubit/signup_cubit.dart';
import 'package:todos_app/features/signup/view/signup_form.dart';
import 'package:todos_app/l10n/l10n.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute<void>(builder: (_) => const SignUpPage());

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.signupAppBarTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: const SignupForm(),
        ),
      ),
    );
  }
}
