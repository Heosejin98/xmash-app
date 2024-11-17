import 'package:flutter/material.dart';
import 'package:xmash_app/presentation/screens/match/match_list_screen.dart';
import 'package:xmash_app/presentation/screens/ranking/ranking_list_screen.dart';
import 'package:xmash_app/presentation/screens/match/match_register_screen.dart';
import 'package:xmash_app/presentation/widgets/common/main_app_bar.dart';
import 'package:xmash_app/presentation/widgets/common/main_bottom_navigation_bar.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const RankingListScreen(),
    const Center(child: Text('토너먼트')),
    const MatchRegisterScreen(),
    const MatchListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MainAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: MainBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
} 