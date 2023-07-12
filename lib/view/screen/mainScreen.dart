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
      builder: (BuildContext context, PaymentStates state) {
        PaymentCubit getData = PaymentCubit.get(context);
        return Scaffold(
          body: Center(
              child: ElevatedButton(
                  onPressed: () async {
                    getData.makePayment();
                  },
                  child: const Text("Pay"))),
        );
      },
    );
  }
}
