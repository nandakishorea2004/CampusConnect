import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:campus/utils/api_manager.dart';
import 'package:meta/meta.dart';

import '../../data_model/user_model/UserListModel.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(UserListInitial()) {
    on<UserListLoading>((event, emit) async{

      try{
      final List<dynamic> response=await ApiManager.getRequest("/users");

      List<UserListModel> data=[];
      for (int j=0;j<response.length;j++){
        UserListModel model=UserListModel.fromJson(response[j]);
        data.add(model);
      }


      emit(UserListSuccess(staticData: data,userData: data));

      }catch(e){
        emit(UserListFailed(error: e.toString()));
      }

    });


    on<UserListSearchLoading> ((event,emit){

      List<UserListModel> tempData=[];
      for(var element in event.data){

        if(element.name!.toLowerCase().toString().contains(event.value.toLowerCase().toString())||element.username!.toLowerCase().toString().contains(event.value.toLowerCase().toString())){


          tempData.add(element);
        }

      }

      emit(UserListSuccess(staticData: event.data, userData: tempData));


    });
  }
}
