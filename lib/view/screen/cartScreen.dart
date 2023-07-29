// ignore_for_file: file_names, must_be_immutable

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/controller/cubit/cubit.dart';
import 'package:stripe/controller/cubit/status.dart';
import 'package:stripe/controller/services/calcSize.dart';
import 'package:stripe/controller/services/commonUtlity.dart';

class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);
  final TextEditingController _couponCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentStates>(
      listener: (BuildContext context, state) {
        if (state is ClearCartStateSuccess) {
          Navigator.pop(context);
        }
      },
      builder: (BuildContext context, PaymentStates state) {
        PaymentCubit getData = PaymentCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
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
            actions: [
              InkWell(
                  onTap: () {
                    getData.clearCart();
                  },
                  child: const Icon(Icons.delete_sweep_outlined))
            ],
          ),
          body: ConditionalBuilder(
            condition: getData.cartItem.isNotEmpty,
            builder: (BuildContext context) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: true),
                ),
                //header
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.size(context: context, sizeNumber: 16, isHeight: false),
                  ),
                  child: const Text(
                    "Review Order",
                    style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white, fontSize: 25),
                  ),
                ),
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: true),
                ),
                //bill view
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: false),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: false),
                      ),
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
                          LimitedBox(
                            maxHeight: ResponsiveSize.size(context: context, sizeNumber: 300.0, isHeight: true),
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: getData.cartItem.length,
                              itemBuilder: (BuildContext context, int index) {
                                return CommonWidget.billRow(
                                    enableDeleteItem: true,
                                    onTap: () => getData.deleteItemOnCart(index),
                                    context: context,
                                    rowTitle: "${getData.cartItem[index].itemName}",
                                    rowValue: "${getData.cartItem[index].total}");
                              },
                            ),
                          ),

                          //Divider
                          CommonWidget.divider(context: context),
                          //total
                          CommonWidget.billRow(
                              context: context, rowTitle: "Subtotal", rowValue: "${getData.cartSubTotal}"),
                          //tax
                          CommonWidget.billRow(context: context, rowTitle: "Tax", rowValue: "${getData.cartTax}"),
                          //Divider
                          CommonWidget.divider(context: context),
                          //total
                          CommonWidget.billRow(context: context, rowTitle: "Total", rowValue: "${getData.cartTotal}"),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 10, isHeight: true),
                ),
                //coupon
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: false),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: ResponsiveSize.size(context: context, sizeNumber: 240, isHeight: false),
                        height: ResponsiveSize.size(context: context, sizeNumber: 50, isHeight: false),
                        child: TextFormField(
                          style: const TextStyle(color: Colors.white),
                          controller: _couponCodeController,
                          decoration: InputDecoration(
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey,
                                width: 1.0,
                              ),
                            ),
                            hintStyle: const TextStyle(color: Colors.white),
                            hintText: 'Enter your coupon code',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(.4),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter a coupon code';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(
                        width: ResponsiveSize.size(context: context, sizeNumber: 70, isHeight: false),
                        height: ResponsiveSize.size(context: context, sizeNumber: 50, isHeight: false),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: _couponCodeController.text.isNotEmpty
                                  ? MaterialStateProperty.all<Color>(Colors.indigo.shade600)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey.withOpacity(.4),
                                    )),
                          child: const Text("Apply"),
                          onPressed: () {
                            if (_couponCodeController.text.isNotEmpty) {
                              getData.couponID = _couponCodeController.text;
                              getData.totalAfterCoupon();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 10, isHeight: true),
                ),
                if (getData.cartTotalAfterDiscount != 0)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveSize.size(context: context, sizeNumber: 60, isHeight: false),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonWidget.billRow(
                            context: context,
                            rowTitle: "Total after Discount is ",
                            rowValue: "${getData.cartTotalAfterDiscount}"),
                        InkWell(
                          onTap: () {
                            getData.clearCoupon();
                          },
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                const Spacer(),
                //Divider
                CommonWidget.divider(w: double.infinity, context: context),
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 10, isHeight: true),
                ),

                //button to pay

                Center(
                  child: InkWell(
                    onTap: () {
                      getData.makePayment(
                          total:
                              getData.cartTotalAfterDiscount == 0 ? getData.cartTotal : getData.cartTotalAfterDiscount);
                    },
                    child: Container(
                      height: ResponsiveSize.size(context: context, sizeNumber: 50, isHeight: true),
                      width: ResponsiveSize.size(context: context, sizeNumber: 350, isHeight: false),
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
                SizedBox(
                  height: ResponsiveSize.size(context: context, sizeNumber: 20, isHeight: true),
                ),
              ]);
            },
            fallback: (BuildContext context) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: ResponsiveSize.size(context: context, sizeNumber: 200, isHeight: true),
                      width: ResponsiveSize.size(context: context, sizeNumber: 200, isHeight: false),
                      child: Image.asset("assets/emptycart.png")),
                  SizedBox(
                    height: ResponsiveSize.size(context: context, sizeNumber: 20, isHeight: true),
                  ),
                  const Text(
                    "Oops...",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: ResponsiveSize.size(context: context, sizeNumber: 10, isHeight: true),
                  ),
                  const Text(
                    "The Cart is Empty",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  SizedBox(
                    height: ResponsiveSize.size(context: context, sizeNumber: 30, isHeight: true),
                  ),
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: ResponsiveSize.size(context: context, sizeNumber: 35, isHeight: true),
                        width: ResponsiveSize.size(context: context, sizeNumber: 170, isHeight: false),
                        decoration: BoxDecoration(
                          color: Colors.indigo.shade600,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            "Shop Now",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        );
      },
    );
  }
}
