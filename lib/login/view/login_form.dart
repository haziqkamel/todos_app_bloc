import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todos_app/l10n/l10n.dart';
import 'package:todos_app/login/cubit/login_cubit.dart';
import 'package:todos_app/login/widgets/widgets.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? l10n.snackBarAuthenticationFailed,
                ),
              ),
            );
        }
      },
      child: const Align(
        alignment: Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_fix_normal),
            SizedBox(height: 16),
            EmailInput(),
            SizedBox(height: 8),
            PasswordInput(),
            SizedBox(height: 8),
            LoginButton(),
            SizedBox(height: 8),
            GoogleLoginButton(),
            SizedBox(height: 4),
            SignupButton(),
          ],
        ),
      ),
    );
  }
}
