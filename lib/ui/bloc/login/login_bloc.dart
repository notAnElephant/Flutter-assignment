import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if (state is! LoginForm) return;
      emit(LoginLoading());
      Response? response;
      try {
        response = await GetIt.I<Dio>().post(
          "/login",
          data: {
            "email": event.email,
            "password": event.password,
          },
        );
        emit(LoginSuccess());
        if(event.rememberMe) {
          var prefs = await SharedPreferences.getInstance();
          prefs.setString('rememberMe', response.data['token']);
        }
        emit(LoginForm());
      } catch (e) {
        print("error message: ${response!.data['message']}");
        emit(LoginError(response.data['message']));
      }
      emit(LoginForm());
      // finally{
      //
      // }
    });

    on<LoginAutoLoginEvent>((event, emit) async {
      emit(LoginLoading());
      var prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token != null) {
        Response? response;
        try {
          response = await GetIt.I<Dio>().post(
            "/login",
            data: {
              "token": token,
            },
          );
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginError(response!.data['message']));
        }
      }
      emit(LoginForm());
    });
  }
}
