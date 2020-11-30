import 'dart:ui';

import 'package:daily_design/ui/views/plans/plan_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:stacked/stacked.dart';

class PlansView extends StatefulWidget {
  @override
  _PlansViewState createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PlansViewModel>.reactive(
      onModelReady: (m) async => await m.init(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 10,
          iconTheme: IconThemeData().copyWith(color: Colors.black),
          shadowColor: Color(0xff2F4858).withOpacity(0.1),
          title: Row(
            children: [
              Text(
                'Daily',
                style: TextStyle(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    color: Color(0xff2F4858),
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'Designs',
                style: TextStyle(
                    fontFamily: GoogleFonts.montserrat().fontFamily,
                    color: Color(0xfff00104),
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - kToolbarHeight,
            width: MediaQuery.of(context).size.width,
            child: model.busy('init')
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1,
                      valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          height: 200,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 50,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Remaining Credits',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 150,
                                child: Center(
                                  child: model.busy('init')
                                      ? CircularProgressIndicator(
                                          strokeWidth: 1,
                                          valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            model.userData.remainingGraphics,
                                            style: TextStyle(fontSize: 100),
                                          ),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Active Subscription'),
                              )),
                        ),
                        Flexible(
                          child: Card(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: InkWell(
                                onTap: () {},
                                borderRadius: BorderRadius.circular(4),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Daily Designs 1 Year Subscription',
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Subscription'),
                              )),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: List.generate(model.productDetailsSub.length, (index) {
                            ProductDetails product = model.productDetailsSub[index];

                            return Flexible(
                              child: Card(
                                child: Container(
                                  height: 60,
                                  child: InkWell(
                                    onTap: () {
                                      showBottomSheet(product, () async {
                                        await model.purchaseProduct(product);
                                      });
                                    },
                                    borderRadius: BorderRadius.circular(4),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                          child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            product.skuDetail.title.split('(Daily Designs)')[0],
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${product.skuDetail.price} / ${product.skuDetail.subscriptionPeriod == 'P1M' ? 'Month' : 'Year'}',
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Flexible(
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Add ons'),
                              )),
                        ),
                        Flexible(
                            child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                child: ListView(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  children: List.generate(model.productDetailsAddons.length, (index) {
                                    ProductDetails product = model.productDetailsAddons[index];

                                    return Card(
                                      child: Container(
                                        height: 60,
                                        width: 100,
                                        child: InkWell(
                                          onTap: () {
                                            showBottomSheet(product, () async {
                                              await model.purchaseProduct(product);
                                            });
                                          },
                                          borderRadius: BorderRadius.circular(4),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Center(
                                                child: Column(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  product.skuDetail.title.split('(Daily Designs)')[0],
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  product.skuDetail.price,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                  // [
                                  //   Card(
                                  //     child: Container(
                                  //       height: 60,
                                  //       child: InkWell(
                                  //         onTap: () {},
                                  //         borderRadius: BorderRadius.circular(4),
                                  //         child: Padding(
                                  //           padding: const EdgeInsets.all(8.0),
                                  //           child: Center(
                                  //               child: Text(
                                  //             '10 Extra Credits',
                                  //             textAlign: TextAlign.center,
                                  //           )),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ],
                                ))),
                      ],
                    ),
                  ),
          ),
        ),
      ),
      viewModelBuilder: () => PlansViewModel(),
    );
  }

  showBottomSheet(ProductDetails product, Function callback) async {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      enableDrag: true,
      builder: (context) => Container(
        height: 250,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    product.title,
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                product.description,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Amount',
                  textAlign: TextAlign.center,
                ),
                Text(
                  product.skuDetail.price,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
            ),
            FlatButton(
              height: 40,
              minWidth: MediaQuery.of(context).size.width,
              onPressed: () async {
                await callback();
                // model.goToProfile();
              },
              textColor: Color(0xff2F4858),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: Color(0xffe6eaed),
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
