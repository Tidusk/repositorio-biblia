import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenAIService {
  final String _apiKey = dotenv.env['OPENAI_API_KEY']!;
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> generateStudy(String verse) async {
    // Prompt aprimorado para instruir a IA a seguir um formato específico
    final String prompt = """
      Faça um estudo aprofundado sobre o seguinte versículo bíblico: "$verse".

      O estudo deve ser dividido em três seções claras e bem definidas, seguindo exatamente esta estrutura:

      1.  **Contexto Histórico:** Descreva o cenário cultural, político e religioso da época em que o texto foi escrito.
      2.  **Aplicação Prática:** Ofereça conselhos sobre como aplicar os ensinamentos deste versículo no dia a dia.
      3.  **Referências Cruzadas:** Liste outros 2 ou 3 versículos bíblicos que se conectam ou aprofundam o tema principal. Se possível, inclua um link para um artigo ou estudo externo relevante.

      O texto total não deve exceder 500 tokens. Mantenha a linguagem clara, objetiva e edificante.
    """;

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {'role': 'system', 'content': 'Você é um teólogo e historiador especializado em estudos bíblicos.'},
            {'role': 'user', 'content': prompt},
          ],
          'max_tokens': 500, // Limita o tamanho da resposta
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(utf8.decode(response.bodyBytes));
        return body['choices'][0]['message']['content'].trim();
      } else {
        // Decodifica a mensagem de erro da API para fornecer mais detalhes
        final errorBody = jsonDecode(utf8.decode(response.bodyBytes));
        final errorMessage = errorBody['error']?['message'] ?? 'Erro desconhecido';
        throw Exception('Falha ao gerar estudo: ${response.statusCode} - $errorMessage');
      }
    } catch (e) {
      // Retorna uma mensagem de erro mais clara
      return 'Não foi possível conectar à IA. Verifique sua conexão ou a chave da API. Detalhes: $e';
    }
  }
}
