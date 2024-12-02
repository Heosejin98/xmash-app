import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmash_app/models/match_model.dart';
import 'package:xmash_app/domain/match_service.dart';
import 'package:xmash_app/core/type/match_type.dart';

class MatchListView extends StatefulWidget {
  final MatchType type;
  
  const MatchListView({super.key, required this.type});
  
  @override
  State<MatchListView> createState() => _MatchListViewState();
}

class _MatchListViewState extends State<MatchListView> {
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
      setState(() => isLoading = true);
      final fetchedMatches = await _matchService.getMatches(
        matchType: widget.type,
      );
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadMatches,
      child: ListView.separated(
        itemCount: matches.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final match = matches[index];
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 왼쪽 팀
                Row(
                  children: match.winTeam.map((player) => _buildPlayerAvatar(player)).toList(),
                ),
                
                // 스코어
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
          );
        },
      ),
    );
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

} 