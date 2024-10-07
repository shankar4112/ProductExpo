import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add item to the user's cart
  Future<void> addToCart(String userId, String item) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .add({
      'item': item,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Fetch cart items
  Stream<QuerySnapshot> getCartItems(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('cart')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
