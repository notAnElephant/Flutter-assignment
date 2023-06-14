import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'TokenProvider.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginForm()) {
    on<LoginSubmitEvent>((event, emit) async {
      if (state is! LoginForm) return;
      emit(LoginLoading());
      try {
        var response = await GetIt.I<Dio>().post(
          "/login",
          data: {
            "email": event.email,
            "password": event.password,
          },
        );
        emit(LoginSuccess());
        GetIt.I<TokenProvider>().token = response.data['token'];
        if (event.rememberMe) {
          GetIt.I<SharedPreferences>()
              .setString('token', response.data['token']);
        }
        emit(LoginForm());
      } catch (e) {
        emit(LoginError(
            e is DioError ? e.response!.data['message'] : e.toString()));
      }
      emit(LoginForm());
    });

    on<LoginAutoLoginEvent>((event, emit) async {
      //TODO ha ez is benne van, akkor elszáll az app
      return;
      emit(LoginLoading());
      var token = GetIt.I<SharedPreferences>().getString('token');
      if (token != null) {
        try {
          await GetIt.I<Dio>().post(
            "/login",
            data: {
              "token": token,
            },
          );
          emit(LoginSuccess());
        } catch (e) {
          emit(LoginError(
              e is DioError ? e.response!.data['message'] : e.toString()));
        }
      }
      emit(LoginForm());
    });
  }
}
