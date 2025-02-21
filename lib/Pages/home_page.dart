import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mlproject/Service/Gpt/chat_gpt_service.dart';
import 'package:mlproject/Service/Image-Picker/image_pick.dart';
import 'package:mlproject/Service/s3/cdn_s3.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? cameraImageFile = "";
  String? preSignedUrlOfImage = "";
  String? chatGptResponse = "";
  bool isAnalyzing = false;
  bool isAnalyzingLoadingComplete = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "AI Image Analyzer",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: Colors.blueAccent.shade700, width: 1),
                ),
                margin: EdgeInsets.symmetric(
                    horizontal: width * 0.05, vertical: height * 0.03),
                width: width,
                height: height / 2.5,
                child: cameraImageFile != ""
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(cameraImageFile!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Center(child: Text("No image selected")),
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

                        preSignedUrlOfImage = await CDNS3Service()
                            .uploadFileToS3(File(imagePath!));

                        setState(() {
                          cameraImageFile = imagePath;
                        });
                        debugPrint(cameraImageFile);
                        debugPrint(preSignedUrlOfImage);
                      },
                      child: const Text("Capture Camera"),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String? imagePath =
                            await ImagePickerService().getImageFromGallery();

                        preSignedUrlOfImage = await CDNS3Service()
                            .uploadFileToS3(File(imagePath!));

                        setState(() {
                          cameraImageFile = imagePath;
                        });
                        debugPrint("pre: $preSignedUrlOfImage");
                        debugPrint("Capture Gallery");
                      },
                      child: const Text("Capture Gallery"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (preSignedUrlOfImage != "")
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isAnalyzingLoadingComplete = true;
                        });
                        String text = await ChatGptService()
                            .getChatGptResponse(preSignedUrlOfImage!);
                        setState(() {
                          chatGptResponse = text;
                          isAnalyzing = true;
                          isAnalyzingLoadingComplete = false;
                        });
                      },
                      child: isAnalyzingLoadingComplete
                          ? CircularProgressIndicator(color: Colors.blue, strokeWidth: 2 ) 
                          : Text("Analyze"),
                    )
                ],
              ),
              if (isAnalyzing)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: Colors.blueAccent.shade700, width: 1),
                  ),
                  margin: EdgeInsets.symmetric(
                      horizontal: width * 0.05, vertical: height * 0.03),
                  width: width,
                  padding: EdgeInsets.all(height * 0.03),
                  child: Text(chatGptResponse ?? "Loading..."),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
