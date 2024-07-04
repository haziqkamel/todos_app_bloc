import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:todos_app/features/signup/cubit/signup_cubit.dart';
import 'package:todos_app/l10n/l10n.dart';
import 'package:todos_app/shared/shared.dart';

class SignupForm extends StatelessWidget {
  const SignupForm({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Sign up failure')),
            );
        }
      },
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomInputTextField<SignUpCubit, SignUpState>(
                textFieldKey: const Key('signUpForm_emailInput_textField'),
                keyboardType: TextInputType.emailAddress,
                labelText: l10n.email,
                helperText: '',
                onChanged: (context, email) =>
                    context.read<SignUpCubit>().emailChanged(email),
                stateCondition: (state) => state,
                errorTextExtractor: (state) => state.email.displayError != null
                    ? l10n.invalid_email
                    : null,
              ),
              const SizedBox(height: 8),
              CustomInputTextField<SignUpCubit, SignUpState>(
                textFieldKey: const Key('signUpForm_passwordInput_textField'),
                labelText: l10n.password,
                helperText: '',
                isObsecureField: true,
                onChanged: (context, password) =>
                    context.read<SignUpCubit>().passwordChanged(password),
                stateCondition: (state) => state,
                errorTextExtractor: (state) =>
                    state.password.displayError != null
                        ? l10n.invalid_password
                        : null,
              ),
              const SizedBox(height: 8),
              CustomInputTextField<SignUpCubit, SignUpState>(
                textFieldKey:
                    const Key('signUpForm_confirmedPasswordInput_textField'),
                labelText: l10n.confirm_password,
                helperText: '',
                isObsecureField: true,
                onChanged: (context, confirmPassword) => context
                    .read<SignUpCubit>()
                    .confirmedPasswordChanged(confirmPassword),
                stateCondition: (state) => state,
                errorTextExtractor: (state) =>
                    state.confirmedPassword.displayError != null
                        ? l10n.password_not_match
                        : null,
              ),
              const SizedBox(height: 8),
              CustomFormButton<SignUpCubit, SignUpState>(
                buttonKey: const Key('signUpForm_continue_raisedButton'),
                buttonText: l10n.sign_up_button,
                buttonColor: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(30),
                isButtonEnabled: (state) => state.isValid,
                onButtonPressed: (context) =>
                    context.read<SignUpCubit>().signUpFormSubmitted(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
