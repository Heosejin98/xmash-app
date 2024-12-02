import 'package:flutter/material.dart';
import 'package:xmash_app/models/ranking_model.dart';
import 'package:xmash_app/domain/ranking_service.dart';
import 'package:xmash_app/core/type/match_type.dart';

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

    return Column(
      children: [
        // 테이블 헤더
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: Colors.grey[200],
          child: const Row(
            children: [
              Expanded(flex: 1, child: Text('순위', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 3, child: Text('이름', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('티어', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(flex: 2, child: Text('LP', style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              final rankingItem = ranking[index];
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
                child: Row(
                  children: [
                    // 순위
                    Expanded(
                      flex: 1,
                      child: Text(
                        rankingItem.rank.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // 이름
                    Expanded(
                      flex: 3,
                      child: Text(
                        rankingItem.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    // 티어
                    Expanded(
                      flex: 2,
                      child: Text(
                        rankingItem.tier,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    // LP
                    Expanded(
                      flex: 2,
                      child: Text(
                        rankingItem.lp.toString(),
                        style: const TextStyle(color: Colors.blueAccent),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
