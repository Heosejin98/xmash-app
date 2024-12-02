import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmash_app/data/models/game_result_request.dart';
import 'package:xmash_app/data/models/user_model.dart';
import 'package:xmash_app/data/services/match_service.dart';
import 'package:xmash_app/domain/entities/match_type.dart';
import 'package:xmash_app/presentation/controllers/score_controller.dart';
import 'player_select_screen.dart';

class MatchRegisterScreen extends StatefulWidget {
  const MatchRegisterScreen({super.key});
  

  @override
  State<MatchRegisterScreen> createState() => _MatchRegisterScreenState();
}

class _MatchRegisterScreenState extends State<MatchRegisterScreen> {
  final MatchService _matchService = MatchService();
  final ScoreController _scoreController = Get.put(ScoreController());

  MatchType selectedMatchType = MatchType.double;
  List<UserModel>? homeTeamPlayers;
  List<UserModel>? awayTeamPlayers;
  var isRegisterButtonEnabled = false.obs;

  @override
  void initState() {
    super.initState();
    ever(_scoreController.homeScore, (_) => _updateRegisterButtonState());
    ever(_scoreController.awayScore, (_) => _updateRegisterButtonState());
  }

  void _updateRegisterButtonState() {
    isRegisterButtonEnabled.value = homeTeamPlayers != null && homeTeamPlayers!.isNotEmpty &&
                                    awayTeamPlayers != null && awayTeamPlayers!.isNotEmpty &&
                                    (_scoreController.getHomeScore() >= 11 || _scoreController.getAwayScore() >= 11);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              '경기 타입',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '경기 타입을 선택해 주세요',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildTypeButton(
                    context: context,
                    type: '단식',
                    icon: Icons.person,
                    isSelected: selectedMatchType == MatchType.single,
                    onTap: () => _handleTypeSelection(MatchType.single),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeButton(
                    context: context,
                    type: '복식',
                    icon: Icons.people,
                    isSelected: selectedMatchType == MatchType.double,
                    onTap: () => _handleTypeSelection(MatchType.double),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _buildTeamSection(
              context: context,
              title: 'HOME TEAM',
              players: homeTeamPlayers,
              onSelectPressed: () => _selectPlayers(true),
              scoreController: _scoreController.awayScoreTextEditer,
              isHomeTeam: true,
            ),
            const SizedBox(height: 24),
            _buildTeamSection(
              context: context,
              title: 'AWAY TEAM',
              players: awayTeamPlayers,
              onSelectPressed: () => _selectPlayers(false),
              scoreController: _scoreController.homeScoreTextEditer,
              isHomeTeam: false,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Obx(() => ElevatedButton(
            onPressed: isRegisterButtonEnabled.value ? _registerMatch : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check),
                SizedBox(width: 8),
                Text(
                  '경기 등록',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildTeamSection({
    required BuildContext context,
    required String title,
    required List<UserModel>? players,
    required VoidCallback onSelectPressed,
    required TextEditingController scoreController,
    required bool isHomeTeam,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 7,
                child: players == null || players.isEmpty
                    ? TextButton(
                        onPressed: onSelectPressed,
                        child: Text('$title 선수 선택하기'),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: players
                                .map((player) => Chip(
                                      label: Text(player.userName),
                                ))
                                .toList(),
                          ),
                          TextButton(
                            onPressed: onSelectPressed,
                            child: const Text('다시 선택하기'),
                          ),
                        ],
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: scoreController, // 홈 팀 점수 컨트롤러
                        decoration: const InputDecoration(
                          hintText: 'Score',
                        ),
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          if (isHomeTeam) {
                            _scoreController.updateHomeScore(value);
                          } else {
                            _scoreController.updateAwayScore(value);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _handleTypeSelection(MatchType type) async {
    setState(() {
      selectedMatchType = type;
      homeTeamPlayers = null;
      awayTeamPlayers = null;
    });
  }

  Future<void> _selectPlayers(bool isMyTeam) async {
    final result = await PlayerSelectBottomSheet.show(
      context: context,
      isDoubles: selectedMatchType == MatchType.double,
      title: isMyTeam ? 'HOMETEAM 선수 선택' : 'AWAYTEAM 선수 선택',
    );

    if (result != null) {
      setState(() {
        if (isMyTeam) {
          homeTeamPlayers = result;
        } else {
          awayTeamPlayers = result;
        }
      });
    }
  }

  Future<void> _registerMatch() async {
    try {

      int homeScore = _scoreController.getHomeScore();
      int awayScore = _scoreController.getAwayScore();

      GameResultRequest gameResultRequest = GameResultRequest(
        homeTeam: homeTeamPlayers!.map((player) => player.userId).toList(),
        awayTeam: awayTeamPlayers!.map((player) => player.userId).toList(),
        homeScore: homeScore,
        awayScore: awayScore,
        matchType: selectedMatchType,
      );

      await _matchService.createMatch(gameResultRequest: gameResultRequest);
    
      if (mounted) {
        setState(() {
          // 점수 초기화
          _scoreController.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('경기가 성공적으로 등록되었습니다.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('경기 등록 중 오류가 발생했습니다: ${e.toString()}')),
        );
      }
    } 
  }

  Widget _buildTypeButton({
    required BuildContext context,
    required String type,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.white,
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).primaryColor 
                : Colors.grey[300]!,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              type,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
} 