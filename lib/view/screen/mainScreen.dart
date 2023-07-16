// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/controller/cubit/cubit.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/view/screen/cartScreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, PaymentStates state) {
        PaymentCubit getData = PaymentCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const CartScreen()));
                  },
                  child: const Icon(Icons.shopping_bag_outlined))
            ],
          ),
          body: Center(
              child: ElevatedButton(
                  onPressed: () async {
                    getData.addCardItem();
                  },
                  child: const Text("Add To Cart "))),
        );
      },
    );
  }
}
