import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/widgets/app_scaffold.dart';
import '../../../voice_dictation/presentation/voice_agent_page.dart';
import 'home_tab.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeTab(),
    const VoiceAgentPage(), // VIVLO
    const Center(child: Text('Mission Engine')),
    const Center(child: Text('Community')),
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showAppBar: false,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.accentPrimary,
        unselectedItemColor: AppColors.inkMuted,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Vivlo'),
          BottomNavigationBarItem(
            icon: Icon(Icons.rocket_launch),
            label: 'Mission',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Community'),
        ],
      ),
    );
  }
}
