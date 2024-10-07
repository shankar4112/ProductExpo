import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get userId => _auth.currentUser?.uid;

  Future<void> addToFavorites(String title) async {
    if (userId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(title)
          .set({'title': title});
    }
  }

  Future<void> removeFromFavorites(String title) async {
    if (userId != null) {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(title)
          .delete();
    }
  }

  Stream<List<String>> fetchFavoriteItems() {
    if (userId != null) {
      return _firestore
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc['title'] as String).toList());
    }
    return const Stream.empty();
  }
}
