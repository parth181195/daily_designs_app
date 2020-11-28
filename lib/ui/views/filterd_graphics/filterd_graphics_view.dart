import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/ui/views/filterd_graphics/filterd_graphics_model.dart';
import 'package:daily_design/ui/views/home/home_view.dart';
import 'package:daily_design/ui/views/top_graphics/top_graphics_view_model.dart';
import 'package:daily_design/ui/views/top_graphics/top_graphics_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class FilteredGraphicsView extends StatefulWidget {
  final CategoryModel categoryModel;

  FilteredGraphicsView({Key key, this.categoryModel}) : super(key: key);

  @override
  _FilteredGraphicsViewState createState() => _FilteredGraphicsViewState();
}

class _FilteredGraphicsViewState extends State<FilteredGraphicsView> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FilteredGraphicsViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 10,
            iconTheme: IconThemeData().copyWith(color: Colors.black),
            shadowColor: Color(0xff2F4858).withOpacity(0.1),
            title: Row(
              children: [
                Text(
                  widget.categoryModel.name + ' Graphics',
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
      viewModelBuilder: () => FilteredGraphicsViewModel(),
      onModelReady: (m) => m.init(widget.categoryModel),
    );
  }
}
