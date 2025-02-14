import 'dart:convert';

import 'package:self_management/common/logging.dart';
import 'package:self_management/core/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:self_management/data/models/mood_model.dart';

class MoodRemoteDataSource {
  static Future<(bool, String)> add(MoodModel mood) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/moods/add.php');

    try {
      final response = await http.post(
        url,
        body: mood.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "MoodRemoteDataSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, Map?)> analyticToday(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/moods/analytic.php');
    DateTime now = DateTime.now();
    String startDate = DateFormat('yyyy-MM-dd').format(
      DateTime(now.year, now.month, now.day),
    );

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'created_at': startDate,
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        return (true, message, data);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "MoodRemoteDataSource - analytic today",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, Map?)> analyticLastMonth(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/moods/analytic.php');
    DateTime now = DateTime.now();
    String startDate = DateFormat('yyyy-MM-dd').format(
      DateTime(now.year, now.month, 1),
    );

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'created_at': startDate,
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        return (true, message, data);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "MoodRemoteDataSource - analytic last month",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<MoodModel>?)> today(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/moods/today.php');
    DateTime now = DateTime.now();
    String startDate = DateFormat('yyyy-MM-dd').format(
      DateTime(now.year, now.month, now.day),
    );

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'created_at': startDate,
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        List moodsRaw = data['moods'];
        List<MoodModel> moods = moodsRaw
            .map(
              (e) => MoodModel.fromJson(e),
            )
            .toList();
        return (true, message, moods);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "MoodRemoteDataSource - today",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }
}
