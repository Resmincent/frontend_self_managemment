import 'package:flutter/widgets.dart';

class DetailIncomePage extends StatefulWidget {
  const DetailIncomePage({super.key, required this.incomeId});
  final int incomeId;

  static const routeName = '/detail-income';
  @override
  State<DetailIncomePage> createState() => _DetailIncomePageState();
}

class _DetailIncomePageState extends State<DetailIncomePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
