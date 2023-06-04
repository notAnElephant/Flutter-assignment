import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) {
      if (emailIsCorrect(event.email) && passwordIsCorrect(event.password)) {
        emit(LoginSuccess());
      } else {
        emit(LoginError("Invalid email or password"));
      }
    });
  }

  bool emailIsCorrect(String email) => true;

  bool passwordIsCorrect(String password) {
    return true;
  }
}
