import 'package:flutter/material.dart';
import 'package:myapp/pages/saved_studies_page.dart';
import '../services/auth_service.dart';
import 'books_page.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode currentThemeMode;

  const HomePage({super.key, required this.toggleTheme, required this.currentThemeMode});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final AuthService _authService = AuthService();
  int _selectedIndex = 0;
  final String _bibleRef = 'AA';
  String? _userEmail;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = <Widget>[
      BooksPage(bibleRef: _bibleRef),
      const SavedStudiesPage(),
    ];
    _userEmail = _authService.currentUser?.email;
  }

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Current Page: HomePage");
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_selectedIndex == 0 ? 'Bíblia' : 'Meus Estudos'),
            if (_userEmail != null)
              Text(
                _userEmail!,
                style: const TextStyle(fontSize: 12),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(widget.currentThemeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
            tooltip: 'Alternar Tema',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
            },
            tooltip: 'Sair',
          ),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            label: 'Bíblia',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_border),
            label: 'Estudos Salvos',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: onItemTapped,
      ),
    );
  }
}
