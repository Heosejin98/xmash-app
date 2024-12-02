import 'package:flutter/material.dart';
import 'package:xmash_app/core/type/match_type.dart';
import 'package:xmash_app/ui/screens/ranking/ranking_list_view.dart';

class RankingTabView extends StatefulWidget {
  final TabController controller;
  
  const RankingTabView({super.key, required this.controller});
  
  @override
  State<RankingTabView> createState() => _RankingTabViewState();
}

class _RankingTabViewState extends State<RankingTabView> {
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: widget.controller,
      children: const [
        RankingListView(type: MatchType.single),
        RankingListView(type: MatchType.double),
      ],
    );
  }
}
