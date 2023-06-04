import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_homework/network/user_item.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/User.dart';

part 'list_event.dart';
part 'list_state.dart';

class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc() : super(ListInitial()) {
    on<ListLoadEvent>(
      (event, emit) async {
       Response? response;
       emit(ListLoading());
        try {
          var prefs = await SharedPreferences.getInstance();
          var token = prefs.getString('token');
          //TODO not the proper way; token should be gotten as a parameter
          var response = await GetIt.I<Dio>().get(
            "/users",
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );
          //TODO cast resopnse like this: result.map(...).cast<UserItem>.toList()

        } catch (e) {
          emit(ListError(response!.data['message']));
        }
      },
    );
  }
}
