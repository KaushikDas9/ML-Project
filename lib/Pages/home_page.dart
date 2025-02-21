import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mlproject/Service/Image-Picker/image_pick.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? cameraImageFile = "";
  String? _cameraGalleryFile = "";

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              // color: Colors.amber,
              width: width,
              height: height / 2,
              child: cameraImageFile != ""
                  ? Image.file(
                      File(cameraImageFile!),
                    )
                  : const Text("No image selected"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: height * 0.03),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () async {
                          String? imagePath =
                              await ImagePickerService().getImageFromCamera();
                          setState(() {
                            cameraImageFile = imagePath;
                          });
                          debugPrint(cameraImageFile);
                        },
                        child: const Text("Capture Camera")),
                    ElevatedButton(
                        onPressed: () async {
                          String? imagePath =
                              await ImagePickerService().getImageFromGallery();
                          setState(() {
                            imagePath = _cameraGalleryFile;
                          });

                          debugPrint("Capture Gallery");
                        },
                        child: const Text("Capture Gallery")),
                    // ElevatedButton(
                    //     onPressed: () async {
                    //       // String? file =
                    //       //   await ImagePickerService().getImageFromGallery();
                    //         debugPrint("analyze");
                    //     },
                    //     child: const Text("analyze")),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
