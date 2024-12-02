import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xmash_app/core/theme/app_colors.dart';
import 'package:xmash_app/ui/screens/ranking/ranking_tab_view.dart';
import 'package:xmash_app/presentation/ranking_list_view_model.dart';

class RankingListScreen extends StatefulWidget {
  const RankingListScreen({super.key});

  @override
  State<RankingListScreen> createState() => _RankingListScreenState();
}


class _RankingListScreenState extends State<RankingListScreen> with SingleTickerProviderStateMixin {
  final RankingListViewModel _viewModel = Get.put(RankingListViewModel());

  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_viewModel.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_viewModel.error.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('에러: ${_viewModel.error.value}'),
              ElevatedButton(
                onPressed: _viewModel.loadRanking,
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
    });
  }
}