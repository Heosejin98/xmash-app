import 'package:flutter/material.dart';

class MainBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const MainBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: '순위',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.emoji_events),
          label: '대회 준비',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '경기 등록',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: '전적',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.blue,
      onTap: onTap,
    );
  }
} 