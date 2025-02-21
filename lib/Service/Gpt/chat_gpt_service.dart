import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mlproject/Config/Api/all_api.dart';

class ChatGptService {
  Future<String> getChatGptResponse(String imageUrl) async {
    try {
      Map<String, dynamic> message = {
        "model": "gpt-4o",
        "messages": [
          {
            "role": "user",
            "content": [
              {"type": "text", "text": "What's in this image?"},
              {
                "type": "image_url",
                "image_url": {"url": imageUrl}
              }
            ]
          }
        ],
        "max_tokens": 300,
      };

      http.Response res = await http.Client().post(
          Uri.parse(AllApis.downloadFromCDN),
          body: jsonEncode(message),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': '',
            'Cookie': '',
          }).timeout(Duration(seconds: 300));

      if (res.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(res.body);
        return responseData["choices"][0]["message"]["content"] as String;
      } else {
        throw Exception("Failed to upload file: ${res.body}");
      }
    } catch (e) {
      throw Exception("SomeThing went Wrong:+ ${e.toString()}");
    }
  }
}
