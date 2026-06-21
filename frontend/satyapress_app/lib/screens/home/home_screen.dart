import '../layer2/buried_stories_screen.dart';
import 'package:flutter/material.dart';
import '../news_feed/news_feed_screen.dart';
import '../search/search_screen.dart';
import '../layer3/claim_clash_screen.dart';

/// HomeScreen contains the main navigation structure of SatyaPress.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const NewsFeedScreen(),
    const SearchScreen(),
    const BuriedStoriesScreen(),
    const ClaimClashScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.search_rounded),
            label: 'Search',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_rounded),
            label: 'Coverage',
          ),
          NavigationDestination(
            icon: Icon(Icons.compare_arrows_rounded),
            label: 'Clash',
          ),
        ],
      ),
    );
  }
}
