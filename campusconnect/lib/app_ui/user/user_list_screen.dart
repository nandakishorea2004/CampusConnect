import 'package:campus/blocs/users/user_list_bloc.dart';
import 'package:campus/styles/app_colors.dart';
import 'package:campus/styles/widget_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatefulWidget{
  const UserListScreen({super.key});


  @override
  UserListUI createState()=> UserListUI();
}
class UserListUI extends State<UserListScreen>{


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<UserListBloc>(context).add(UserListLoading());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("User List",style: TextStyle(fontSize: 16,color: AppColors.primaryColor,fontWeight: FontWeight.w600),),
      ),

      body: SingleChildScrollView(
        padding:const EdgeInsets.all(10),
        child: Column(children: [

        BlocBuilder<UserListBloc,UserListState>(builder: (context,state){
    return state is UserListSuccess ? TextFormField(

            decoration:const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search),
              hintText: 'Search user...'
            ),
            onChanged: (value){

              BlocProvider.of<UserListBloc>(context).add(UserListSearchLoading(data: state.staticData, value: value.toString()));
            },
          ):Container();}),
          const SizedBox(height: 10,),
       BlocBuilder<UserListBloc,UserListState>(builder: (context,state){
         return state is UserListSuccess ? Container(
            height: MediaQuery.of(context).size.height * .82,
            margin:const EdgeInsets.only(bottom: 30),
            child: ListView.builder(
              itemCount: state.userData.length,
                itemBuilder: (BuildContext context,int index){
            return Card(child:Container(
              padding:const EdgeInsets.all( 5,),
              margin:const EdgeInsets.only(top: 10),
                child: GestureDetector(
              child:  Row(
                children: [
               const CircleAvatar(
                  radius: 48, // Image radius
                  backgroundImage: AssetImage('assets/images/user_image.jpeg'),
                ),
                  const SizedBox(width: 8,),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(state.userData[index].name!,style: WidgetHelper.title,),
                      const SizedBox(height: 5,),
                      Text(state.userData[index].username!,style: WidgetHelper.smallTitle),
                      const SizedBox(height: 5,),
                      Text(state.userData[index].email!,style: WidgetHelper.smallTitle)

                  ],))

              ],),
                  onTap: (){
                Navigator.pushNamed(context, '/userDetails',arguments: state.userData[index]);
                  },

            )));

          }),):Container();}),
          const SizedBox(height: 10,)

      ],),),


    );

  }

}