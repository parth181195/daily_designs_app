import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/ui/views/home/home_view.dart';
import 'package:daily_design/ui/views/top_graphics/top_graphics_view_model.dart';
import 'package:daily_design/ui/views/top_graphics/top_graphics_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class TopGraphicsView extends StatefulWidget {
  TopGraphicsView({Key key}) : super(key: key);

  @override
  _TopGraphicsViewState createState() => _TopGraphicsViewState();
}

class _TopGraphicsViewState extends State<TopGraphicsView> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TopGraphicsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 10,
            iconTheme: IconThemeData().copyWith(color: Colors.black),
            shadowColor: Color(0xff2F4858).withOpacity(0.1),
            title: Row(
              children: [
                Text(
                  'Graphics',
                  style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily, color: Color(0xff2F4858)),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: [
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
          )),
      viewModelBuilder: () => TopGraphicsViewModel(),
      onModelReady: (m) => m.init(),
    );
  }
}
