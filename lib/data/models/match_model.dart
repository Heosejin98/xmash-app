import 'package:xmash_app/utils/date_utils.dart';

class MatchModel {
  final int idx;
  final List<Player> winTeam;
  final List<Player> loseTeam;
  final int winnerScore;
  final int loserScore;
  final DateTime matchTime;
  final String matchType;

  MatchModel({
    required this.idx,
    required this.winTeam,
    required this.loseTeam,
    required this.winnerScore,
    required this.loserScore,
    required this.matchTime,
    required this.matchType,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      idx: json['idx'] as int,
      winTeam: (json['winTeam'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      loseTeam: (json['loseTeam'] as List)
          .map((player) => Player.fromJson(player))
          .toList(),
      winnerScore: json['winnerScore'] as int,
      loserScore: json['loserScore'] as int,
      matchTime: CustomDateUtils.parseToKoreanTime(json['matchTime']),
      matchType: json['matchType'] as String,
    );
  }
}

class Player {
  final String userId;
  final String userName;
  final String? profileUrl;

  Player({
    required this.userId,
    required this.userName,
    this.profileUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      profileUrl: json['profileUrl'] as String?,
    );
  }
} 