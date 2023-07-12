import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/controller/services/.env';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(InitialPaymentStates());
  static PaymentCubit get(context) => BlocProvider.of(context);

  static Map<String, dynamic>? paymentIntent;
  Future<void> makePayment() async {
    emit(MakePaymentStateLoading());
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent('100', 'USD');

      //STEP 2: Initialize Payment Sheet

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'Autonomo'))
          .then((value) {
        print("Success =========>");
      });

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
      emit(MakePaymentStateSuccess());
    } catch (err) {
      print("$err  ====================>");
      emit(MakePaymentStateError());

      throw Exception(err);
    }
  }

  createPaymentIntent(String amount, String currency) async {
    emit(CreatePaymentStateLoading());
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer sk_test_51NQvOiI41E0DZWo5vqwk458vCFoirtWIenurmBdN36asuAT2k5i6px0tnlEbFNh1WMF8jkeS1OtgnZEGKu8413VF00cWJU9j2L',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      emit(CreatePaymentStateSuccess());

      return json.decode(response.body);
    } catch (err) {
      emit(CreatePaymentStateError());

      throw Exception(err.toString());
    }
  }

  displayPaymentSheet() async {
    emit(DisplayPaymentStateLoading());
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Clear paymentIntent variable after successful payment
        print("success// ===================>");
        paymentIntent = null;
      }).onError((error, stackTrace) {
        print("Failed ===================>");

        throw Exception(error);
      });
      emit(DisplayPaymentStateSuccess());
    } on StripeException catch (e) {
      emit(DisplayPaymentStateError());

      print('Error is:---> $e');
    } catch (e) {
      print('$e');
      emit(DisplayPaymentStateError());
    }
  }
}
