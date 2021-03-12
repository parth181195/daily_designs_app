import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/models/industry_model.dart';
import 'package:daily_design/ui/views/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'dart:convert';
import 'dart:typed_data';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  FirebaseStorage storage = FirebaseStorage.instance;
  NavigationService _navigationService = locator<NavigationService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onModelReady: (m) => m.init(),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    _navigationService.navigateTo(Routes.settingsView);
                  }),
              // IconButton(
              //     icon: Icon(Icons.exit_to_app),
              //     onPressed: () async {
              //       await model.logout();
              //     })
            ],
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
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 200.0,
                  child: TransformerPageView(
                    physics: BouncingScrollPhysics(),
                    // loop: true,
                    duration: Duration(seconds: 5),
                    pageSnapping: true,
                    viewportFraction: 0.1,
                    transformer: AccordionTransformer(),
                    scrollDirection: Axis.horizontal,
                    itemCount: model.featuredAds.length,
                    itemBuilder: (context, index) {
                      var ad = model.featuredAds[index];
                      return GestureDetector(
                        onTap: () {
                          model.filterWithCatId(ad.category);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FutureBuilder(
                              future: storage.ref(ad.path).getDownloadURL(),
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      snapshot.data,
                                      fit: BoxFit.cover,
                                      height: double.maxFinite,
                                      width: double.maxFinite,
                                    ),
                                  );
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858))),
                                  );
                                }
                              }),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    model.goToCategories();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Festivals',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                height: 120,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    CategoryModel category = model.getFestivalCategories()[index];
                    return CategoryCard(
                      category: category,
                      callBack: () {
                        model.filter(category);
                      },
                    );
                  },
                  itemCount: model.getFestivalCategories().length,
                ),
              )),
              // SliverToBoxAdapter(
              //   child: GestureDetector(
              //     onTap: () {
              //       model.goToCategories();
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'All Categories',
              //             style: TextStyle(fontSize: 18),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios,
              //             size: 15,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // SliverToBoxAdapter(
              //     child: Container(
              //   height: 120,
              //   child: ListView.builder(
              //     physics: BouncingScrollPhysics(),
              //     scrollDirection: Axis.horizontal,
              //     itemBuilder: (context, index) {
              //       CategoryModel category = model.categories[index];
              //       return CategoryCard(
              //         category: category,
              //         callBack: () {
              //           model.filter(category);
              //         },
              //       );
              //     },
              //     itemCount: model.categories.length,
              //   ),
              // )),
              // SliverToBoxAdapter(
              //   child: GestureDetector(
              //     onTap: () {
              //       model.goToCategories();
              //     },
              //     child: Padding(
              //       padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text(
              //             'All Categories',
              //             style: TextStyle(fontSize: 18),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_ios,
              //             size: 15,
              //           )
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              // if (model.userIndustry != null)
              // SliverToBoxAdapter(
              //   child: Container(
              //     height: 60,
              //     child: Flex(
              //       direction: Axis.horizontal,
              //       children: [
              //         IndustryCard(
              //           industry: model.userIndustry,
              //           callBack: () {
              //             // model.filter(model.userIndustry);
              //           },
              //         ),
              //         Container(
              //           width: MediaQuery.of(context).size.width * 0.4,
              //           // height: lowHeight ? 60 : 90,
              //           child: Card(
              //             elevation: 2,
              //             child: ClipRRect(
              //               borderRadius: BorderRadius.circular(4),
              //               child: InkWell(
              //                 onTap: () {
              //                   model.filter(model.categories.where((element) => element.slug == 'business').first);
              //                 },
              //                 child:
              //                     model.categories.where((element) => element.slug == 'business').first.bytes != null
              //                         ? Image.memory(
              //                             base64Decode((model.categories
              //                                 .where((element) => element.slug == 'business')
              //                                 .first
              //                                 .bytes
              //                                 .replaceAll('data:image/png;base64,', ''))),
              //                             fit: BoxFit.contain,
              //                           )
              //                         : Container(),
              //               ),
              //             ),
              //           ),
              //         )
              //         // CategoryCard(
              //         //   lowHeight: true,
              //         //   category: model.categories.where((element) => element.slug == 'business').first,
              //         //   callBack: () {
              //         //     model.filter(model.categories.where((element) => element.slug == 'business').first);
              //         //   },
              //         // )
              //       ],
              //     ),
              //   ),
              //   //   child: ListView.builder(
              //   //     physics: BouncingScrollPhysics(),
              //   //     scrollDirection: Axis.horizontal,
              //   //     itemBuilder: (context, index) {
              //   //       IndustryModel category = [model.userIndustry][index];
              //   //       return IndustryCard(
              //   //         industry: category,
              //   //         callBack: () {
              //   //           // model.filter(category);
              //   //         },
              //   //       );
              //   //     },
              //   //     itemCount: [model.userIndustry].length,
              // ),
              // )),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    model.goToCategories();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daily Graphics',
                          style: TextStyle(fontSize: 18),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child: Container(
                height: 120,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    CategoryModel category = model.getGeneralCategories()[index];
                    return CategoryCard(
                      category: category,
                      callBack: () {
                        model.filter(category);
                      },
                    );
                  },
                  itemCount: model.getGeneralCategories().length,
                ),
              )),
              SliverToBoxAdapter(
                child: InkWell(
                  onTap: () {
                    model.goToGraphics();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Graphics',
                            style: TextStyle(fontSize: 18),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SliverGrid.count(
                childAspectRatio: 1,
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
                children: List.generate(
                  model.featuredPosts.length,
                  (index) {
                    GraphicsModel data = model.featuredPosts[index];
                    return GraphicCard(
                      storage: storage,
                      data: data,
                      onTap: () {
                        model.goToFrameSelection(data);
                      },
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: GestureDetector(
                  onTap: () {
                    model.goToCategories();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    child: Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: RaisedButton(
                            color: Colors.white,
                            child: Text('All Graphics'),
                            onPressed: () {
                              model.goToGraphics();
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                        ),
                        Flexible(
                          child: RaisedButton(
                            child: Text('All Categories'),
                            color: Colors.white,
                            onPressed: () {
                              model.goToCategories();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
          )),
    );
  }
}

class GraphicCard extends StatelessWidget {
  final VoidCallback onTap;

  const GraphicCard({
    Key key,
    @required this.storage,
    @required this.data,
    this.onTap,
  }) : super(key: key);

  final FirebaseStorage storage;
  final GraphicsModel data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: data.bytes == null
                ? FutureBuilder<Object>(
                    future: storage.ref(data.path).getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            snapshot.data,
                            fit: BoxFit.cover,
                            height: double.maxFinite,
                            width: double.maxFinite,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator(
                            strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)));
                      }
                    })
                : ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.memory(
                      base64Decode((data.bytes.replaceAll('data:image/jpeg;base64,', ''))),
                      fit: BoxFit.cover,
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                  ),
          ),
          Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0), Colors.black38])),
              )),
          // Align(
          InkWell(
            onTap: onTap,
            child: Center(
              child: Container(),
            ),
          )
        ],
      ),
    );
  }
}

