import 'package:flutter/material.dart';
import 'package:whatsapp_clone/model/chatroom_model.dart';

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
  }

  List<ChatRoomModel> _lastMessage = [];
  List<ChatRoomModel> get lastMessage => _lastMessage;
  getLastMesage(List<ChatRoomModel> chats) {
    _lastMessage = chats;
    notifyListeners();
  }
}
