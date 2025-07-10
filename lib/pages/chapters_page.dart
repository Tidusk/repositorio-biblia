import 'package:flutter/material.dart';
import '../models/book_model.dart';
import 'verses_page.dart'; // Importando a tela de versículos

class ChaptersPage extends StatelessWidget {
  final Book book;
  final String bibleRef;

  const ChaptersPage({super.key, required this.book, required this.bibleRef});

  @override
  Widget build(BuildContext context) {
    print("Current Page: ChaptersPage");
    return Scaffold(
      appBar: AppBar(
        title: Text(book.name),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: book.chapters,
        itemBuilder: (context, index) {
          final chapter = index + 1;
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VersesPage(book: book, chapter: chapter, bibleRef: bibleRef),
                ),
              );
            },
            child: Card(
              child: Center(
                child: Text(
                  chapter.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
