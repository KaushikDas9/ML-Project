import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mlproject/Config/Api/all_api.dart';

class CDNS3Service {
  Future<String> uploadFileToS3( File file ) async {

    var client = http.Client();
    try {

      var request = http.MultipartRequest(
      'POST',
      Uri.parse(AllApis.uploadToCDN),
    );


     request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        // contentType: MediaType('image', 'png'),
      ),
    );


    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      return responseData["data"].split("?").first as String;
    } else {
      throw Exception("Failed to upload file: ${response.body}");
    }

    } finally {
      client.close();
    }

  }



}
