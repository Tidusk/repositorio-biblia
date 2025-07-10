import 'package:flutter/material.dart';
import 'webview_page.dart'; // Importando a página do WebView

class SavedStudyDetailPage extends StatefulWidget {
  final String verse;
  final String studyText;

  const SavedStudyDetailPage({
    super.key,
    required this.verse,
    required this.studyText,
  });

  @override
  State<SavedStudyDetailPage> createState() => _SavedStudyDetailPageState();
}

class _SavedStudyDetailPageState extends State<SavedStudyDetailPage> {
  String? _foundUrl;

  @override
  void initState() {
    super.initState();
    _findUrlInStudy();
  }

  void _findUrlInStudy() {
    final RegExp urlRegExp = RegExp(
      r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6} ([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
      caseSensitive: false,
    );
    final match = urlRegExp.firstMatch(widget.studyText);
    if (match != null) {
      setState(() {
        _foundUrl = match.group(0);
      });
    }
  }

  void _openWebView() {
    if (_foundUrl != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebViewPage(url: _foundUrl!),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Current Page: SavedStudyDetailPage");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Estudo'),
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
            Text(
              widget.verse,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Text(
              widget.studyText,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            if (_foundUrl != null)
              ElevatedButton.icon(
                onPressed: _openWebView,
                icon: const Icon(Icons.open_in_browser),
                label: const Text('Abrir Link de Referência'),
              ),
          ],
        ),
      ),
    );
  }
}
