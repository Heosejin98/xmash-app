import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ScoreController extends GetxController {
  final TextEditingController awayScoreTextEditer = TextEditingController(); // 홈 팀 점수
  final TextEditingController homeScoreTextEditer = TextEditingController(); // 홈 팀 점수
  Rx<int> homeScore = 0.obs; 
  Rx<int> awayScore = 0.obs;

  @override
  void onClose() {
    awayScoreTextEditer.dispose(); // 컨트롤러 해제
    super.onClose();
  }

  void updateHomeScore(String value) {
    homeScore.value = int.tryParse(value) ?? 0; // 점수 업데이트
    print(homeScore.value);
  }

  void updateAwayScore(String value) {
    awayScore.value = int.tryParse(value) ?? 0; // 점수 업데이트
        print(awayScore.value);

  }

  int getHomeScore() => homeScore.value; // int로 반환
  int getAwayScore() => awayScore.value; // int로 반환

  void clear() {
    homeScore = 0 as RxInt;
    awayScore = 0 as RxInt;
    awayScoreTextEditer.clear();
    homeScoreTextEditer.clear();
  }

}