// ignore_for_file: no_logic_in_create_state, must_be_immutable

import 'package:campus/data_model/user_model/UserListModel.dart';
import 'package:campus/styles/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../../styles/widget_style.dart';

class UserDetailsScreen extends StatefulWidget{

  UserListModel userDetails;

   UserDetailsScreen({super.key,required this.userDetails});


  @override
  UserDetailsUI createState()=> UserDetailsUI(userDetails);
}
class UserDetailsUI extends State<UserDetailsScreen>{
  UserListModel userDetails;
  UserDetailsUI(this.userDetails);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back_ios,color: AppColors.primaryColor,)),
        title: Text(userDetails.name!),
      ),


      body: SingleChildScrollView(
        padding: EdgeInsets.all(5),
        child: Column(children: [
          const SizedBox(height: 10,),
         Card(
           elevation: 10,
             shadowColor: AppColors.primaryColor,
             child: Container(
            color: AppColors.bgCard,
            padding:const EdgeInsets.all(10),
            child: Row(children: [
            Expanded(child:GestureDetector(child: Image.asset('assets/images/linkss.jpg'),onTap: (){
              const snackBar = SnackBar(
                content: Text('Sorry this feature is not enabled'),

              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },)),
            Expanded(
              flex: 3,
                child: Column(children: [
                  Text(userDetails.name!,style:  WidgetHelper.title,),
                  const SizedBox(height: 5,),
                  Text(userDetails.username!,style:  WidgetHelper.smallTitle,),
                  const SizedBox(height: 5,),
                  Text(userDetails.email!,style:  WidgetHelper.smallTitle,),
                ],)),
            Expanded(
                child:GestureDetector(child:  Container(

                      height: MediaQuery.of(context).size.height * 0.04,

                    decoration: BoxDecoration(
                      color: AppColors.bgIcon,
                        border: Border.all(
                          color:AppColors.bgIcon,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child:Icon(CupertinoIcons.phone,color: AppColors.primaryColor,)
                ),onTap: (){

                  _callNumber(userDetails.phone!);
                },)),


          ],),)),
          const SizedBox(height: 10,),

        ],),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){

        const snackBar = SnackBar(
          content: Text('Sorry this feature is not enabled'),

        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
        backgroundColor: AppColors.appPrimaryColor,
        child: Icon(CupertinoIcons.location_fill,color: AppColors.primaryColor,),
      ),



    );
  }


  _callNumber(String phone) async{
    //set the number here
    bool? res = await FlutterPhoneDirectCaller.callNumber(phone);
  }


}