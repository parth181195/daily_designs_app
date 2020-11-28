import 'package:daily_design/core/locator.dart';
import 'package:daily_design/core/router.gr.dart';
import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/ui/views/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
                    _navigationService.navigateTo(Routes.profileView);
                  }),
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    await model.logout();
                  })
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
                          'Categories',
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
                height: 50,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    CategoryModel category = model.categories[index];
                    return Container(
                      width: 160,
                      height: 120,
                      child: Card(
//                      elevation: 5,
                        child: InkWell(
                          onTap: () {
                            model.filter(category);
                          },
                          child: Center(
                            child: Text(category.name),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: model.categories.length,
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
                crossAxisCount: 2,
                crossAxisSpacing: 5,
                mainAxisSpacing: 5,
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
              )
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
            child: FutureBuilder<Object>(
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
                }),
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
