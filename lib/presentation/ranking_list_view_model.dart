import 'package:get/get.dart';
import 'package:xmash_app/core/type/match_type.dart';
import 'package:xmash_app/domain/ranking_service.dart';
import 'package:xmash_app/models/ranking_model.dart';

class RankingListViewModel extends GetxController  {
  var ranking = <RankingModel>[].obs; // 랭킹 리스트를 관찰 가능한 리스트로 변경
  var isLoading = true.obs; // 로딩 상태
  var error = ''.obs; // 에러 메시지

  final RankingService _rankingService = RankingService();

  @override
  void onInit() {
    super.onInit();
    loadRanking(); // 초기 랭킹 로드
  }


  Future<void> loadRanking([MatchType? type]) async {
    try {
      isLoading.value = true;
      error.value = '';

      final matchType = type ?? MatchType.single; // 기본 매치 타입 설정
      final fetchedRanking = await _rankingService.getRanking(matchType: matchType);

      ranking.assignAll(fetchedRanking); // 랭킹 업데이트
    } catch (e) {
      error.value = e.toString(); // 에러 메시지 업데이트
    } finally {
      isLoading.value = false; // 로딩 상태 종료
    }
  }
}
