import 'package:xmash_app/domain/entities/match_type.dart';

class GameResultRequest {
  final List<String> homeTeam;
  final List<String> awayTeam;
  final int homeScore;
  final int awayScore;
  final MatchType matchType;

  GameResultRequest({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeScore,
    required this.awayScore,
    required this.matchType,
  });

  Map<String, dynamic> toJson() {
    return {
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'matchType': matchType.value,
    };
  }
} 