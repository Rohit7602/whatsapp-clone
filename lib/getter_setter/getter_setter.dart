import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/chatroom_model.dart';
import '../model/message_model.dart';
import '../model/user_model.dart';

enum msgState { present, deleteForMe, deleteForEveryone, permanentDeleted }

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

  final List<ChatRoomModel> _chatRoomModel = [];
  List<ChatRoomModel> get chatRoomModel => _chatRoomModel;
  updateChatRoomModel(ChatRoomModel chats) {
    _chatRoomModel.add(chats);

    notifyListeners();
  }

  updateMessageStatus(String roomId, bool isSeen, GetterSetterModel provider) {
    var msgIndex = provider.messageModel
        .indexWhere((element) => element.messageId == roomId);

    _messageModel[msgIndex].seen = isSeen;
    notifyListeners();
  }

  updateUserStatus(String status, int index) {
    _chatRoomModel[index].userModel.status = status;
    notifyListeners();
  }

  updateLastMsg(
      String roomId, String msg, bool isSeen, String type, String time) {
    var roomIndex =
        _chatRoomModel.indexWhere((element) => element.chatId == roomId);
    _chatRoomModel[roomIndex].message = msg;
    _chatRoomModel[roomIndex].seen = isSeen;
    _chatRoomModel[roomIndex].messageType = type;
    _chatRoomModel[roomIndex].sentOn = DateTime.parse(time);
    notifyListeners();
  }

  removeChatRoom() {
    _chatRoomModel.clear();

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

  removeChatMessages() {
    _messageModel.clear();
    notifyListeners();
  }

  String _getChatRoomId = "";
  String get getChatRoomId => _getChatRoomId;
  updateChatRoomId(String id) {
    _getChatRoomId = id;
    notifyListeners();
  }

  removeChatRoomId() {
    _getChatRoomId = "";
    notifyListeners();
  }
}
