// ignore_for_file: must_be_immutable

part of 'user_list_bloc.dart';

@immutable
abstract class UserListEvent {}


class UserListLoading extends UserListEvent{
  UserListLoading();
}

class UserListSearchLoading extends UserListEvent{
  List<UserListModel> data;
  String value;

  UserListSearchLoading({required this.data,required this.value});
}
