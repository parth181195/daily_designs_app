import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_editor/image_editor.dart' as iEditor;
import 'package:image_picker/image_picker.dart';
import 'package:stacked/stacked.dart';
import 'package:daily_design/ui/views/logo_settings/logo_settings_view_model.dart';

class LogoSettingsView extends StatefulWidget {
  @override
  _LogoSettingsViewState createState() => _LogoSettingsViewState();
}

class _LogoSettingsViewState extends State<LogoSettingsView> {
  GlobalKey<ExtendedImageEditorState> editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LogoSettingsViewModel>.reactive(
        onModelReady: (m) async {
          await m.init();
        },
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Flex(
                      direction: Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          width: 240,
                          height: 240,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: GestureDetector(
                                onTap: () async {
                                  try {
                                    PickedFile pickedFile = await ImagePicker()
                                        .getImage(source: ImageSource.gallery, maxHeight: 300, maxWidth: 300);
                                    if (pickedFile != null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text(
                                              'Crop Logo',
                                              style: TextStyle(),
                                            ),
                                            actions: [
                                              FlatButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.pop(context, null);
                                                },
                                              ),
                                              FlatButton(
                                                child: Text('Apply'),
                                                onPressed: () {
                                                  cropImageDataWithNativeLibrary(
                                                          state: editorKey.currentState, filePath: pickedFile.path)
                                                      .then((value) {
                                                    Navigator.pop(context, Uint8List.fromList(value));
                                                  });
                                                },
                                              )
                                            ],
                                            backgroundColor: Colors.white,
                                            contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                                            content: Container(
                                              height: 500,
                                              child: ExtendedImage.file(
                                                File(pickedFile.path),
                                                alignment: Alignment.center,
                                                fit: BoxFit.contain,
                                                mode: ExtendedImageMode.editor,
                                                extendedImageEditorKey: editorKey,
                                                // color: Colors.white,
                                                initEditorConfigHandler: (state) {
                                                  return EditorConfig(
                                                    maxScale: 8.0,
                                                    lineColor: Colors.black,
                                                    cropRectPadding: EdgeInsets.all(20.0),
                                                    hitTestSize: 20.0,
                                                    editorMaskColorHandler: (context, pointerDown) =>
                                                        Colors.white.withOpacity(pointerDown ? 0.3 : 0.8),
                                                  );
                                                },
                                                shape: BoxShape.rectangle,
                                                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              ),
                                            ),
                                          );
                                        },
                                      ).then((val) {
                                        if (val != null) {
                                          model.logoUrl = val;
                                          setState(() {});
                                          print(val);
                                        }
                                      });
                                    }
                                  } catch (e) {}
                                  // await model.uploadImage(pickedFile);
                                },
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 190,
                                        height: 190,
                                        child: Center(
                                          child: Text((model.logoUrl != null) ? '' : 'Upload Logo'),
                                        ),
                                        decoration: BoxDecoration(
                                            image: model.logoUrl != null
                                                ? DecorationImage(image: MemoryImage(model.logoUrl), fit: BoxFit.cover)
                                                : null,
                                            borderRadius: BorderRadius.circular(100)),
                                        // child:,
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: Container(
                                        width: 220,
                                        height: 220,
                                        // child: Text(
                                        //     (model.logoUrl != null && model.logoUrl != '') ? '' : 'Upload Logo'),

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(100),
                                            border: Border.all(color: Color(0xff2F4858))),
                                        // child:,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: !model.busy('file_upload')
                                ? () async {
                                    await model.uploadImage();
                                  }
                                : null,
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: !model.busy('file_upload') ? Color(0xffe6eaed) : Color(0xffe6eaed),
                            child: !model.busy('file_upload')
                                ? Text('Update Logo')
                                : CircularProgressIndicator(
                                    strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.loose,
                          child: FlatButton(
                            padding: EdgeInsets.zero,
                            height: 60,
                            minWidth: MediaQuery.of(context).size.width,
                            onPressed: !model.busy('file_remove')
                                ? () async {
                                    await model.removeImage();
                                  }
                                : null,
                            textColor: Color(0xff2F4858),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            color: !model.busy('file_remove') ? Color(0xffe6eaed) : Color(0xffe6eaed),
                            child: !model.busy('file_remove')
                                ? Text('Use name as logo')
                                : CircularProgressIndicator(
                                    strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858))),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                        ),
                        // Flexible(
                        //   flex: 1,
                        //   fit: FlexFit.loose,
                        //   child: FlatButton(
                        //     padding: EdgeInsets.zero,
                        //     height: 60,
                        //     minWidth: MediaQuery.of(context).size.width,
                        //     onPressed: !model.busy('file_remove')
                        //         ? () async {
                        //             await model.removeImage();
                        //           }
                        //         : null,
                        //     textColor: Color(0xff2F4858),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        //     color: !model.busy('file_remove') ? Color(0xffe6eaed) : Color(0xffe6eaed),
                        //     child: !model.busy('file_remove')
                        //         ? Text('Refine Logo')
                        //         : CircularProgressIndicator(
                        //             strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858))),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: EdgeInsets.all(8.0),
                        // ),
                        // Flexible(
                        //   flex: 1,
                        //   fit: FlexFit.loose,
                        //   child: FlatButton(
                        //     padding: EdgeInsets.zero,
                        //     height: 60,
                        //     minWidth: MediaQuery.of(context).size.width,
                        //     onPressed: !model.busy('file_remove')
                        //         ? () async {
                        //             await model.removeImage();
                        //           }
                        //         : null,
                        //     textColor: Color(0xff2F4858),
                        //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        //     color: !model.busy('file_remove') ? Color(0xffe6eaed) : Color(0xffe6eaed),
                        //     child: !model.busy('file_remove')
                        //         ? Text('Request Logo Design')
                        //         : CircularProgressIndicator(
                        //             strokeWidth: 1, valueColor: AlwaysStoppedAnimation(Color(0xff2F4858))),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        viewModelBuilder: () => LogoSettingsViewModel());
  }

  Future<List<int>> cropImageDataWithNativeLibrary(
      {@required ExtendedImageEditorState state, @required String filePath}) async {
    print('native library start cropping');

    final Rect cropRect = state.getCropRect();
    final EditActionDetails action = state.editAction;
    //
    // final int rotateAngle = action.rotateAngle.toInt();
    // final bool flipHorizontal = action.flipY;
    // final bool flipVertical = action.flipX;
    final Uint8List img = File(filePath).readAsBytesSync();
    //
    final iEditor.ImageEditorOption option = iEditor.ImageEditorOption();
    //
    if (action.needCrop) {
      option.addOption(iEditor.ClipOption.fromRect(cropRect));
    }
    option.outputFormat = iEditor.OutputFormat.png();

    final Uint8List result = await iEditor.ImageEditor.editImage(
      image: img,
      imageEditorOption: option,
    );
    return result;
  }
}
