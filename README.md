# Bíblia Estudo IA

Este é um aplicativo em Flutter que permite ao usuário navegar pela Bíblia, selecionar um versículo e receber um estudo aprofundado gerado pela API da OpenAI. Os estudos podem ser salvos e consultados posteriormente.

## Funcionalidades

-   **Autenticação**: Login e criação de conta com E-mail e Senha (Firebase Auth).
-   **Navegação Bíblica**: Explore livros, capítulos e versículos da Bíblia (via API Bible4U).
-   **Estudo com IA**: Toque em um versículo para gerar um estudo com Contexto Histórico, Aplicação Prática e Referências Cruzadas (via OpenAI API).
-   **Biblioteca Pessoal**: Salve seus estudos favoritos no Cloud Firestore e acesse-os a qualquer momento.
-   **WebView**: Abra links de referência encontrados nos estudos diretamente no aplicativo.

## Checklist de Requisitos

-   [x] **RF1. Autenticação**: Firebase Auth
-   [x] **RF2. Navegação b´ıblica**: Bible4U API
-   [x] **RF3. Geração de Estudo Avançado**: OpenAI API
-   [x] **RF4. Biblioteca de Estudos**: CRUD no Firestore
-   [x] **RF5. Proteção de Dados**: Regras de segurança do Firestore
-   [x] **RNF1. Interface simples, responsiva**
-   [x] **RNF2. Exibir snackbar para feedback**
-   [x] **RNF3. Chave da OpenAI em arquivo `.env`**
-   [x] **RNF4. C´odigo dividido em `models`, `services`, `pages`**
--   [x] **RNF5. Uso de `webview_flutter`**
-   [x] **RNF6. Compat´ıvel com Android API ≥ 21**

## Como Configurar e Rodar o Projeto

### 1. Pré-requisitos

-   Flutter SDK instalado.
-   Conta no [Firebase](https://firebase.google.com/).
-   Conta na [OpenAI](https://openai.com/) para obter uma chave de API.

### 2. Configuração do Firebase

1.  Crie um projeto no console do Firebase.
2.  Configure o `flutterfire` seguindo a [documentação oficial](https://firebase.flutter.dev/docs/cli).
3.  No diretório do projeto, rode o comando abaixo e siga as instruções para conectar seu app ao projeto Firebase:
    ```bash
    flutterfire configure
    ```
4.  No console do Firebase, ative os seguintes serviços:
    -   **Authentication**: Ative o provedor "E-mail/senha".
    -   **Cloud Firestore**: Crie um banco de dados.

### 3. Variáveis de Ambiente

1.  No diretório raiz do projeto, crie um arquivo chamado `.env`.
2.  Adicione sua chave da OpenAI API a este arquivo:
    ```
    OPENAI_API_KEY=sk-sua-chave-aqui
    ```
    O arquivo `.env` já está no `.gitignore` para não ser enviado ao seu repositório.

### 4. Regras de Segurança do Firestore

Vá até a aba **Regras** do Cloud Firestore no seu console do Firebase e cole as seguintes regras para proteger os dados dos usuários:
```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### 5. Rodar o Aplicativo

1.  Instale as dependências:
    ```bash
    flutter pub get
    ```
2.  Execute o aplicativo:
    ```bash
    flutter run
    ```

## Capturas de Tela / GIF

*Adicione aqui um GIF ou algumas capturas de tela mostrando o fluxo principal do aplicativo: tela de login, navegação de livros, visualização de versículos, estudo gerado pela IA e a lista de estudos salvos.*
