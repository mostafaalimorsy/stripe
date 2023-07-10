// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/controller/cubit/cubit.dart';
import 'package:stripe/controller/cubit/status.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, Object? state) {
        return Scaffold(
          body: Center(
              child: InkWell(
            onTap: () {
              // StripeServices.createPaymentIntent("100", 'USD');
            },
            child: Container(
              height: 50,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(40), color: Colors.indigoAccent),
              child: const Center(
                child: Text(
                  "checkout",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )),
        );
      },
    );
  }
}
