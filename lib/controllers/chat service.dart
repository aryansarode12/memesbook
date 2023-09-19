import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tired/models/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of auth and firestore

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // send message

  Future<void> sendMesssage(String receiverId, String message) async {
    // get current user info
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserId,
        senderEmail: currentUserEmail,
        receiverID: receiverId,
        timestamp: timestamp,
        message: message);

    // construct a chat room id  user and recriver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sort the ids
    String chatRoomID = ids.join("_"); // combine the ids

    // add message to the database

    await _firestore
        .collection('chat_Room')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get message

  Stream<QuerySnapshot> getMessages(String userID, String otherUserId) {
    // construct chat room id from users ids
    List<String> ids = [userID, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
