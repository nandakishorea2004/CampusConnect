// ignore_for_file: must_be_immutable

part of 'user_list_bloc.dart';

@immutable
abstract class UserListState {}

class UserListInitial extends UserListState {}


class UserListRefresh extends UserListState{

}

class UserListSuccess extends UserListState{
  List<UserListModel> userData,staticData;

  UserListSuccess({required this.staticData,required this.userData});
}

class UserListFailed extends UserListState{

  String error;
  UserListFailed({required this.error});
}
