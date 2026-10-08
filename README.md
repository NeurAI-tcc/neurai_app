# app_teste_tcc

A new Flutter project.

## Cadastro e API

O cadastro mantém os dados do responsável no app enquanto a criança e as
capturas faciais são preenchidas. Somente ao finalizar é enviado um único
`POST /auth/cadastro/` com os dados da conta, o objeto `perfil_crianca` e
`foto_sorrindo_url` em Base64. A API deve decodificar essa foto para armazená-la
como binário e persistir o documento completo.

O endereço padrão da API é `http://192.168.0.65:8000/api`. Para apontar o app
para outro host, configure a URL base na execução:

```sh
flutter run --dart-define=NEURAI_API_URL=http://<ip-do-servidor>:8000/api
```

HTTP sem TLS fica permitido apenas no build Android de depuração. Para builds
de produção e outras plataformas, use uma URL HTTPS.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
