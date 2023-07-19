// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pay/pay.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/model/itemData.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(InitialPaymentStates());
  static PaymentCubit get(context) => BlocProvider.of(context);

  static Map<String, dynamic>? paymentIntent;
  List<CartItems> cartItem = [];
  double cartTotal = 0;
  double cartTax = 0;
  double cartSubTotal = 0;
  var paymentItems;
  String result = "";
  late final googlePayMap;
  late final applePayMap;

  // Create a SetupPaymentSheetParameters object with the desired options

//add items to cart list
  void addCardItem({data, tax}) {
    emit(AddCartItemStateLoading());
    tax = 10;
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
      result = ((cartTotal * 100).toInt()).toString();

      googlePayMap = {
        "provider": "google_pay",
        "data": {
          "environment": "TEST",
          "apiVersion": "2",
          "apiVersionMinor": "0",
          "allowedPaymentMethods": [
            {
              "type": "CARD",
              "tokenizationSpecification": {
                "type": "PAYMENT_GATEWAY",
                "parameters": {"gateway": "example", "gatewayMerchantId": "gatewayMerchantId"}
              },
              "parameters": {
                "allowedCardNetworks": ["VISA", "MASTERCARD"],
                "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
                "billingAddressRequired": "true",
                "billingAddressParameters": {"format": "FULL", "phoneNumberRequired": "true"}
              }
            }
          ],
          "merchantInfo": {"merchantId": "01234567890123456789", "merchantName": "Example Merchant Name"},
          "transactionInfo": {
            "countryCode": "US",
            "currencyCode": "USD",
            'totalPrice': "$result",
          }
        }
      };
      applePayMap = {
        "provider": "apple_pay",
        "data": {
          "merchantIdentifier": "merchant.com.sams.fish",
          "displayName": "Sam's Fish",
          "merchantCapabilities": ["3DS", "debit", "credit"],
          "supportedNetworks": ["amex", "visa", "discover", "masterCard"],
          "countryCode": "US",
          "currencyCode": "USD",
          "requiredBillingContactFields": ["emailAddress", "name", "phoneNumber", "postalAddress"],
          "requiredShippingContactFields": [],
          "shippingMethods": [
            {
              "amount": "0.00",
              "detail": "Available within an hour",
              "identifier": "in_store_pickup",
              "label": "In-Store Pickup"
            },
            {
              "amount": "4.99",
              "detail": "5-8 Business Days",
              "identifier": "flat_rate_shipping_id_2",
              "label": "UPS Ground"
            },
            {
              "amount": "29.99",
              "detail": "1-3 Business Days",
              "identifier": "flat_rate_shipping_id_1",
              "label": "FedEx Priority Mail"
            }
          ]
        }
      };
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

      paymentIntent = await createPaymentIntent("$result", 'USD');

      //STEP 2: Initialize Payment Sheet
      String result2 = result;
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
            primaryButtonLabel: 'Pay now',
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

  // Future<void> makePlatformPayment() async {
  //
  //   try {
  //     paymentItems = [
  //       PaymentItem(
  //         label: 'Total',
  //         amount: "$cartSubTotal",
  //         status: PaymentItemStatus.final_price,
  //       )
  //     ];
  //     emit(CreatePaymentPlatformStateSuccess());
  //   } catch (e) {
  //     print(e);
  //     emit(CreatePaymentPlatformStateError());
  //   }
  // }

  // Future<Map<String, dynamic>> createPaymentIntentPayPal() async {
  //   emit(CreatePaymentPlatformStateLoading());
  //   final url = Uri.parse('https://api.stripe.com/v1/create-payment-intent');
  //   final response = await http.post(
  //     url,
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //     body: json.encode({
  //       'currency': 'USD',
  //       'payment_method_types': ['paypal'],
  //       'amount': result
  //     }),
  //   );
  //   emit(CreatePaymentPlatformStateSuccess());
  //   print(response.body);
  //   return json.decode(response.body);
  // }
}
