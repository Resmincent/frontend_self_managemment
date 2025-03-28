import 'dart:convert';

import 'package:self_management/core/api.dart';
import 'package:self_management/data/models/journal_model.dart';
import 'package:http/http.dart' as http;

import '../../common/logging.dart';

class JournalRemoteDataSource {
  static Future<(bool, String)> add(JournalModel journal) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/add.php');

    try {
      final response = await http.post(
        url,
        body: journal.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "JournalRemoteDataSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, List<JournalModel>?)> all(int userId) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/all.php');
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
        List journalRaw = data['journals'];
        List<JournalModel> journals = journalRaw
            .map(
              (e) => JournalModel.fromJson(e),
            )
            .toList();
        return (true, message, journals);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "JournalRemoteDataSource - all",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> delete(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/delete.php?id=$id');

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
        "JournalRemoteDataSource - delete",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, JournalModel?)> detail(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/detail.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        JournalModel solution =
            JournalModel.fromJson(Map<String, dynamic>.from(resBody['data']));
        return (true, message, solution);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "JournalRemoteDataSource - detail",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<JournalModel>?)> search(
      int userId, String query) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/search.php');
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
        List solutionRaw = data['journals'];
        List<JournalModel> solutions = solutionRaw
            .map(
              (e) => JournalModel.fromJson(e),
            )
            .toList();
        return (true, message, solutions);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "JournalRemoteDataSource - search",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> update(JournalModel journal) async {
    Uri url = Uri.parse('${API.baseUrl}/api/journals/update.php');

    try {
      final response = await http.post(
        url,
        body: journal.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 200;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "JournalRemoteDataSource - update",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }
}
