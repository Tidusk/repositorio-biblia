import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../services/firestore_service.dart';
import 'saved_study_detail_page.dart'; // Importando a página de detalhes

class SavedStudiesPage extends StatefulWidget {
  const SavedStudiesPage({super.key});

  @override
  State<SavedStudiesPage> createState() => _SavedStudiesPageState();
}

class _SavedStudiesPageState extends State<SavedStudiesPage> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getStudies(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Ocorreu um erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Você ainda não salvou nenhum estudo. Navegue pela Bíblia, toque em um versículo para gerar um estudo e depois o salve!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }

          final studies = snapshot.data!.docs;

          return ListView.builder(
            itemCount: studies.length,
            itemBuilder: (context, index) {
              final study = studies[index];
              final data = study.data() as Map<String, dynamic>;
              final verse = data['verse'] as String;
              final studyText = data['studyText'] as String;
              final timestamp = data['createdAt'] as Timestamp?;

              final date = timestamp != null
                  ? DateFormat('dd/MM/yyyy HH:mm').format(timestamp.toDate())
                  : 'Data indisponível';

              return ListTile(
                title: Text(verse, maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text(date),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SavedStudyDetailPage(
                        verse: verse,
                        studyText: studyText,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
