import 'package:flutter/material.dart';
import 'package:xmash_app/presentation/widgets/common/main_app_bar.dart';
import 'package:xmash_app/presentation/widgets/common/main_bottom_navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const Center(child: Text('랭킹')), //임시 객체들
    const Center(child: Text('토너먼트')),
    const Center(child: Text('매치 등록')),
    const Center(child: Text('매치 기록')),
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