import 'package:flutter/material.dart';
import 'package:xmash_app/data/models/game_result_request.dart';
import 'package:xmash_app/data/services/match_service.dart';
import 'package:xmash_app/domain/entities/match_type.dart';
import 'player_select_screen.dart';

class MatchRegisterScreen extends StatefulWidget {
  const MatchRegisterScreen({super.key});

  @override
  State<MatchRegisterScreen> createState() => _MatchRegisterScreenState();
}

class _MatchRegisterScreenState extends State<MatchRegisterScreen> {
  final MatchService _matchService = MatchService();
  MatchType selectedMatchType = MatchType.double;
  List<String>? myTeamPlayers;
  List<String>? opponentPlayers;
  final TextEditingController _myTeamScoreController = TextEditingController();
  final TextEditingController _opponentTeamScoreController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _myTeamScoreController.dispose();
    _opponentTeamScoreController.dispose();
    super.dispose();
  }

  Widget _buildTeamSection({
    required BuildContext context,
    required String title,
    required List<String>? players,
    required VoidCallback onSelectPressed,
    required TextEditingController scoreController,
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
                        child: Text('${title} 선수 선택하기'),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            children: players
                                .map((player) => Chip(
                                      label: Text(player),
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
                  child: TextField(
                    controller: scoreController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Score',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
              players: myTeamPlayers,
              onSelectPressed: () => _selectPlayers(true),
              scoreController: _myTeamScoreController,
            ),
            const SizedBox(height: 24),
            _buildTeamSection(
              context: context,
              title: 'AWAY TEAM',
              players: opponentPlayers,
              onSelectPressed: () => _selectPlayers(false),
              scoreController: _opponentTeamScoreController,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            // onPressed: _canProceed() ? _registerMatch : null,
            onPressed: _registerMatch,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleTypeSelection(MatchType type) async {
    setState(() {
      selectedMatchType = type;
      myTeamPlayers = null;
      opponentPlayers = null;
    });
  }

  Future<void> _selectPlayers(bool isMyTeam) async {
    final result = await PlayerSelectBottomSheet.show(
      context: context,
      isDoubles: selectedMatchType == MatchType.double,
      title: isMyTeam ? '우리팀 선수 선택' : '상대팀 선수 선택',
    );

    if (result != null) {
      setState(() {
        if (isMyTeam) {
          myTeamPlayers = result;
        } else {
          opponentPlayers = result;
        }
      });
    }
  }

  bool _canProceed() {
    final requiredPlayers = selectedMatchType == MatchType.double ? 2 : 1;
    final hasValidScores = _myTeamScoreController.text.isNotEmpty && 
                          _opponentTeamScoreController.text.isNotEmpty;
    return myTeamPlayers?.length == requiredPlayers && 
           opponentPlayers?.length == requiredPlayers &&
           hasValidScores;
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

  Future<void> _registerMatch() async {
    try {
      // 로딩 상태 표시
      setState(() {
        _isLoading = true;
      });


      GameResultRequest gameResultRequest = GameResultRequest(
        homeTeam: myTeamPlayers!,
        awayTeam: opponentPlayers!,
        homeScore: int.parse(_myTeamScoreController.text),
        awayScore: int.parse(_opponentTeamScoreController.text),
        matchType: selectedMatchType,
);
      // 경기 등록 로직 구현
      await MatchService().createMatch(gameResultReqeust: gameResultRequest);

      // 성공 시 처리
      if (mounted) {
        Navigator.pop(context); // 이전 화면으로 돌아가기
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('경기가 성공적으로 등록되었습니다.')),
        );
      }
    } catch (e) {
      // 에러 처리
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('경기 등록 중 오류가 발생했습니다: ${e.toString()}')),
        );
      }
    } finally {
      // 로딩 상태 해제
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 