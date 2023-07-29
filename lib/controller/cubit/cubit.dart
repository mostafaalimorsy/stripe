// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/model/itemData.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(InitialPaymentStates());
  static PaymentCubit get(context) => BlocProvider.of(context);

  static Map<String, dynamic>? paymentIntent;
  List<CartItems> cartItem = [];
  double cartTotal = 0;
  double cartTotalAfterDiscount = 0;
  double cartTax = 0;
  double cartSubTotal = 0;
  var paymentItems;
  String result = "";
  String couponID = "";
  double discountValue = 0;
  double tax = 10;

  // Create a SetupPaymentSheetParameters object with the desired options

//add items to cart list
  void addCardItem({data}) {
    emit(AddCartItemStateLoading());

    try {
      // TODO: change it to (data.name) and (data.price) and (data.qty)
      for (double i = 0; i < 3; i++) {
        CartItems newItem = CartItems(itemName: 'itemName test $i', price: 100 * i, qty: 1 + i);
        cartItem.add(newItem);
      }
      calcTotalItem();
      cartSubTotal = calcTotalPriceOfItems();
      cartTax = calcTax(tax: tax);
      cartTotal = calcTotal(tax: tax);

      emit(AddCartItemStateSuccess());
    } catch (e) {
      print(e.toString());
      emit(AddCartItemStateError());
    }
  }

//to calc total for each item on cart
  void calcTotalItem() {
    emit(CalcTotalItemStateLoading());
    try {
      for (int i = 0; i < cartItem.length; i++) {
        double total = cartItem[i].price! * cartItem[i].qty!;
        cartItem[i].total = total;
        total = 0;
      }
      emit(CalcTotalItemStateSuccess());
    } catch (e) {
      print(e.toString());
      emit(CalcTotalItemStateError());
    }
  }

//to calc total for all item
  double calcTotalPriceOfItems() {
    emit(ClacSubTotalStateLoading());

    double total = 0;
    try {
      for (int i = 0; i < cartItem.length; i++) {
        total += cartItem[i].total!;
      }
      emit(ClacSubTotalStateSuccess());

      return total;
    } catch (e) {
      print(e.toString());
      emit(ClacSubTotalStateError());
      return 0;
    }
  }

//to calc tax
  double calcTax({tax}) {
    emit(ClacTaxStateLoading());
    try {
      double taxAmount = cartSubTotal * (tax / 100);
      emit(ClacTaxStateSuccess());
      return taxAmount;
    } catch (e) {
      emit(ClacTaxStateError());
      return 0;
    }
  }

//to calc sub total
  double calcTotal({tax}) {
    try {
      double subTotal = cartSubTotal + cartTax;
      emit(ClacTotalStateSuccess());

      return subTotal;
    } catch (e) {
      emit(ClacTotalStateError());
      return 0;
    }
  }

//clear cart after payment successfully
  bool clearCart() {
    emit(ClearCartStateLoading());
    try {
      cartItem.clear();
      cartTotal = 0;
      cartTax = 0;
      cartSubTotal = 0;
      cartTotalAfterDiscount = 0;
      emit(ClearCartStateSuccess());
      return true;
    } catch (e) {
      print(e.toString());
      emit(ClearCartStateError());
      return false;
    }
  }

//that func call stripe sdk and consider it as main function that start all proccess of stripe
  Future<void> makePayment({total}) async {
    emit(MakePaymentStateLoading());
    try {
      //STEP 1: Create Payment Intent
      result = ((cartTotalAfterDiscount == 0 ? cartTotal * 100 : cartTotalAfterDiscount * 100).toInt()).toString();
      paymentIntent = await createPaymentIntent("$result", 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            // applePay: PaymentSheetApplePay(merchantCountryCode: 'US', buttonType: PlatformButtonType.pay, cartItems: [
            //   ApplePayCartSummaryItem.immediate(
            //     label: 'Autonomo',
            //     amount: "$result",
            //   )
            // ]),
            customerEphemeralKeySecret: paymentIntent!['ephemeralKey'],
            customerId: paymentIntent!['customer'],
            // primaryButtonLabel: 'Pay now',
            // payPal:,
            applePay: const PaymentSheetApplePay(
              merchantCountryCode: 'US',
            ),
            googlePay: const PaymentSheetGooglePay(
              merchantCountryCode: 'US',
              testEnv: true,
            ),
            // googlePay: const PaymentSheetGooglePay(merchantCountryCode: "US", currencyCode: "USD", testEnv: true),
            appearance: PaymentSheetAppearance(
              primaryButton: PaymentSheetPrimaryButtonAppearance(
                colors: PaymentSheetPrimaryButtonTheme(
                  light: PaymentSheetPrimaryButtonThemeColors(
                    background: Colors.indigo.shade600,
                  ),
                  dark: PaymentSheetPrimaryButtonThemeColors(
                    background: Colors.indigo.shade600,
                  ),
                ),
              ),
            ),
            paymentIntentClientSecret: paymentIntent!['client_secret'], //Gotten from payment intent
            style: ThemeMode.light,
            merchantDisplayName: 'Autonomo'),
      )
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

//create payment that send amount and currency to Stripe api
  createPaymentIntent(amount, String currency) async {
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

//after all function is done this display and end all proccess
  displayPaymentSheet() async {
    emit(DisplayPaymentStateLoading());
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Clear paymentIntent variable after successful payment
        print("success// ===================>");
        clearCart();
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

  void getDiscountValue() {
    // TODO: get discount value from db by id
    couponID;
    discountValue = 10;
  }

//calc coupon value
  void totalAfterCoupon() {
    emit(ClacDiscountStateLoading());
    cartTotalAfterDiscount = double.parse((cartTotal - (cartTotal * (discountValue / 100))).toStringAsFixed(2));
    emit(ClacDiscountStateSuccess());
  }

  void clearCoupon() {
    emit(ClearDiscountStateLoading());
    cartTotalAfterDiscount = 0;
    result = ((cartTotalAfterDiscount == 0 ? cartTotal * 100 : cartTotalAfterDiscount * 100).toInt()).toString();
    emit(ClearDiscountStateSuccess());
  }

  void deleteItemOnCart(index) {
    emit(DeleteItemStateLoading());
    try {
      cartItem.removeAt(index);
      clearCoupon();
      calcTotalItem();
      cartSubTotal = calcTotalPriceOfItems();
      cartTax = calcTax(tax: tax);
      cartTotal = calcTotal(tax: tax);
      emit(DeleteItemStateSuccess());
    } catch (e) {
      print(e);
      emit(DeleteItemStateError());
    }
  }
}
