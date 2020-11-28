import 'package:daily_design/models/category_model.dart';
import 'package:daily_design/ui/views/categories/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class CategoriesView extends StatefulWidget {
  CategoriesView({Key key}) : super(key: key);

  @override
  _CategoriesViewState createState() => _CategoriesViewState();
}

class _CategoriesViewState extends State<CategoriesView> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CategoriesViewModel>.reactive(
      builder: (context, model, child) =>
          Scaffold(
            appBar: AppBar(
              actions: [
              ],
              backgroundColor: Colors.white,
              elevation: 10,
              iconTheme: IconThemeData().copyWith(color: Colors.black),
              shadowColor: Color(0xff2F4858).withOpacity(0.1),
              title: Row(
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(fontFamily: GoogleFonts
                        .montserrat()
                        .fontFamily, color: Color(0xff2F4858)),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.white,
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onChanged: (value) async {
                      model.search(value);
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                      filled: true,
                      focusColor: Color(0xffeeeeee),
                      hintText: 'Search For Categories',
                    ),
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      refreshKey.currentState.show(atTop: true);
                      model.search('');
                      return await model.init();
                    },
                    key: refreshKey,
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        CategoryModel category = model.categories[index];
                        return Container(
                          height: 60,
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
                  ),
                ),
              ],
            ),
          ),
      viewModelBuilder: () => CategoriesViewModel(),
      onModelReady: (m) => m.init(),
    );
  }
}