class AccordionTransformer extends PageTransformer {
  @override
  Widget transform(Widget child, TransformInfo info) {
    double position = info.position;
    if (position < 0.0) {
      return new Transform.scale(
        scale: 1 + position,
        alignment: Alignment.topRight,
        child: child,
      );
    } else {
      return new Transform.scale(
        scale: 1 - position,
        alignment: Alignment.bottomLeft,
        child: child,
      );
    }
  }
}

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final Function callBack;
  final bool lowHeight;

  const CategoryCard({
    Key key,
    this.category,
    this.callBack,
    this.lowHeight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: lowHeight ? null : 90,
      height: lowHeight ? 60 : 90,
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            onTap: () {
              callBack();
            },
            child: category.bytes != null
                ? Image.memory(
                    base64Decode((category.bytes.replaceAll('data:image/png;base64,', ''))),
                    fit: BoxFit.contain,
                  )
                : Container(),
          ),
        ),
      ),
    );
  }
}

class IndustryCard extends StatelessWidget {
  final IndustryModel industry;
  final Function callBack;

  const IndustryCard({
    Key key,
    this.industry,
    this.callBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 60,
          child: Card(
            elevation: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: InkWell(
                onTap: () {
                  callBack();
                },
                child: industry.bytes != null
                    ? Image.memory(
                        base64Decode((industry.bytes.replaceAll('data:image/png;base64,', ''))),
                        fit: BoxFit.cover,
                      )
                    : Container(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
