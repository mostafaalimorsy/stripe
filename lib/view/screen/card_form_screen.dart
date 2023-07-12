// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart' as stripe;

// class CheckoutScreen extends StatelessWidget {
//   const CheckoutScreen({Key? key, required this.paymentMethodId}) : super(key: key);

//   final String paymentMethodId;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Checkout"),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             try {
//               displayPaymentSheet;
//               print("Payment successful!");
//             } catch (e) {
//               // Handle the payment error here
//               print("Payment error: $e");
//             }
//           },
//           child: const Text("Pay"),
//         ),
//       ),
//     );
//   }
// }

// Future<void> displayPaymentSheet(context) async {
//   try {
//     await stripe.Stripe.instance
//         .presentPaymentSheet(options: const stripe.PaymentSheetPresentOptions(timeout: 1200000));

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Payment successfully completed'),
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('$e'),
//       ),
//     );
//   }
// }

// Future<void> initPaymentSheet(context) async {
//   try {
//     await stripe.Stripe.instance.initPaymentSheet(
//       paymentSheetParameters: const stripe.SetupPaymentSheetParameters(
//         customFlow: true,
//         merchantDisplayName: 'Flutter Stripe Demo',
//         paymentIntentClientSecret: "",
//         customerEphemeralKeySecret: "",
//         customerId: "",
//         setupIntentClientSecret: "",
//         style: ThemeMode.light,
//       ),
//     );
//   } catch (e) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
//     );
//     rethrow;
//   }
// }
