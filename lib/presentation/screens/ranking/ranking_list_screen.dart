import 'package:flutter/material.dart';
import 'package:xmash_app/core/theme/app_colors.dart';
import 'package:xmash_app/data/models/ranking_model.dart';
import 'package:xmash_app/data/services/ranking_service.dart';
import 'package:xmash_app/domain/entities/match_type.dart';
import 'package:xmash_app/presentation/screens/ranking/ranking_tab_view.dart';

class RankingListScreen extends StatefulWidget {
  const RankingListScreen({super.key});

  @override
  State<RankingListScreen> createState() => _RankingListScreenState();
}

class _RankingListScreenState extends State<RankingListScreen> with SingleTickerProviderStateMixin {
  final RankingService _rankingService = RankingService();
  List<RankingModel> ranking = [];
  List<RankingModel> filteredRanking = [];
  bool isLoading = true;
  String? error;
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadRanking();

    _searchController.addListener(_filterRanking);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _loadRanking();
    }
  }

  Future<void> _loadRanking([MatchType? type]) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final matchType = type ?? switch (_tabController.index) {
        0 => MatchType.single,
        1 => MatchType.double,
        _ => MatchType.double,
      };

      final fetchedRanking = await _rankingService.getRanking(matchType: matchType);

      setState(() {
        ranking = fetchedRanking;
        filteredRanking = ranking;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  void _filterRanking() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredRanking = ranking.where((rankingItem) {
        return rankingItem.userName.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('에러: $error'),
            ElevatedButton(
              onPressed: _loadRanking,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: '검색할 이름...',
                hintStyle: TextStyle(color: Colors.grey[400]),
                prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: '단식'),
              Tab(text: '복식'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
          ),
          Expanded(
            child: RankingTabView(
              controller: _tabController,
            ),
          ),
        ],
      ),
    );
  }
}
