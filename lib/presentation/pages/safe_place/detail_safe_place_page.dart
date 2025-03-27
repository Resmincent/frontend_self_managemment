import 'package:flutter/material.dart';

class DetailSafePlacePage extends StatefulWidget {
  const DetailSafePlacePage({super.key, required this.safePlaceId});

  static const routeName = "/detail-safe-place";

  final int safePlaceId;

  @override
  State<DetailSafePlacePage> createState() => _DetailSafePlacePageState();
}

class _DetailSafePlacePageState extends State<DetailSafePlacePage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
