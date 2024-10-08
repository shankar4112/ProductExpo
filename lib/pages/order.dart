import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderPage extends StatelessWidget {
  // Removed const from constructor
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: fetchOrders(), // Function to fetch orders
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching orders'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('Order #${orders[index].id}'),
                subtitle: Text('Total: \$${order['totalAmount']}'),
                trailing: Text(order['createdAt'].toDate().toString()), // Display order date
              );
            },
          );
        },
      ),
    );
  }

  Future<QuerySnapshot> fetchOrders() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user is logged in.');
    }

    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid).collection('orders')
        
        .get();
  }
}
