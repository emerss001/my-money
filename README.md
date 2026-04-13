# 💰 My Money App

Bem-vindo ao **My Money**, um aplicativo moderno e elegante desenvolvido em Flutter para ajudar você a gerenciar suas finanças de forma simples e eficiente. Tenha o controle total das suas entradas, saídas e saldo atual na palma da sua mão.

---

## 📱 Sobre o Projeto

O **My Money** é um aplicativo voltado para o controle financeiro pessoal. Ele permite que os usuários registrem transações (receitas e despesas), categorizem seus gastos, acompanhem o saldo total e gerenciem seus perfis. O aplicativo foi desenhado com um tema escuro (_Dark Theme_) moderno, utilizando tons de verde para destacar informações positivas e proporcionar uma experiência visual agradável.

---

## 🚀 Funcionalidades

- **Autenticação Segura:** Login e registro de usuários com armazenamento seguro de tokens.
- **Dashboard Intuitivo:** Tela inicial com cartões de resumo mostrando:
    - Entradas (Receitas)
    - Saídas (Despesas)
    - Saldo Total
- **Gestão de Transações:**
    - Adição de novas transações (título, valor, categoria e tipo).
    - Listagem completa com busca/filtragem.
    - Edição e exclusão de transações existentes diretamente pela interface.
- **Gerenciamento de Perfil:** Visualização e edição de dados do usuário, incluindo foto de perfil.
- **Atualização em Tempo Real:** Puxe para atualizar (_Pull-to-refresh_) para sincronizar dados rapidamente.
- **Feedback Visual:** Uso de _Snackbars_ personalizadas para sucesso ou erro nas operações.

---

## 🛠️ Tecnologias e Pacotes Utilizados

O projeto utiliza o ecossistema do Flutter e pacotes modernos para garantir performance, segurança e uma boa arquitetura:

- **[Flutter](https://flutter.dev/):** SDK principal (suporte para Dart ^3.10.8).
- **[Dio](https://pub.dev/packages/dio):** Cliente HTTP poderoso para comunicação com a API.
- **[Flutter Secure Storage](https://pub.dev/packages/flutter_secure_storage):** Armazenamento seguro de credenciais (Tokens de Autenticação).
- **[Flutter SVG](https://pub.dev/packages/flutter_svg):** Para renderização de vetores, ícones e logotipos com alta qualidade.
- **[Image Picker](https://pub.dev/packages/image_picker):** Para seleção de imagens e fotos de perfil.
- **[Top Snackbar Flutter](https://pub.dev/packages/top_snackbar_flutter):** Exibição de alertas e mensagens animadas no topo da tela.
- **[Intl](https://pub.dev/packages/intl):** Internacionalização e formatação de datas e moedas.
- **[Flutter Native Splash](https://pub.dev/packages/flutter_native_splash):** Geração de uma _splash screen_ nativa e elegante ao abrir o app.

---

## 📁 Estrutura do Projeto

O projeto segue uma arquitetura modular focada em separação de responsabilidades (Feature-Based):

```
lib/
├── assets/          # Imagens, SVGs e estilos globais (cores)
├── auth/            # Lógicas de interceptação e checagem de autenticação
├── components/      # Widgets reutilizáveis (botões, modais, formulários, cards)
├── core/            # Serviços core do app (ApiClient, TokenService)
├── features/        # Regras de negócio e Modelos
│   ├── auth/        # Controladores e modelos de autenticação
│   ├── transactions/# Gerenciamento e lógicas de transações/métricas
│   └── user/        # Controladores e modelos do usuário logado
├── helpers/         # Formatadores (datas, moeda) e utilitários
├── pages/           # Telas principais do aplicativo (Home, Login, Profile)
└── main.dart        # Ponto de entrada do aplicativo e rotas
```

---

## 🎨 Design e UI/UX

O aplicativo baseia-se em uma paleta de cores foca no contraste e conforto visual:

- **Background Principal:** `#121214` (Escuro profundo)
- **Fundo dos Cartões (Surface):** `#202024`
- **Cor Primária (Destaque):** `#00875F` (Verde)
- **Cor Secundária:** `#00B37E` (Verde claro)

---

## ⚙️ Como executar o projeto

1. Certifique-se de ter o [Flutter SDK](https://docs.flutter.dev/get-started/install) instalado na sua máquina.
2. Clone o repositório.
3. No terminal, na raiz do projeto, instale as dependências:
    ```bash
    flutter pub get
    ```
4. Execute o aplicativo em um emulador ou dispositivo físico:
    ```bash
    flutter run
    ```
