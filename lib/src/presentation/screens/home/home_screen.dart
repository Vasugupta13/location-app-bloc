import 'package:google_fonts/google_fonts.dart';
import 'package:parkin_assessment/src/configs/config.dart';
import 'package:parkin_assessment/src/constants/color_constant.dart';
import 'package:parkin_assessment/src/constants/image_constant.dart';
import 'package:parkin_assessment/src/data/repository/notification_repo.dart';
import 'package:parkin_assessment/src/data/repository/save_user_data_repo.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/auth_bloc.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/auth/auth_event.dart';
import 'package:parkin_assessment/src/presentation/common_blocs/connectivity/connectivity_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/home/bloc/save_data_bloc.dart';
import 'package:parkin_assessment/src/presentation/screens/home/widgets/location_tab_widget.dart';
import 'package:parkin_assessment/src/presentation/screens/home/widgets/save_data_tab_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    NotificationServices.getDeviceToken().then((value)=>print(value));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Row(
              children: [
                Hero(
                  tag: "APP_ICON",
                  child: Image.asset(
                    IMAGE_CONST.APP_LOGO,
                    height: SizeConfig.defaultSize * 5,
                  ),
                ),
                const Text(
                  " Location App",
                  style: TextStyle(
                    color: Colors.white,
                    letterSpacing: 1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            elevation: 10,
            shadowColor: COLOR_CONST.primaryLightColor.withOpacity(0.5),
            bottom: TabBar(
              labelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600,fontSize: 15),
              unselectedLabelStyle: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w500,fontSize: 14),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Location'),
                Tab(text: 'Save Data'),
              ],
            ),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: <Color>[
                      COLOR_CONST.primaryLightColor,
                      COLOR_CONST.primaryColor,
                    ]),
              ),
            ),
            actions: [
              GestureDetector(
                  onTap: () {
                    context.read<AuthBloc>().add(SignOutEvent());
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.logout_rounded,color: Colors.white,),
                  ))
            ],
          ),
          backgroundColor: COLOR_CONST.backgroundColor,
          body: BlocBuilder<ConnectivityBloc, ConnectivityState>(
            builder: (context, state) {
              if (state is ConnectivityFailure) {
                return Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      IMAGE_CONST.NO_INTERNET_PNG,
                      height: SizeConfig.screenHeight * 0.3,
                    ),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.05,
                    ),
                    const Text(
                      "No Internet Connection !",
                      style: TextStyle(
                          color: COLOR_CONST.secondaryColor, fontSize: 14),
                    )
                  ],
                ));
              } else {
                return TabBarView(
                  children: [
                    LocationTabWidget(),
                    SaveDataTabWidget(),
                  ],
                );
              }
            },
          ),
        ),
      );
  }
}
