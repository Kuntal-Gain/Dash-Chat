// ignore_for_file: no_wildcard_variable_uses

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final url =
      "https://kuntal06-black-forest-labs-flux-1-dev.hf.space/gradio_api/call/predict";

  Future<String?> getEventId(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "data": [prompt]
        }),
      );

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);
        String eventId = res["event_id"];

        return eventId;
      }
    } catch (_) {
      if (kDebugMode) {
        print(_.toString());
      }
    }
    return null;
  }

  Future<String?> generateImage(String eventId) async {
    try {
      final response = await http.get(
        Uri.parse("$url/$eventId"),
        headers: {"Content-Type": "application/json"},
      );

      // Print the raw response for debugging
      if (kDebugMode) {
        print("Raw Response: ${response.body}");
      }

      // Use RegExp to find the URL in the response body
      final RegExp regExp = RegExp(r'"url":\s?"(https://[^"]+)"');
      final match = regExp.firstMatch(response.body);

      if (match != null) {
        // Extract the image URL
        String imageUrl = match.group(1)!;

        // Remove "/g/" from the URL if it's present
        imageUrl = imageUrl.replaceAll("/g/", "/");

        return imageUrl;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error: $e");
      }
    }

    return null;
  }
}
