// lib/pages/home/home_page.dart
import 'package:flutter/material.dart';
import '../../config/theme.dart';
import 'dashboard_page.dart';
import '../map/map_page.dart';
import '../characters/chara_page.dart';
import '../profile/pfp_page.dart';
import '../store/merch_page.dart';
import '../episodes/eps_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  final List<String> _pageTitles = [
    'Dashboard',
    'Map',
    'Characters',
    'Episodes',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _pages = [
      DashboardPage(
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      MapPage(),
      CharactersPage(),
      EpisodesPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(
              Icons.military_tech,
              color: AppTheme.secondaryColor,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              _pageTitles[_currentIndex],
              style: TextStyle(
                color: AppTheme.secondaryColor,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          // ✅ Tombol Store (Scout Store)
          IconButton(
            icon: Icon(
              Icons.shopping_cart_outlined, // atau Icons.shopping_bag_outlined
              color: AppTheme.secondaryColor,
            ),
            tooltip: 'Scout Store',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MerchPage()),
              );
            },
          ),

        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: AppTheme.backgroundColor,
          selectedItemColor: AppTheme.accentColor,
          unselectedItemColor: AppTheme.textColor,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 8,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              activeIcon: Icon(Icons.map),
              label: 'Peta',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              activeIcon: Icon(Icons.people),
              label: 'Karakter',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie_outlined),
              activeIcon: Icon(Icons.movie),
              label: 'Episode',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
