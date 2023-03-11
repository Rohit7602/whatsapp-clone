import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

final auth = FirebaseAuth.instance;
final database = FirebaseDatabase.instance;
final storage = FirebaseStorage.instance;
ScrollController? scrollController;
