import 'dart:convert';

import 'package:self_management/data/models/income_model.dart';

import '../../common/logging.dart';
import '../../core/api.dart';
import 'package:http/http.dart' as http;

class IncomeRemoteDateSource {
  static Future<(bool, String)> add(IncomeModel income) async {
    Uri url = Uri.parse('${API.baseUrl}/api/incomes/add.php');

    try {
      final response = await http.post(
        url,
        body: income.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "IncomeRemoteDateSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, List<IncomeModel>?)> all(int userId) async {
    Uri url = Uri.parse('${API.baseUrl}/api/incomes/all.php');
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
        List incomesRaw = data['incomes'];
        List<IncomeModel> incomes = incomesRaw
            .map(
              (e) => IncomeModel.fromJson(e),
            )
            .toList();
        return (true, message, incomes);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "IncomeRemoteDateSource - all",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> delete(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/incomes/delete.php');
    try {
      final response = await http.post(
        url,
        body: {
          'id': id.toString(),
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 200;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "IncomeRemoteDateSource - delete",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, IncomeModel?)> detail(int id) async {
    Uri url = Uri.parse('${API.baseUrl}/api/incomes/detail.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        IncomeModel income =
            IncomeModel.fromJson(Map<String, dynamic>.from(resBody['data']));
        return (true, message, income);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "IncomeRemoteDateSource - detail",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<IncomeModel>?)> today(int userId) async {
    Uri url = Uri.parse('${API.baseUrl}/api/incomes/today.php');
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
        List incomesRaw = data['incomes'];
        List<IncomeModel> incomes = incomesRaw
            .map(
              (e) => IncomeModel.fromJson(e),
            )
            .toList();
        return (true, message, incomes);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "IncomeRemoteDateSource - today",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }
}
