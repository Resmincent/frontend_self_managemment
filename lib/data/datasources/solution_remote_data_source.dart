import 'dart:convert';

import 'package:self_management/common/logging.dart';
import 'package:self_management/core/api.dart';
import 'package:http/http.dart' as http;
import 'package:self_management/data/models/solution_model.dart';

class SolutionRemoteDataSource {
  static Future<(bool, String)> add(SolutionModel solution) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/add.php');

    try {
      final response = await http.post(
        url,
        body: solution.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "SolutionRemoteDataSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, List<SolutionModel>?)> all(int userId) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/all.php');
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
        List solutionRaw = data['solutions'];
        List<SolutionModel> solutions = solutionRaw
            .map(
              (e) => SolutionModel.fromJson(e),
            )
            .toList();
        return (true, message, solutions);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "SolutionRemoteDataSource - all",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> delete(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/delete.php?id=$id');

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
        "SolutionRemoteDataSource - delete",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, SolutionModel?)> detail(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/detail.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        SolutionModel solution =
            SolutionModel.fromJson(Map<String, dynamic>.from(resBody['data']));
        return (true, message, solution);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "SolutionRemoteDataSource - detail",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<SolutionModel>?)> search(
      int userId, String query) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/search.php');
    try {
      final response = await http.post(
        url,
        body: {'user_id': userId.toString(), 'query': query},
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        List solutionRaw = data['solutions'];
        List<SolutionModel> solutions = solutionRaw
            .map(
              (e) => SolutionModel.fromJson(e),
            )
            .toList();
        return (true, message, solutions);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "SolutionRemoteDataSource - search",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> update(SolutionModel solution) async {
    Uri url = Uri.parse('${API.baseUrl}/api/solutions/update.php');

    try {
      final response = await http.post(
        url,
        body: solution.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 200;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "SolutionRemoteDataSource - update",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }
}
