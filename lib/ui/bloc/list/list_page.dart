import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/list/list_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/TokenProvider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network/user_item.dart';

class ListPageBloc extends StatefulWidget {
  const ListPageBloc({super.key});

  @override
  State<ListPageBloc> createState() => _ListPageBlocState();
}

class _ListPageBlocState extends State<ListPageBloc> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List page"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              GetIt.I<SharedPreferences>().clear();
              GetIt.I<TokenProvider>().token = "";
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: BlocConsumer<ListBloc, ListState>(
          listenWhen: (_, state) => state is ListError,
          listener: (context, state) {
            if (state is ListError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
          },
          buildWhen: (_, state) => state is ListLoaded || state is ListLoading || state is ListInitial,
          builder: (context, state) {
            switch (state.runtimeType) {
              case ListLoading:
                return const Center(
                  child: CircularProgressIndicator(),
                );
              case ListLoaded:
                return buildList(context, (state as ListLoaded).users);
              case ListInitial:
                context
                    .read<ListBloc>()
                    .add(ListLoadEvent());
                return const Center(
                  child: CircularProgressIndicator(),
                );
              default:
                throw Exception("Unknown state: $state");
            }
          }),
    );
  }

  Widget buildList(BuildContext context, List<UserItem> users) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: users.length, // Set the itemCount to the length of the users list
      itemBuilder: (context, index) {
        if (index >= users.length) {
          // Check if the index is out of bounds
          return Container(); // Return an empty container if index is invalid
        }

        var user = users[index];
        return SizedBox(
          height: 90,
          child: Row(
            children: [
              Image.network(user.avatarUrl, width: 90),
              Text(user.name),
            ],
          ),
        );
      },
    );
  }
}
