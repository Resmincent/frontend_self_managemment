import 'dart:convert';

import 'package:self_management/common/logging.dart';
import 'package:self_management/core/api.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:self_management/data/models/agenda_model.dart';
import 'package:self_management/data/models/expense_modal.dart';

class ExpenseRemoteDataSource {
  static Future<(bool, String)> add(ExpenseModal expense) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/add.php');

    try {
      final response = await http.post(
        url,
        body: expense.toJsonRequest(),
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];
      bool success = response.statusCode == 201;

      return (success, message);
    } catch (e) {
      fdLog.title(
        "ExpenseRemoteDataSource - add",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, List<ExpenseModal>?)> all(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/all.php');
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
        List expensessRaw = data['expenses'];
        List<ExpenseModal> expenses = expensessRaw
            .map(
              (e) => ExpenseModal.fromJson(e),
            )
            .toList();
        return (true, message, expenses);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "ExpenseRemoteDataSource - all",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String)> delete(int id) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/delete.php?id=$id');

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
        "ExpenseRemoteDataSource - delete",
        e.toString(),
      );
      return (false, 'Something went wrong');
    }
  }

  static Future<(bool, String, ExpenseModal?)> detail(int id) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/detail.php?id=$id');

    try {
      final response = await http.get(
        url,
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        ExpenseModal agenda =
            ExpenseModal.fromJson(Map<String, dynamic>.from(resBody['data']));
        return (true, message, agenda);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "ExpenseRemoteDataSource - detail",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List<ExpenseModal>?)> today(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/today.php');
    DateTime now = DateTime.now();
    String expenseDate = DateFormat('yyyy-MM-dd').format(
      DateTime(now.year, now.month, now.day),
    );

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'date_expense': expenseDate,
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        Map data = Map.from(resBody['data']);
        List expensesRaw = data['expenses'];
        List<ExpenseModal> expenses = expensesRaw
            .map(
              (e) => ExpenseModal.fromJson(e),
            )
            .toList();
        return (true, message, expenses);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "ExpenseRemoteDataSource - today",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }

  static Future<(bool, String, List?)> analytic(int userId) async {
    Uri url = Uri.parse('{$API.baseUrl}/api/expenses/analytic.php');
    DateTime now = DateTime.now();
    String expenseDate = DateFormat('yyyy-MM-dd').format(
      DateTime(now.year, now.month, 1),
    );

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId.toString(),
          'date_expense': expenseDate,
        },
      );
      fdLog.response(response);

      final resBody = jsonDecode(response.body);

      String message = resBody['message'];

      if (response.statusCode == 200) {
        List data = resBody['data']['expenses'];

        return (true, message, data);
      }
      return (false, message, null);
    } catch (e) {
      fdLog.title(
        "ExpenseRemoteDataSource - analytic",
        e.toString(),
      );
      return (false, 'Something went wrong', null);
    }
  }
}
