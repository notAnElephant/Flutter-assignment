import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:flutter_homework/ui/bloc/login/TokenProvider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'list_event.dart';

part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>(
      (event, emit) async {
        emit(ListLoading());
        try {
          var response = await GetIt.I<Dio>().get(
            "/users",
            options: Options(
              headers: {
                'Authorization': 'Bearer ${GetIt.I<TokenProvider>().token}',
              },
            ),
          );
          final userList = response.data
              .map((item) => UserItem(item['name'], item['avatarUrl']))
              .cast<UserItem>()
              .toList();

          emit(ListLoaded(userList));
        } catch (e) {
          emit(ListError(
              e is DioError ? e.response!.data['message'] : e.toString()));
        }
      },
    );
  }
}
