import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoritesModule extends ChangeNotifier {
  List<String> _favoriteItems = [];

  List<String> get favoriteItems => _favoriteItems;

  Future<void> fetchFavoriteItems() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .get();

      _favoriteItems = snapshot.docs.map((doc) => doc['title'] as String).toList();
      notifyListeners();
    }
  }

  Future<void> addToFavorites(String title) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentReference favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(title);

      await favoritesRef.set({'title': title});
      _favoriteItems.add(title);
      notifyListeners();
    }
  }

  Future<void> removeFromFavorites(String title) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentReference favoritesRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('favorites')
          .doc(title);

      await favoritesRef.delete();
      _favoriteItems.remove(title);
      notifyListeners();
    }
  }

  int get favoriteCount => _favoriteItems.length;
}
