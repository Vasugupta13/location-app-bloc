import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/presentation/screens/login/bloc/bloc.dart';
import 'package:parkin_assessment/src/utils/gradient_button.dart';
import 'package:parkin_assessment/src/utils/snackbars_and_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late LoginBloc loginBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isShowPassword = false;

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      emailController.text.isNotEmpty && passwordController.text.isNotEmpty;

  void onLogin() {
    if (isPopulated) {
      loginBloc.add(LoginButtonPressed(
        email: emailController.text,
        password: passwordController.text,
      ));
    } else {
      Fluttertoast.showToast(msg: "Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailure) {
          SnackbarsAndToasts.showErrorSnackbar(
              context,
              state.error.contains("invalid-credential")
                  ? "Email/Password is wrong or account is not created"
                  : state.error);
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          bool isShowPassword = state is LoginShowPass && state.isShowPassword;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          isShowPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          loginBloc.add(TogglePasswordVisibility());
                        },
                      ),
                    ),
                    obscureText: isShowPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty ? 'Password cannot be empty' : null;
                    },
                  ),
                  const SizedBox(height: 60),
                  state is LoginLoading
                      ? const CircularProgressIndicator(
                          color: COLOR_CONST.primaryColor,
                        )
                      : GradientButton(
                          title: 'Login',
                          onTap: onLogin,
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
