import 'package:parkin_assessment/src/configs/config.dart';
import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/presentation/screens/signup/widgets/signup_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'widgets/signup_form.dart';
import 'bloc/signup_bloc.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/bloc.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => SignupBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                SignupHeader(),
                SignupForm(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildLoginAccountText(context),
    );
  }
  _buildLoginAccountText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Already have an account ?',
            style: TextStyle(color: COLOR_CONST.textColor),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Text(
              'Login',
              style: TextStyle(color: COLOR_CONST.primaryLightColor,fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}