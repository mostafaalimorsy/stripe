// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/controller/cubit/cubit.dart';
import 'package:stripe/controller/cubit/status.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentStates>(
      listener: (BuildContext context, state) {},
      builder: (BuildContext context, PaymentStates state) {
        PaymentCubit getData = PaymentCubit.get(context);

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
            title: const Text(
              "Cart",
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
            centerTitle: true,
            leading: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios)),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SizedBox(
              height: 35,
            ),
            //header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const Text(
                "Review Order",
                style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            //bill view
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(.1),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Colors.grey.withOpacity(.4),
                  ),
                ),
                child: Column(
                  children: [
                    //items and prices
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Basic - Standred Listing",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "\$19.95",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    //Divider
                    Container(
                      height: 1,
                      width: 330,
                      color: Colors.grey.withOpacity(.4),
                    ),
                    //subtotal
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Subtotal",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "\$19.95",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    //tax
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Tax",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "-",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                    //Divider
                    ,
                    Container(
                      height: 1,
                      width: 330,
                      color: Colors.grey.withOpacity(.4),
                    ),
                    //total
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                          Text(
                            "\$19.95",
                            style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white, fontSize: 15),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            //Divider
            Container(
              height: 1,
              color: Colors.grey.withOpacity(.4),
            ),
            const SizedBox(
              height: 20,
            ),
            //button to pay
            Center(
              child: InkWell(
                onTap: () {
                  getData.makePayment(total: "100");
                },
                child: Container(
                  height: 50,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade600,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: const Center(
                    child: Text(
                      "Proceed to Checkout",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ]),
        );
      },
    );
  }
}
