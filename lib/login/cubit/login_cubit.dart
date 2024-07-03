import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';

/*
We used a Cubit instead of a Bloc here because the LoginState is fairly 
simple and localized. Even without events, 
we can still have a fairly good sense of what happened just by looking at 
the changes from one state to another and our code 
is a lot simpler and more concise.
 */

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._authenticationRepository) : super(const LoginState());

  final AuthenticationRepository _authenticationRepository;

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.password]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([state.email, password]),
      ),
    );
  }

  Future<void> signInWithCredentials() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signInWithEmailAndPassword(
        email: state.email.value,
        password: state.password.value,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithEmailAndPasswordFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      if (kDebugMode) log(e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _authenticationRepository.signInWithGoogle();
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } on SignInWithGoogleFailure catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
        ),
      );
      if (kDebugMode) log(e.toString());
    }
  }
}
