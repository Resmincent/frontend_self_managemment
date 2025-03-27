import 'dart:convert';

import 'package:self_management/core/api.dart';
import 'package:self_management/data/models/safe_place_model.dart';
import 'package:http/http.dart' as http;

import '../../common/logging.dart';

class SafePlaceRemoteDataSource {
  static Future<(bool, String)> add(SafePlaceModel safePlace) async {
    Uri url = Uri.parse('${API.baseUrl}/api/safe-place/add.php');

    try {
      final response = await http.post(
        url,
        body: safePlace.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "SafePlaceRemoteDataSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, List<SafePlaceModel>?)> all(int userId) async {
    Uri url = Uri.parse('${API.baseUrl}/api/safe-place/all.php');
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        List safePlaceRaw = data['safe_places'];
        List<SafePlaceModel> safePlaces = safePlaceRaw
            .map(
              (e) => SafePlaceModel.fromJson(e),
            )
            .toList();
        return (true, message, safePlaces);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "SafePlaceRemoteDataSource - all",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> delete(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/safe-place/delete.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 200;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "SafePlaceRemoteDataSource - delete",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, SafePlaceModel?)> detail(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/safe-place/detail.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        SafePlaceModel solution =
            SafePlaceModel.fromJson(Map<String, dynamic>.from(resBody['data']));
        return (true, message, solution);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "SafePlaceRemoteDataSource - detail",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }
}
