import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dadaroo/providers/app_provider.dart';
import 'package:dadaroo/screens/dad_view.dart';
import 'package:dadaroo/screens/family_view.dart';
import 'package:dadaroo/screens/rate_dad_view.dart';
import 'package:dadaroo/screens/history_view.dart';
import 'package:dadaroo/theme/app_theme.dart';

void main() {
  runApp(const DadarooApp());
}

class DadarooApp extends StatelessWidget {
  const DadarooApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppProvider()..seedDemoData(),
      child: MaterialApp(
        title: 'Dadaroo',
        theme: AppTheme.theme,
        debugShowCheckedModeBanner: false,
        home: const MainShell(),
      ),
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

  static const _screens = [
    DadView(),
    FamilyView(),
    RateDadView(),
    HistoryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.directions_car_outlined),
            selectedIcon:
                Icon(Icons.directions_car, color: AppTheme.primaryOrange),
            label: 'Dad',
          ),
          NavigationDestination(
            icon: Icon(Icons.family_restroom_outlined),
            selectedIcon:
                Icon(Icons.family_restroom, color: AppTheme.primaryOrange),
            label: 'Family',
          ),
          NavigationDestination(
            icon: Icon(Icons.star_outline),
            selectedIcon: Icon(Icons.star, color: AppTheme.primaryOrange),
            label: 'Rate Dad',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history, color: AppTheme.primaryOrange),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
