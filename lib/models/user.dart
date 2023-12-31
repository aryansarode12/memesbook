import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String name;
  String profilephoto;
  String email;
  String uid;

  User({
    required this.name,
    required this.email,
    required this.uid,
    required this.profilephoto,
  });

  Map<String, dynamic> toJson() => {
        "name": name,
        "profilephoto": profilephoto,
        "email": email,
        "uid": uid,
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
      email: snapshot['email'],
      profilephoto: snapshot['profilephoto'],
      uid: snapshot['uid'],
      name: snapshot['name'],
    );
  }
}
