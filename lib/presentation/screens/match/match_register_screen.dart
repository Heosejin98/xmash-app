import 'package:flutter/material.dart';
import 'player_select_screen.dart';

class MatchRegisterScreen extends StatefulWidget {
  const MatchRegisterScreen({super.key});

  @override
  State<MatchRegisterScreen> createState() => _MatchRegisterScreenState();
}

class _MatchRegisterScreenState extends State<MatchRegisterScreen> {
  String? selectedType = '복식';
  List<String>? myTeamPlayers;
  List<String>? opponentPlayers;
  final TextEditingController _myTeamScoreController = TextEditingController();
  final TextEditingController _opponentTeamScoreController = TextEditingController();

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
                    isSelected: selectedType == '단식',
                    onTap: () => _handleTypeSelection('단식'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTypeButton(
                    context: context,
                    type: '복식',
                    icon: Icons.people,
                    isSelected: selectedType == '복식',
                    onTap: () => _handleTypeSelection('복식'),
                  ),
                ),
              ],
            ),
            if (selectedType != null) ...[
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
          ],
        ),
      ),
      bottomNavigationBar: selectedType != null
          ? BottomAppBar(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: _canProceed() ? () {
                    // TODO: 경기 등록 처리
                  } : null,
                  child: const Text('경기 등록하기'),
                ),
              ),
            )
          : null,
    );
  }


  Future<void> _handleTypeSelection(String type) async {
    setState(() {
      selectedType = type;
      myTeamPlayers = null;
      opponentPlayers = null;
    });
  }

  Future<void> _selectPlayers(bool isMyTeam) async {
    final result = await PlayerSelectBottomSheet.show(
      context: context,
      isDoubles: selectedType == '복식',
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
    final requiredPlayers = selectedType == '복식' ? 2 : 1;
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
} 