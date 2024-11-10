import 'package:flutter/material.dart';
import 'package:xmash_app/domain/entities/match_type.dart';
import 'package:xmash_app/presentation/screens/match/match_list_view.dart';

class MatchTabView extends StatefulWidget {
  final TabController controller;
  
  const MatchTabView({super.key, required this.controller});
  
  @override
  State<MatchTabView> createState() => _MatchTabViewState();
}

class _MatchTabViewState extends State<MatchTabView> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: const [
        MatchListView(type: MatchType.all),
        MatchListView(type: MatchType.single),
        MatchListView(type: MatchType.double),
      ],
    );
  }
} 