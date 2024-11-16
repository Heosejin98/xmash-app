import 'package:flutter/material.dart';
import 'package:xmash_app/data/models/ranking_model.dart';
import 'package:xmash_app/data/services/ranking_service.dart';
import 'package:xmash_app/domain/entities/ranking_type.dart';

class RankingListView extends StatefulWidget {
  final MatchType type; 
  const RankingListView({super.key, required this.type});

  @override
  _RankingListViewState createState() => _RankingListViewState();
}

class _RankingListViewState extends State<RankingListView> {
  final RankingService _rankingService = RankingService();
  List<RankingModel> ranking = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadRanking();
  }

  Future<void> _loadRanking() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedRanking = await _rankingService.getRanking(matchType: widget.type);
      setState(() {
        ranking = fetchedRanking;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('에러: $error'),
            ElevatedButton(
              onPressed: _loadRanking,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: ranking.length,
      itemBuilder: (context, index) {
        final rankingItem = ranking[index];
        return ListTile(
          title: Text(rankingItem.userName), 
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('LP: ${rankingItem.lp}'),
              Text('Rank: ${rankingItem.rank}'), 
              Text('Tier: ${rankingItem.tier}'),
            ],
          ),
        );
      },
    );
  }
}
