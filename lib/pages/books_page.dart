import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/bible_service.dart';
import 'chapters_page.dart';

class BooksPage extends StatefulWidget {
  final String bibleRef;
  const BooksPage({super.key, required this.bibleRef});

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  late final BibleService _bibleService;
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _bibleService = BibleService(widget.bibleRef);
    _booksFuture = _bibleService.getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _booksFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar livros: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhum livro encontrado.'));
        }

        final books = snapshot.data!;

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Duas colunas
            crossAxisSpacing: 10, // Espaçamento horizontal
            mainAxisSpacing: 10, // Espaçamento vertical
            childAspectRatio: 1.5, // Ajusta a proporção dos itens da grade
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];
            return Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChaptersPage(book: book, bibleRef: widget.bibleRef),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        book.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${book.chapters} capítulos',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
