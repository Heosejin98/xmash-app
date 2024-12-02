import 'package:flutter/material.dart';
import 'package:xmash_app/core/theme/app_colors.dart';
import 'package:xmash_app/models/match_model.dart';
import 'package:xmash_app/domain/match_service.dart';
import 'package:xmash_app/core/type/match_type.dart';
import 'package:xmash_app/ui/screens/match/match_tab_view.dart';

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  State<MatchListScreen> createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> with SingleTickerProviderStateMixin {
  final MatchService _matchService = MatchService();
  List<MatchModel> matches = [];
  bool isLoading = true;
  String? error;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadMatches();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      _loadMatches();
    }
  }

  Future<void> _loadMatches([MatchType? type]) async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final matchType = type ?? switch (_tabController.index) {
        0 => MatchType.all,
        1 => MatchType.single,
        2 => MatchType.double,
        _ => MatchType.all,
      };

      final fetchedMatches = await _matchService.getMatches(
        matchType: matchType,
      );
      setState(() {
        matches = fetchedMatches;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
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
              onPressed: _loadMatches,
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
              Tab(text: '전체'),
              Tab(text: '단식'),
              Tab(text: '복식'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey[400],
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
          ),
          Expanded(
            child: MatchTabView(controller: _tabController),
          ),
        ],
      ),
    );
  }
} 