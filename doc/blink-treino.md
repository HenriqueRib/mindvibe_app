# Treino de Piscar (Blink) — Pesquisa + Escopo App

Status: **pesquisa validada** · **escopo app aprovado** · **app implementado (2026-09-30)**  
Data: 2026-09-30  
Par: `mindvibe_api/doc/blink-treino.md`

---

## 1. Pesquisa (resumo)

Piscar completo espalha filme lacrimal e lipídios das Meibômio. Em telas, a taxa cai (~15–22 → ~4–7/min) e sobem piscadas incompletas → olho seco / digital eye strain.

**Treinar completude** (close–pause–squeeze–open) e micro-pausas com piscadas conscientes tem evidência de melhorar sintomas; benefício exige manutenção.

Disclaimer no app: hábito educativo/complementar, não diagnóstico nem tratamento médico.

Detalhes e fontes: ver doc da API.

---

## 2. Escopo App (aprovado junto com a API)

### Princípio

Espelhar o padrão **breathing**: type `blink` na library → hub opcional → player com fases timed → submit result.

Sem feature data layer nova: lista já vem de `TrainingRepository.listExercises()`.

### Variants e UX

| Variant | Player | Briefing sugerido |
|---------|--------|-------------------|
| `close_squeeze_open` | Fases: fechar → squeeze leve → abrir (reps) | “15 ciclos para treinar piscada completa” |
| `complete_blinks` | N piscadas lentas e completas | “Micro-série para usar na frente da tela” |
| `screen_break_20` | Olhar longe / countdown 20s + N blinks | “Pausa 20-20-20 com piscadas conscientes” |

### Config lida do JSON (API)

```dart
// campos esperados
variant, reps, sets_per_day,
phase_seconds: { close, squeeze, open },
duration_seconds?, // screen_break_20
disclaimer?
```

Defaults se faltar: close/squeeze/open = 2s; reps = 15 (CSO) ou 8 (micro) ou 5 (break).

### Fluxo de telas

1. **Library** (`/exercises`) — grupo `blink` com ícone/label próprios  
2. **Hub** (opcional v1) `/blink` — room card como breathing; lista variants  
3. **Practice** (`/practice`, `extra: ExerciseSpec`) — case `'blink'`  
4. **PreparedExercise** — briefing + (se fizer sentido) chips de duração ou “1 set agora”  
5. **BlinkExerciseView** — timer bar + animação/instrução por fase + contagem de ciclos  
6. **Submit** — `{ cycles_completed, duration_ms, completed: true, set_index? }`  
7. **Sessão de programa** — mesmo switch em `session_page` para bloco exercise blink  

### Peças novas (espelho breathing)

| Peça | Path sugerido |
|------|----------------|
| Domain engine | `lib/features/exercises/domain/blink_cycle.dart` |
| Player UI | `lib/features/exercises/presentation/widgets/blink_exercise_view.dart` |
| Hub (opcional) | `lib/features/exercises/presentation/pages/blink_hub_page.dart` |

### Wire-in existente

| Arquivo | Mudança |
|---------|---------|
| `practice_exercise_page.dart` | `case 'blink'` |
| `session_page.dart` | idem |
| `exercise_groups.dart` | order, icon, label, look/meta/sort |
| `prepared_exercise.dart` | briefings por `(type, variant)` |
| `app_routes.dart` + `app_router.dart` | rota `/blink` + redirect `?type=blink` se hub |
| l10n | strings de fases, briefing, disclaimer |
| testes | `test/features/exercises/` (engine + smoke UI se padrão existir) |

### UX do player (CSO)

1. Instrução clara por fase (texto + animação simples de pálpebras ou círculo)  
2. Fase atual + segundos restantes + ciclo `k / reps`  
3. Squeeze = **leve**, nunca “apertar forte” (copy cuidadosa)  
4. Ao terminar: confirmação + submit automático (como breathing)  
5. Disclaimer curto na briefing se `configuration.disclaimer == true`

### Fora de escopo (App v1)

- Câmera / ML de detecção de piscada  
- Lembretes push dedicados  
- Dashboard clínico / OSDI  
- Streaks/achievements só de blink (pode reusar XP genérico do submit)

### Critérios de pronto (App)

1. Library mostra grupo blink quando API retorna type `blink`  
2. Abrir exercise roda player com fases corretas da config  
3. Conclusão envia result e volta/feedback OK  
4. Bloco blink em sessão de programa funciona  
5. Copy + disclaimer presentes  
6. Teste do engine de fases (duração/ciclos)

---

## 3. Ordem de implementação (App)

1. ~~Domain `BlinkCycle` (config + engine) + testes~~
2. ~~`BlinkExerciseView` + wire em practice/session~~
3. ~~`exercise_groups` + briefings + l10n~~
4. ~~Hub `/blink`~~
5. Polimento visual futuro (opcional)

### O que foi entregue

| Peça | Path |
|------|------|
| Domain | `lib/features/exercises/domain/blink_cycle.dart` |
| Player | `lib/features/exercises/presentation/widgets/blink_exercise_view.dart` |
| Hub | `lib/features/exercises/presentation/pages/blink_hub_page.dart` |
| Rota | `/blink` (+ redirect `?type=blink`) |
| Wire | `practice_exercise_page`, `session_page`, `exercise_groups`, `prepared_exercise`, library |
| Testes | `test/features/exercises/blink_cycle_test.dart` |

**Depende da API no servidor** com type `blink` na library (seed + catalog). Sem isso o hub fica vazio.

---

## Gaps fechados (2026-09-30 · polish P0)

- [x] Card **Piscar** em `homeExploreItems` + rota `/blink` (premium)
- [x] Multi-set: `sets_per_day`, picker de set, diálogo “próximo set”, `set_index` no submit
- [x] Disclaimer condicional no briefing (`configuration.disclaimer`)
- [x] Copy library/menu + teste premium da rota blink

## Gaps ainda abertos

- Admin form tipado / playground 20-20-20
- Analytics com `variant` + `cycles_completed`
- Doc API commitado no git
- Blocos blink em programas wellness
- Testes widget smoke do player

---

## 4. Ordem global do feature

1. ~~Pesquisa~~  
2. ~~Escopo API~~  
3. ~~Escopo App + docs~~  
4. ~~Implementar API~~  
5. ~~Implementar App~~  
6. ~~P0 discoverability + multi-set~~  
7. Validar no simulador + gaps P1 admin
