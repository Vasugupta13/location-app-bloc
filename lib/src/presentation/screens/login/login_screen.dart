import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/login/bloc/bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/login/widgets/login_form.dart';
import 'package:parkin_assessment/src/presentation/screens/login/widgets/login_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../configs/config.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(authBloc: BlocProvider.of<AuthBloc>(context)),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: const SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                LoginHeader(),
                LoginForm(),
              ],
            ),
          ),
          bottomNavigationBar: _buildNoAccountText(context),
        ),
      ),
    );
  }

  _buildNoAccountText(context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(
            'Don\'t have an account ?',
            style: TextStyle(color: COLOR_CONST.textColor),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              AppRouter.SIGNUP,
            ),
            child: const Text(
              'Register',
              style: TextStyle(color: COLOR_CONST.primaryLightColor,fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
