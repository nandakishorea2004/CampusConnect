

import 'package:campus/data_model/user_model/UserListModel.dart';
import 'package:flutter/material.dart';
import '../app_ui/app_auth/splash_screen.dart';
import '../app_ui/user/user_details_screen.dart';
import '../app_ui/user/user_list_screen.dart';



class Routes{

  static final Map<String, Widget Function(BuildContext)> a = {
    '/': (context) => const SplashScreen(),
    '/userList':(context)=> const UserListScreen(),
    '/userDetails':(context)=> UserDetailsScreen(userDetails:  ModalRoute.of(context)!.settings.arguments  as UserListModel)

  };

}