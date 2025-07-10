import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../models/verse_model.dart';
import '../services/bible_service.dart';
import '../services/openai_service.dart';
import 'study_page.dart';

class VersesPage extends StatefulWidget {
  final Book book;
  final int chapter;
  final String bibleRef;

  const VersesPage({super.key, required this.book, required this.chapter, required this.bibleRef});

  @override
  State<VersesPage> createState() => _VersesPageState();
}

class _VersesPageState extends State<VersesPage> {
  late final BibleService _bibleService;
  final OpenAIService _openAIService = OpenAIService();
  late Future<List<Verse>> _versesFuture;

  @override
  void initState() {
    super.initState();
    _bibleService = BibleService(widget.bibleRef);
    _versesFuture = _bibleService.getVerses(widget.book.abbrev, widget.chapter);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Carregando versículos...')),
        );
      }
    });
  }

  Future<void> _onVerseTap(Verse verse) async {
    final fullVerseText = '${widget.book.name} ${widget.chapter}:${verse.number} - "${verse.text}"';
    
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Gerando estudo para ${widget.book.name} ${widget.chapter}:${verse.number}...')),
    );

    try {
      final studyText = await _openAIService.getStudy(fullVerseText);
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StudyPage(
            verse: fullVerseText,
            studyText: studyText,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao gerar estudo: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current Page: VersesPage");
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.book.name} ${widget.chapter}'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: _versesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum versículo encontrado.'));
          }

          final verses = snapshot.data!;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
               ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: verses.length,
            itemBuilder: (context, index) {
              final verse = verses[index];
              return InkWell(
                onTap: () => _onVerseTap(verse),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '${verse.number} ',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              TextSpan(
                                text: verse.text,
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.auto_awesome,
                        size: 18,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
