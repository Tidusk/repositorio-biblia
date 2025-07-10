import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Salva um novo estudo no Firestore
  Future<void> addStudy(String verse, String studyText) async {
    final user = _auth.currentUser;
    if (user == null) return; // Não faz nada se o usuário não estiver logado

    await _db.collection('users').doc(user.uid).collection('studies').add({
      'verse': verse,
      'studyText': studyText,
      'createdAt': Timestamp.now(), // Alterado para timestamp do cliente
    });
  }

  // Obtém um stream com a lista de estudos do usuário logado
  Stream<QuerySnapshot> getStudies() {
    final user = _auth.currentUser;
    if (user == null) {
      // Retorna um stream vazio se não houver usuário
      return const Stream.empty();
    }
    
    return _db
        .collection('users')
        .doc(user.uid)
        .collection('studies')
        .orderBy('createdAt', descending: true) // Ordena pelos mais recentes
        .snapshots();
  }
}
