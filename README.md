# app_teste_tcc

A new Flutter project.

## Cadastro e API

O cadastro mantém os dados do responsável no app enquanto a criança e as
capturas faciais e os dados da câmera são preenchidos. Ao tocar em
`Cadastrar câmera`, o app envia `ip_camera` junto aos dados da conta e ao objeto
`perfil_crianca` em `POST /auth/cadastro/`. Em seguida, autentica o responsável
e envia `endereco_ip`, `nome_camara`, `localizacao` e `modelo` para
`POST /camera/`, que cria o registro da câmera e atualiza o IP do responsável.
As fotos são enviadas em Base64; a API deve decodificá-las para armazená-las
como binário.

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
