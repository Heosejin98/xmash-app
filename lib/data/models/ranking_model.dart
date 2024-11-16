import 'package:xmash_app/core/utils/date_utils.dart';

class RankingModel {
  final String userId;
  final String userName;
  final int lp;
  final int rank;
  final String tier;

  RankingModel({
    required this.userId,
    required this.userName,
    required this.lp,
    required this.rank,
    required this.tier,
  });

  factory RankingModel.fromJson(Map<String, dynamic> json) {
    return RankingModel(
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      lp: json['lp'] as int,
      rank: json['rank'] as int,
      tier: json['tier'] as String,
    );
  }
} 