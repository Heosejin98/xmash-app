import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmash_app/data/models/match_model.dart';
import 'package:xmash_app/data/services/match_service.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  final MatchService _matchService = MatchService();
  List<MatchModel> matches = [];
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final fetchedMatches = await _matchService.getMatches();
      setState(() {
        matches = fetchedMatches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Widget _buildPlayerAvatar(dynamic player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: CircleAvatar(
        radius: 16,
        child: Text(
          player.userName.length >= 2 
            ? player.userName.substring(1, 3) 
            : player.userName,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
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
              onPressed: _loadMatches,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // 검색창
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '검색할 이름...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        
        // 탭바
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {},
              child: const Text('전체'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('단식'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('복식'),
            ),
          ],
        ),

        // 매치 리스트
        Expanded(
          child: RefreshIndicator(
            onRefresh: _loadMatches,
            child: ListView.separated(
              itemCount: matches.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final match = matches[index];
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // 왼쪽 팀
                        Row(
                          children: match.winTeam.map((player) => _buildPlayerAvatar(player)).toList(),
                        ),
                        
                        // 스코어 - Expanded로 감싸서 중앙 정렬
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  Text(
                                    '${match.winnerScore} vs ${match.loserScore}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    DateFormat('MM.dd. (E)\nHH:mm', 'ko_KR')
                                        .format(match.matchTime),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        // 오른쪽 팀
                        Row(
                          children: match.loseTeam.map((player) => _buildPlayerAvatar(player)).toList(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
} 