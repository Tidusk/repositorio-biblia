import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:openai_dart/openai_dart.dart';

class OpenAIService {
  late final OpenAIClient _client;

  OpenAIService() {
    final apiKey = dotenv.env['OPENAI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('Chave OPENAI_API_KEY não encontrada. Verifique seu arquivo .env');
    }
    _client = OpenAIClient(apiKey: apiKey);
  }

  Future<String> getStudy(String verseText) async {
    try {
      final request = CreateChatCompletionRequest(
        model: ChatCompletionModel.modelId('gpt-3.5-turbo'), // ✅ Jeito certo
        maxTokens: 500,
        messages: [
          ChatCompletionMessage.system(
            content:
                'Você é um assistente teológico. Analise o versículo fornecido e gere um estudo com no máximo 500 tokens, dividido exatamente nas seguintes seções: "Contexto Histórico", "Aplicação Prática" e "Referências Cruzadas".',
          ),
          ChatCompletionMessage.user(
            content: ChatCompletionUserMessageContent.string(verseText),
          ),
        ],
      );

      final completion = await _client.createChatCompletion(request: request);

      return completion.choices.first.message.content ?? 'A IA não retornou um estudo válido.';
    } catch (e) {
      debugPrint('Erro ao comunicar com a OpenAI: $e');
      return 'Não foi possível gerar o estudo. Tente novamente.';
    }
  }
}
