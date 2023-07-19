// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe/controller/cubit/cubit.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/controller/helper/bloc_observe.dart';
import 'package:stripe/view/screen/mainScreen.dart';
// import 'package:stripe_payment/stripe_payment.dart';
import 'controller/services/.env';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // StripeServices.init();
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  // await Stripe.instance.applySettings();
  Stripe.publishableKey = publishKey;
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return PaymentCubit();
      },
      child: BlocConsumer<PaymentCubit, PaymentStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, PaymentStates state) {
          return MaterialApp(
            title: 'Stripe integration',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.indigo.shade600,
              ),
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
