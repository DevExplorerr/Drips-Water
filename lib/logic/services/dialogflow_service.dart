import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/services.dart' show rootBundle;

class DialogflowService {
  final _uuid = const Uuid();
  late String sessionId;
  late Map<String, dynamic> _credentials;
  late String _projectId;
  late AutoRefreshingAuthClient _client;

  Future<void> init() async {
    final credString = await rootBundle.loadString('assets/credentials.json');
    _credentials = json.decode(credString);
    _projectId = _credentials['project_id'];
    sessionId = _uuid.v4();

    const scopes = ['https://www.googleapis.com/auth/dialogflow'];

    final accountCredentials = ServiceAccountCredentials.fromJson(_credentials);
    _client = await clientViaServiceAccount(accountCredentials, scopes);
  }

  Future<String> sendMessage(String text) async {
    final url =
        'https://dialogflow.googleapis.com/v2/projects/$_projectId/agent/sessions/$sessionId:detectIntent';

    final body = {
      "queryInput": {
        "text": {"text": text, "languageCode": "en"},
      },
    };

    final response = await _client.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    final reply = data['queryResult']?['fulfillmentText'];

    if (reply == null || reply.isEmpty) {
      return "Sorry, I didn't understand that.";
    }

    return reply;
  }

  void dispose() {
    _client.close();
  }
}
