# MindVibe — Academia Mental

Aplicativo Flutter (V1 Android). Consome a API em `mindvibe_api`.

Bundle provisório: `br.mindvibe.app`

## Etapa atual

Sessão completa do dia: player, exercícios (rating, breathing, attention, memory), progresso, notificação local, analytics e exclusão de conta.

## Rodar

A URL da API só entra por `--dart-define` (ou o default de produção):

```bash
# produção (default)
flutter run

# API local no emulador Android
flutter run --dart-define=API_URL=http://10.0.2.2:8000/api/v1

# aparelho físico na mesma rede
flutter run --dart-define=API_URL=http://SEU_IP:8000/api/v1
```

```bash
flutter analyze
flutter test
```

## Arquitetura

`Widget → Riverpod → UseCase/Repository → DataSource → API`

Regras de streak, XP, dia atual e `content_access` ficam no backend. O app só obedece.
