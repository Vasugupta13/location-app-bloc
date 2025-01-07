import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/constants/enums.dart';
import 'package:parkin_assessment/src/presentation/screens/signup/bloc/signup_bloc.dart';
import 'package:parkin_assessment/src/utils/gradient_button.dart';
import 'package:parkin_assessment/src/utils/snackbars_and_toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  late SignupBloc signupBloc;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    signupBloc = BlocProvider.of<SignupBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  bool get isPopulated =>
      emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          nameController.text.isNotEmpty;

  void onSignup() {
    if (isPopulated) {
      signupBloc.add(SignupButtonPressed(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
      ));
    } else {
      SnackbarsAndToasts.showErrorToast("Please fill all the fields");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignupBloc, SignupState>(
      listener: (context, state) {
        if (state is SignupFailure) {
          SnackbarsAndToasts.showErrorSnackbar(context, state.error);
        }
      },
      child: BlocBuilder<SignupBloc, SignupState>(
        builder: (context, state) {
          bool isShowPassword = state is SignupShowPass && state.isShowPassword;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty ? 'Name cannot be empty' : null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty ? 'Email cannot be empty' : null;
                    },
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
                        ),
                        onPressed: () {
                          signupBloc.add(TogglePasswordVisibility());
                        },
                      ),
                    ),
                    obscureText: !isShowPassword,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return value!.isEmpty ? 'Password cannot be empty' : null;
                    },
                  ),
                  const SizedBox(height: 20),
                  state is SignupLoading
                      ? const CircularProgressIndicator(
                    color: COLOR_CONST.primaryColor,
                  )
                      : GradientButton(
                    title: 'Sign Up',
                    onTap: onSignup,
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