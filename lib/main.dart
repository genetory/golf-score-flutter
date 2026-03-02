import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'common/widgets/common_tab_view.dart';
import 'score_record_course/score_record_course_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Golf Score',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MainShell(),
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static const _pages = [
    _TabPlaceholder(title: '피쳐드'),
    _TabPlaceholder(title: '커뮤니티'),
    _TabPlaceholder(title: '알림'),
    _TabPlaceholder(title: '프로필'),
  ];

  Future<void> _handleTap(int index) async {
    if (index == 2) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (context) => const ScoreRecordCourseView(),
      );
      return;
    }

    setState(() {
      _currentIndex = index > 2 ? index - 1 : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: CommonTabView(
        currentIndex: _currentIndex >= 2 ? _currentIndex + 1 : _currentIndex,
        onTap: _handleTap,
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}
