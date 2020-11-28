import 'package:daily_design/models/frame_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/ui/views/frame_selection_view/frame_selection_view_model.dart';
import 'package:daily_design/ui/views/home/home_view.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stacked/stacked.dart';

class FrameSelectionView extends StatefulWidget {
  final GraphicsModel graphicsModel;

  const FrameSelectionView({Key key, this.graphicsModel}) : super(key: key);

  @override
  _FrameSelectionViewState createState() => _FrameSelectionViewState();
}

class _FrameSelectionViewState extends State<FrameSelectionView> {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FrameSelectionViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 10,
            iconTheme: IconThemeData().copyWith(color: Colors.black),
            shadowColor: Color(0xff2F4858).withOpacity(0.1),
            title: Row(
              children: [
                Text(
                  'Frames',
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
                  model.frames.length,
                  (index) {
                    FrameModel data = model.frames[index];
                    return FrameCard(
                      storage: storage,
                      data: data,
                      onTap: () {
                        model.goToFrame(widget.graphicsModel, data);
                      },
                    );
                  },
                ),
              )
            ],
          )),
      viewModelBuilder: () => FrameSelectionViewModel(),
      onModelReady: (m) => m.init(),
    );
  }
}

class FrameCard extends StatelessWidget {
  final VoidCallback onTap;

  const FrameCard({
    Key key,
    @required this.storage,
    @required this.data,
    this.onTap,
  }) : super(key: key);

  final FirebaseStorage storage;
  final FrameModel data;

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
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                data.name,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
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
