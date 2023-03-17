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

  final List<UserModel> _getUserList = [];
  List<UserModel> get getAllUser => _getUserList;
  getUsers(List<UserModel> users) {
    _getUserList.addAll(users);
    notifyListeners();
  }

  emptyGetUserList() {
    _getUserList.clear();
    notifyListeners();
  }

  final List<TargetUserModel> _lastMessageModel = [];
  List<TargetUserModel> get targetUserModel => _lastMessageModel;
  getLastMesage(TargetUserModel chats) {
    _lastMessageModel.add(chats);
    notifyListeners();
  }

  removeLastMessage() {
    _lastMessageModel.clear();
    notifyListeners();
  }

  String _getuserStatus = "";
  String get getUserStatus => _getuserStatus;
  getStatus(String status) {
    _getuserStatus = status;
    notifyListeners();
  }

  final List<MessageModel> _messageModel = [];
  List<MessageModel> get messageModel => _messageModel;
  updateMessageModel(MessageModel msg) {
    if (_messageModel.any((element) => element.messageId == msg.messageId)) {
      null;
    } else {
      _messageModel.add(msg);
    }

    notifyListeners();
  }

  // MessageModel? _singleMessageModel;
  // MessageModel get singleMessageModel => _singleMessageModel!;
  // updateSingleMessage(MessageModel msg) {
  //   _messageModel.add(msg);

  //   notifyListeners();
  // }

  removeChatMessages() {
    _messageModel.clear();
    notifyListeners();
  }

  String? _getChatRoomId;
  String? get getChatRoomId => _getChatRoomId;
  updateChatRoomId(String id) {
    _getChatRoomId = id;
    notifyListeners();
  }

  removeChatRoomId() {
    _getChatRoomId = "";
    notifyListeners();
  }
}
