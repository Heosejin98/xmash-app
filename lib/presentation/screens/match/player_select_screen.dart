import 'package:flutter/material.dart';
import 'package:xmash_app/data/services/user_service.dart';
import 'package:xmash_app/data/models/user_model.dart';

class PlayerSelectBottomSheet extends StatefulWidget {
  final bool isDoubles;
  final String title;
  final UserService _user_model;

  PlayerSelectBottomSheet({
    super.key,
    required this.isDoubles,
    required this.title,
  }) : _user_model = UserService();

  static Future<List<UserModel>?> show({
    required BuildContext context,
    required bool isDoubles,
    required String title,
  }) {
    return showModalBottomSheet<List<UserModel>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => PlayerSelectBottomSheet(
          isDoubles: isDoubles,
          title: title,
        ),
      ),
    );
  }

  @override
  State<PlayerSelectBottomSheet> createState() => _PlayerSelectBottomSheetState();
}

class _PlayerSelectBottomSheetState extends State<PlayerSelectBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
    final List<UserModel> selectedPlayers2 = [];
  List<UserModel> players = [];

  @override
  void initState() {
    super.initState();
    _fetchPlayers();
  }

  Future<void> _fetchPlayers() async {
    try {
      players = await widget._user_model.fetchUsers();
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          // 드래그 핸들
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          // 선택된 선수 표시
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: selectedPlayers2.isEmpty
                ? Text(
                    '선수를 선택해주세요',
                    style: TextStyle(color: Colors.grey[600]),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...selectedPlayers2.map((player) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  child: Text(player.userName[0]),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  player.userName,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    setState(() {
                                      selectedPlayers2.remove(player);
                                    });
                                  },
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
          ),
          // 검색창
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '선수 검색',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          // 선수 목록
          Expanded(
            child: players.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      final player = players[index];
                      final isSelected = selectedPlayers2.contains(player);
                      
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(player.userName[0]),
                        ),
                        title: Text(player.userName),
                        subtitle: Text(player.userId),
                        trailing: isSelected
                            ? Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Theme.of(context).primaryColor,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedPlayers2.remove(player);
                            } else {
                              if (selectedPlayers2.length < (widget.isDoubles ? 2 : 1)) {
                                selectedPlayers2.add(player);
                              }
                            }
                          });
                        },
                      );
                    },
                  ),
          ),
          // 하단 버튼
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: selectedPlayers2.length == (widget.isDoubles ? 2 : 1)
                  ? () {
                      Navigator.pop(context, selectedPlayers2);
                    }
                  : null,
              child: Text(
                widget.isDoubles 
                    ? '${selectedPlayers2.length}/2명 선택완료'
                    : '선택 완료'
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 