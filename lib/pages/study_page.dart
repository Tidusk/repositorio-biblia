import 'package:flutter/material.dart';
import 'package:myapp/pages/home_page.dart';
import '../services/firestore_service.dart';

class StudyPage extends StatefulWidget {
  final String verse;
  final String studyText;

  const StudyPage({super.key, required this.verse, required this.studyText});

  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  final FirestoreService _firestoreService = FirestoreService();
  bool _isSaving = false;

  Future<void> _saveStudy() async {
    setState(() => _isSaving = true);
    try {
      await _firestoreService.addStudy(widget.verse, widget.studyText);
      
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Estudo salvo com sucesso!')),
      );
      _navigateToHome(1);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar estudo: $error')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _navigateToHome(int index) {
    Navigator.of(context).popUntil((route) => route.isFirst);

    final homePageState = context.findAncestorStateOfType<HomePageState>();
    homePageState?.onItemTapped(index);
  }

  @override
  Widget build(BuildContext context) {
    print("Current Page: StudyPage");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estudo Avançado'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Versículo em Análise',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.verse,
                      style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  widget.studyText,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isSaving
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton.icon(
                    onPressed: _saveStudy,
                    icon: const Icon(Icons.save),
                    label: const Text('Salvar Estudo'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
