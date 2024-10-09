import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle successful payment here
    print("Payment successful: ${response.paymentId}");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment successful!')),
    );

    // Proceed with checkout logic
    final provider = Provider.of<HomeProvider>(context, listen: false);
    provider.checkout(); // Clear the cart or handle checkout process
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure here
    print("Payment failed: ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment failed: ${response.message}')),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet payment here
    print("External wallet selected: ${response.walletName}");
  }

  void _startPayment(double amount) {
    var options = {
      'key': 'rzp_test_4rdgre6savrrmw', // Replace with your Razorpay key
      'amount': 1, // Amount in paise
      'currency': 'INR',
      'name': 'KECGo',
      'description': 'Order Payment',
      'prefill': {
        'contact': '1234567890',
        'email': 'test@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);

    return Scaffold(
      body: provider.cartItems.isEmpty
          ? const Center(
              child: Text(
                'Your cart is empty.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.cartItems.length,
                    itemBuilder: (context, index) {
                      final item = provider.cartItems[index];

                      return ListTile(
                        title: Text(item.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: \$${item.price.toStringAsFixed(2)}'),
                            const SizedBox(height: 4),
                            Text('Quantity: ${item.quantity}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                if (item.quantity > 1) {
                                  provider.updateItemQuantity(index, item.quantity - 1);
                                } else {
                                  provider.removeFromCart(index);
                                }
                              },
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                provider.updateItemQuantity(index, item.quantity + 1);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: \$${provider.cartItems.fold<double>(0, (sum, item) => sum + (item.price * item.quantity)).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          double totalAmount = provider.cartItems.fold<double>(
                              0, (sum, item) => sum + (item.price * item.quantity));
                          _startPayment(totalAmount); // Call Razorpay payment function
                        },
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
