import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/chatroom_model.dart';
import 'package:whatsapp_clone/model/last_message_model.dart';

import '../model/user_model.dart';

class GetterSetterModel with ChangeNotifier {
  bool _initializeChatroom = true;
  bool get intializeChats => _initializeChatroom;
  intializeChatRoom(bool chat) {
    _initializeChatroom = chat;
    notifyListeners();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  updateLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  getUserModel(UserModel data) {
    _userModel = data;
    notifyListeners();
  }

  List _getUserList = [];
  List get getAllUser => _getUserList;
  getUsers(List users) {
    _getUserList = users;
    notifyListeners();
  }

  final List<Map<Object?, Object?>> _myChats = [];
  List<Map<Object?, Object?>> get myChatRooms => _myChats;
  getMyChats(Map<Object?, Object?> chats) {
    _myChats.add(chats);
    notifyListeners();
  }

  clearMyChats() {
    _myChats.clear();
    notifyListeners();
  }

  List<LastMessageModel> _lastMessage = [];
  List<LastMessageModel> get lastMessage => _lastMessage;
  getLastMesage(LastMessageModel chats) {
    _lastMessage.add(chats);
    notifyListeners();
  }

  clearLastMessage() {
    _lastMessage.clear();
    notifyListeners();
  }

  String _getuserStatus = "";
  String get getUserStatus => _getuserStatus;
  getStatus(String status) {
    _getuserStatus = status;
    notifyListeners();
  }
}
