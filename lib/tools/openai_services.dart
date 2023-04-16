import 'dart:convert';

import 'package:http/http.dart' as http;

String apiKey = "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";

Future sendTextCompletionRequest(String message) async {
  String baseUrl = "https://api.openai.com/v1/completions";
  Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $apiKey"
  };
  var res = await http.post(Uri.parse(baseUrl),
      headers: headers,
      body: json.encode({
        "model": "text-davinci-003",
        "prompt": message,
        "max_tokens": 100,
        "temperature": 0,
        "top_p": 1,
        "n": 1,
        "stream": false,
        "logprobs": null,

      }));
  if (res.statusCode == 200) {
    return jsonDecode(res.body);
  }
}