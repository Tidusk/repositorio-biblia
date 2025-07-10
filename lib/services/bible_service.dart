import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';
import '../models/verse_model.dart';

class BibleService {
  final String _base = 'https://cors-anywhere.herokuapp.com/https://bible4u.net/api/v1';
  final String bibleRef; // como "NTLH", "KJV", "NVI-PT", etc

  BibleService(this.bibleRef);

  // 📔 Lista os livros da Bíblia selecionada
  Future<List<Book>> getBooks() async {
    final url = Uri.parse('$_base/bibles/$bibleRef/books?format=json');
    print('Buscando livros em: $url'); // Adicionado para depuração
    try {
      final res = await http.get(url);
      print('Resposta da API (getBooks): ${res.body}'); // Imprime o corpo da resposta
      if (res.statusCode == 200) {
        final decodedBody = jsonDecode(res.body);
        // A lista de livros está em data, conforme os logs anteriores
        final List<dynamic> list = decodedBody['data'];
        print('Objeto data (getBooks): $list'); // Imprime o objeto data
        return list.map((e) => Book.fromJson(e)).toList();
      } else {
        String errorMessage = 'Falha ao carregar os livros. Status: ${res.statusCode}';
        try {
          final errorBody = jsonDecode(res.body);
          if (errorBody != null && errorBody['message'] != null) {
            errorMessage += ' - Mensagem: ${errorBody['message']}';
          }
        } catch (e) {
          // Ignorar erro de parse se o corpo não for JSON
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de rede ou API: $e');
    }
  }

  // 📖 Lista os versículos de um livro e capítulo
  Future<List<Verse>> getVerses(String bookRef, int chapter) async {
    final url = Uri.parse('$_base/bibles/$bibleRef/books/$bookRef/chapters/$chapter?format=json');
    print('Buscando versículos em: $url'); // Adicionado para depuração
    try {
      final res = await http.get(url);
      print('Resposta da API (getVerses): ${res.body}'); // Imprime o corpo da resposta
      if (res.statusCode == 200) {
        final decodedBody = jsonDecode(res.body);
        // A lista de versículos está em data['verses'], conforme a documentação
        final List<dynamic> list = decodedBody['data']['verses'];
        print('Objeto data (getVerses): ${decodedBody['data']}'); // Imprime o objeto data
        return list.map((e) => Verse.fromJson(e)).toList();
      } else {
        String errorMessage = 'Falha ao carregar os versículos. Status: ${res.statusCode}';
        try {
          final errorBody = jsonDecode(res.body);
          if (errorBody != null && errorBody['message'] != null) {
            errorMessage += ' - Mensagem: ${errorBody['message']}';
          }
        } catch (e) {
          // Ignorar erro de parse se o corpo não for JSON
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Erro de rede ou API: $e');
    }
  }
}
