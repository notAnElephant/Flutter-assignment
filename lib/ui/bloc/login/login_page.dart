import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework/ui/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:validators/validators.dart';

import 'TokenProvider.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  bool rememberMe = false;
  String? errorMessageEmail;
  String? errorMessagePassword;
  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    context.read<LoginBloc>().add(LoginAutoLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: BlocConsumer<LoginBloc, LoginState>(
          listenWhen: (_, state) => state is LoginError || state is LoginSuccess,
          listener: (context, state) {
            if (state is LoginError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                ),
              );
            }
            else if (state is LoginSuccess) {
              Navigator.of(context).pushReplacementNamed('/list',
              arguments: GetIt.I<TokenProvider>().token);
            }
          },
          buildWhen: (_, state) => state is LoginForm,
          builder: (context, state) {
            if (state is LoginForm) {
              return buildLoginForm(context, state);
            }
            else {
              throw Exception("Unknown state: $state");
            }
          }),
    );
  }

  Widget buildLoginForm(BuildContext context, LoginState state) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "Email",
              errorText: errorMessageEmail,
            ),
            onChanged: (value) {
              setState(() {
                errorMessageEmail = null;
                email = value;
              });
            },
            enabled: state is LoginForm,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              labelText: "Password",
              errorText: errorMessagePassword,
            ),
            onChanged: (value) {
              setState(() {
                errorMessagePassword = null;
                password = value;
              });
            },
            enabled: state is LoginForm,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: (value) {
                  //TODO ez és a button tuti jó így a letiltás szempontjából?
                  if (state is LoginForm) {
                    rememberMeClicked(value);
                  }
                },
              ),
              const Text("Remember me"),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (state is LoginForm) {
              loginButtonPressed(context);
            }
          },
          child: const Text("Login"),
        )
      ],
    );
  }

  void rememberMeClicked(bool? value) {
    setState(() {
      rememberMe = value!;
    });
  }

  void loginButtonPressed(BuildContext context) {
    bool passwordValid = true, emailValid = true;
    if (!isLength(password, 6)) {
      setState(() {
        errorMessagePassword = "Password must be at least 6 characters long";
      });
      passwordValid = false;
    }
    if (!isEmail(email)) {
      setState(() {
        errorMessageEmail = "Email is not valid";
      });
      emailValid = false;
    }
    if (passwordValid && emailValid) {
      context
          .read<LoginBloc>()
          .add(LoginSubmitEvent(email, password, rememberMe));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
