import 'package:flutter/material.dart';

class DetailJournalPage extends StatefulWidget {
  const DetailJournalPage({super.key, required this.journalId});

  static const routeName = "/detail-journal";

  final int journalId;

  @override
  State<DetailJournalPage> createState() => _DetailJournalPageState();
}

class _DetailJournalPageState extends State<DetailJournalPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
