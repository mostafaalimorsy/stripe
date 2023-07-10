// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:http/http.dart' as http;

// class StripeService {
//   static Map<String, dynamic>? paymentIntent;

//   static Future<void> payment() async {
  
//     //
//     try {
//       Map<String, dynamic>? body = {
//         'amount': "100",
//         'currency': "USD",
//       };
//       var url = Uri.parse('https://api.stripe.com/v1/payment_intents');
//       var resposne = await http.post(url,
//           headers: {
//             'Authorization':
//                 "Bearer sk_test_51NQvOiI41E0DZWo5vqwk458vCFoirtWIenurmBdN36asuAT2k5i6px0tnlEbFNh1WMF8jkeS1OtgnZEGKu8413VF00cWJU9j2L",
//             'Content-Type': 'application/x-www-form-urlencoded'
//           },
//           body: body);

//       paymentIntent = json.decode(resposne.body);
//     } catch (error) {
//       throw Exception(error.toString());
//     }
// //
//     await Stripe.instance
//         .initPaymentSheet(
//       paymentSheetParameters: SetupPaymentSheetParameters(
//         paymentIntentClientSecret: paymentIntent!['client_secret'],
//         style: ThemeMode.light,
//         merchantDisplayName: "Autonomo",
//       ),
//     )
//         .then((value) {
//       print("================================>");
//     }).catchError((e) {
//       print(e.toString());
//     });

// //
//     try {
//       await Stripe.instance.presentPaymentSheet().then((value) {
//         //when payment successful
//         print("success");
//       });
//     } catch (e) {
//       throw Exception(e);
//     }
//   }
// }



// import 'dart:convert';
// import 'dart:math';

// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
// import 'package:stripe_payment/stripe_payment.dart';

// class StripeTransactionResponse {
//   String message;
//   bool success;
//   StripeTransactionResponse({
//     required this.message,
//     required this.success,
//   });
// }

// class StripeServices {
//   static String apiBase = 'https://api.stripe.com/v1';
//   static String paymentApiUrl = '${StripeServices.apiBase}/payment_intents';
//   static Uri paymentApiUri = Uri.parse(paymentApiUrl);
//   static String secret =
//       'sk_test_51NQvOiI41E0DZWo5vqwk458vCFoirtWIenurmBdN36asuAT2k5i6px0tnlEbFNh1WMF8jkeS1OtgnZEGKu8413VF00cWJU9j2L';

//   static Map<String, String> headers = {
//     'Authorization': 'Bearer ${StripeServices.secret}',
//     'Content-Type': 'application/x-www-form-urlencoded'
//   };

//   static init() {
//     StripePayment.setOptions(StripeOptions(
//         publishableKey:
//             'pk_test_51NQvOiI41E0DZWo5E1ihflypNxgpBJdavNkVsCxjRgd3rQmDvov1fJn0FYkuEWOOzgpYGZVMFwu0yzrvvM8jZv2D00uIvbnsDY',
//         androidPayMode: 'test',
//         merchantId: 'test'));
//   }

//   static Future<Map<String, dynamic>> createPaymentIntent(
//       String amount, String currency) async {
//     try {
//       Map<String, dynamic> body = {
//         'amount': amount,
//         'currency': currency,
//       };

//       var response =
//           await http.post(paymentApiUri, headers: headers, body: body);
//       return jsonDecode(response.body);
//     } catch (error) {
//       print('error Happened');
//       throw error;
//     }
//   }

//   static Future<StripeTransactionResponse> payNowHandler(
//       {required String amount, required String currency}) async {
//     try {
//       // var paymentMethod = await Stripe.ins.paymentRequestWithCardForm(
//       //     CardFormPaymentRequest());
//       var paymentIntent =
//           await StripeServices.createPaymentIntent(amount, currency);
//       var response = await StripePayment.confirmPaymentIntent(PaymentIntent(
//           clientSecret: paymentIntent['client_secret'],
//           paymentMethodId: paymentMethod.id));

//       if (response.status == 'succeeded') {
//         return StripeTransactionResponse(
//             message: 'Transaction succeful', success: true);
//       } else {
//         return StripeTransactionResponse(
//             message: 'Transaction failed', success: false);
//       }
//     } catch (error) {
//       return StripeTransactionResponse(
//           message: 'Transaction failed in the catch block', success: false);
//     } on PlatformException catch (error) {
//       return StripeServices.getErrorAndAnalyze(error);
//     }
//   }

//   static getErrorAndAnalyze(err) {
//     String message = 'Something went wrong';
//     if (err.code == 'cancelled') {
//       message = 'Transaction canceled';
//     }
//     return StripeTransactionResponse(message: message, success: false);
//   }
// }
