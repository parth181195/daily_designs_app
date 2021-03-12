import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:daily_design/models/frame_model.dart';
import 'package:daily_design/models/graphics_model.dart';
import 'package:daily_design/ui/views/frame/frame_view_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_media_store/flutter_media_store.dart';

// import 'package:media_store/media_store.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class FramesView extends StatefulWidget {
  final FrameModel frameModel;
  final GraphicsModel graphicsModel;

  const FramesView({Key key, this.frameModel, this.graphicsModel}) : super(key: key);

  @override
  _FramesViewState createState() => _FramesViewState();
}

class _FramesViewState extends State<FramesView> {
  ScreenshotController screenshotController = ScreenshotController();

  FirebaseStorage storage = FirebaseStorage.instance;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  Future<String> getStorageDirectory() async {
    if (Platform.isAndroid) {
      return (await getExternalStorageDirectory()).path; // OR return "/storage/emulated/0/Download";
    } else {
      return (await getApplicationDocumentsDirectory()).path;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FrameViewModel>.reactive(
      viewModelBuilder: () => FrameViewModel(),
      onModelReady: (m) async {
        m.getFrames(
          frameModel: widget.frameModel,
          graphicsModel: widget.graphicsModel,
        );
      },
      builder: (context, model, child) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          actions: [
            IconButton(
                icon: Icon(Icons.share),
                onPressed: () async {
                  if (int.parse(model.userStatic.remainingGraphics) > 0) {
                    DialogResponse res = await model.showFinishDiag(widget.graphicsModel.credits);
                    if (res != null) {
                      if (res.confirmed) {
                        var img = await screenshotController.capture(
                          pixelRatio: 4,
                        );
                        Share.shareFiles([img.path]).then((value) async {
                          await model.reduceCredits(widget.graphicsModel.credits);
                        });
                        setState(() {});
                      }
                    }
                  } else {
                    model.showTrialFinishDiag();
                  }
                }),
            LayoutBuilder(
              builder: (context, constraints) => IconButton(
                  icon: Icon(Icons.download_rounded),
                  onPressed: () async {
                    ByteData img = await (await screenshotController.captureAsUiImage(
                      pixelRatio: 4,
                    ))
                        .toByteData(format: ui.ImageByteFormat.png);
                    if (Platform.isAndroid) {
                      PermissionStatus status = await Permission.mediaLibrary.request();
                      PermissionStatus status1 = await Permission.storage.request();
                      if (status.isGranted && status1.isGranted) {
                        if (int.parse(model.userStatic.remainingGraphics) > 0) {
                          DialogResponse res = await model.showFinishDiag(widget.graphicsModel.credits);
                          if (res != null) {
                            if (res.confirmed) {
                              // Directory directory = new Directory("/storage/emulated/0/Pictures");
                              var dirs = await getExternalStorageDirectories();
                              Directory directory = await getExternalStorageDirectory();
                              if ((await directory.exists()) != true) {
                                await directory.create();
                              }
                              File file = new File('${directory.path}/${DateTime.now().microsecondsSinceEpoch}.png');

                              final buffer = img.buffer;
                              // var newFile =
                              //     await file.writeAsBytes(buffer.asUint8List(img.offsetInBytes, img.lengthInBytes));
                              if (int.parse(model.userStatic.remainingGraphics) > 0) {
                                await MediaStore.brodcastImage(buffer.asUint8List(img.offsetInBytes, img.lengthInBytes))
                                    .then((value) async {
                                  print(value);
                                  await model.reduceCredits(widget.graphicsModel.credits);
                                  Scaffold.of(context).showSnackBar(SnackBar(content: Text('image downloaded')));
                                });
                              }
                              // newFile.create().then((value) async {
                              // });
                              setState(() {});
                            }
                          }
                        } else {
                          model.showTrialFinishDiag();
                        }
                      }
                    }
                  }),
            ),
          ],
          backgroundColor: Colors.white,
          elevation: 10,
          iconTheme: IconThemeData().copyWith(color: Colors.black),
          shadowColor: Color(0xff2F4858).withOpacity(0.1),
          title: Row(
            children: [
              Text(
                'Design',
                style: TextStyle(fontFamily: GoogleFonts.montserrat().fontFamily, color: Color(0xfff00104)),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 200 - kToolbarHeight,
              child: Center(
                child: Screenshot(
                  controller: screenshotController,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        if (model.image.isNotEmpty)
                          Image.memory(
                            model.image,
                            height: MediaQuery.of(context).size.width,
                            fit: BoxFit.cover,
                          ),
                        if (model.frame.isNotEmpty) Image.memory(model.frame),
                        if (model.isBusy)
                          Align(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                  strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858)))),
                        if (!model.useName)
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                // color: Colors.red,
                                height: 50,
                                width: 120,
                                child: Center(
                                  child: Image.memory(
                                    model.logo,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            top: 0,
                            right: 0,
                          ),
                        if (model.useName)
                          Positioned(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                // color: Colors.red,
                                height: 50,
                                width: 120,
                                child: Center(
                                  child: Text(
                                    model.userStatic.companyName != null ? model.userStatic.companyName : '',
                                    style: TextStyle(
                                      color: !model.frames[model.activeFrame].isDark ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            top: 0,
                            right: 0,
                          ),
                        if (!model.isBusy)
                          Positioned(
                            child: Container(
                              // color: Colors.red,
                              height: 16,
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.green,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  if (model.user.email != null)
                                    Text(
                                      model.user.email,
                                      style: TextStyle(
                                          color: !model.frames[model.activeFrame].isDark ? Colors.white : Colors.black,
                                          fontSize: 10),
                                    ),
                                  if (model.userStatic.mobile != null)
                                    Text(
                                      model.userStatic.mobile != null ? model.userStatic.mobile : '',
                                      style: TextStyle(
                                          color: !model.frames[model.activeFrame].isDark ? Colors.white : Colors.black,
                                          fontSize: 10),
                                    ),
                                  if (model.userStatic.website != null)
                                    Text(
                                      model.userStatic.website != null ? model.userStatic.website : '',
                                      style: TextStyle(
                                          color: !model.frames[model.activeFrame].isDark ? Colors.white : Colors.black,
                                          fontSize: 10),
                                    )
                                ],
                              )),
                            ),
                            bottom: 20.5,
                            right: 0,
                          ),
                        if (!model.isBusy)
                          Positioned(
                            child: Container(
                              // color: Colors.redAccent,
                              height: 16,
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.green,
                              child: Center(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    model.userStatic.address != null ? model.userStatic.address : '',
                                    style: TextStyle(
                                        color: !model.frames[model.activeFrame].isDark ? Colors.white : Colors.black,
                                        fontSize: 10),
                                  ),
                                ],
                              )),
                            ),
                            bottom: 5,
                            right: 0,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              child: Divider(
                height: 1,
                thickness: 1,
              ),
              width: MediaQuery.of(context).size.width,
              height: 1,
              bottom: 202,
            ),
            Positioned(
              child: Center(child: Text('Select Frame')),
              width: MediaQuery.of(context).size.width,
              // height: 1,
              bottom: 214,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                width: MediaQuery.of(context).size.width,
                // color: Colors.red,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: model.frames.length,
                  itemBuilder: (context, index) {
                    FrameModel data = model.frames[index];
                    return FrameCard(
                      storage: storage,
                      data: data,
                      active: index == model.activeFrame,
                      onTap: () async {
                        model.changeSelectedFrame(data, index);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class FrameCard extends StatelessWidget {
  final VoidCallback onTap;
  final bool active;

  const FrameCard({
    Key key,
    @required this.storage,
    @required this.data,
    this.onTap,
    this.active,
  }) : super(key: key);

  final FirebaseStorage storage;
  final FrameModel data;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(border: active ? Border.all(color: Color(0xff2F4858)) : null),
        height: 180,
        width: 180,
        child: Card(
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    // height: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.black.withOpacity(0), Colors.black38])),
                  )),
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
                          base64Decode((data.bytes.replaceAll('data:image/png;base64,', ''))),
                          fit: BoxFit.cover,
                          height: double.maxFinite,
                          width: double.maxFinite,
                        ),
                      ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '',
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
        ),
      ),
    );
  }
}

class CustomMediaStore {
  static const MethodChannel _channel = const MethodChannel('com.blackposition.dailydesigns/media_store');

  /// save image to Gallery
  /// imageBytes can't null
  static Future saveImage(Uint8List imageBytes) async {
    assert(imageBytes != null);
    final result = await _channel.invokeMethod('saveImageToGallery', imageBytes);
    return result;
  }

  /// Save the PNG，JPG，JPEG image or video located at [file] to the local device media gallery.
  static Future saveFile(String file) async {
    assert(file != null);
    final result = await _channel.invokeMethod('saveFileToGallery', file);
    return result;
  }
}
