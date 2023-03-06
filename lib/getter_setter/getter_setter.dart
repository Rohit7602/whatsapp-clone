import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/target_user_model.dart';
import '../model/message_model.dart';
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
  loadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  getUserModel(UserModel data) {
    _userModel = data;
    notifyListeners();
  }

  List<UserModel> _getUserList = [];
  List<UserModel> get getAllUser => _getUserList;
  getUsers(List<UserModel> users) {
    _getUserList.addAll(users);
    notifyListeners();
  }

  final List<TargetUserModel> _targetModel = [];
  List<TargetUserModel> get targetUserModel => _targetModel;
  getLastMesage(TargetUserModel chats) {
    _targetModel.clear();
    _targetModel.add(chats);
    notifyListeners();
  }

  String _getuserStatus = "";
  String get getUserStatus => _getuserStatus;
  getStatus(String status) {
    _getuserStatus = status;
    notifyListeners();
  }

  List<MessageModel> _messageModel = [];
  List<MessageModel> get messageModel => _messageModel;
  updateMessageModel(List<MessageModel> msg) {
    _messageModel = msg;
    notifyListeners();
  }
}
