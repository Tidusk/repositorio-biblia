import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myapp/pages/saved_studies_page.dart';
import 'package:myapp/main.dart'; // Import main.dart to access themeProvider
import '../services/auth_service.dart';
import 'books_page.dart';

// 1. Convert to ConsumerStatefulWidget
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  // 2. Update the State class to be a ConsumerState
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
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
    // 3. Watch the themeProvider
    final themeMode = ref.watch(themeProvider);

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
            // 4. Update the icon based on the themeMode from the provider
            icon: Icon(themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            // 5. Call the toggleTheme method from the provider
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
            tooltip: 'Alternar Tema',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _authService.signOut();
              // 6. No need to navigate, StreamBuilder in main.dart will handle it
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
