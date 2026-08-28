import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mindvibe_app/features/exercises/domain/breathing_cycle.dart';
import 'package:mindvibe_app/features/exercises/domain/exercise_parsers.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/attention_shape.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/breathing_exercise_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/prepared_exercise.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/daily_drill_view.dart';
import 'package:mindvibe_app/features/exercises/presentation/widgets/rating_exercise_view.dart';
import 'package:mindvibe_app/features/training/domain/entities/training_entities.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

Widget _app(Widget child) {
  return MaterialApp(
    locale: const Locale('pt', 'BR'),
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('rating mostra o prompt e envia o valor escolhido', (
    tester,
  ) async {
    int? selected;
    await tester.pumpWidget(
      _app(
        RatingExerciseView(
          config: const RatingConfig(
            min: 1,
            max: 5,
            prompt: 'Como está seu foco?',
          ),
          onSubmit: (value) => selected = value,
        ),
      ),
    );

    expect(find.text('Como está seu foco?'), findsOneWidget);
    await tester.tap(find.text('4'));
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pump();
    expect(selected, 4);
  });

  testWidgets('respiração começa no estado inspirar', (tester) async {
    await tester.pumpWidget(
      _app(
        BreathingExerciseView(
          config: const BreathingCycleConfig(
            inspiration: 4,
            hold: 2,
            expiration: 6,
            cycles: 1,
          ),
          onCompleted: (_) {},
        ),
      ),
    );

    expect(find.text('INSPIRAR'), findsOneWidget);
  });

  testWidgets('atenção mostra briefing, figura e escolha de tempo', (
    tester,
  ) async {
    var started = false;
    await tester.pumpWidget(
      _app(
        PreparedExercise(
          type: 'attention',
          target: AttentionSymbol.triangle,
          builder: (seconds) {
            started = seconds == 120;
            return Text('treino $seconds');
          },
        ),
      ),
    );

    expect(find.text('Atenção ao alvo'), findsOneWidget);
    expect(find.text('Toque só nesta figura'), findsOneWidget);
    expect(find.text('Quanto tempo você quer treinar?'), findsOneWidget);
    expect(find.byType(AttentionShape), findsOneWidget);

    await tester.tap(find.text('2 min'));
    await tester.pump();
    await tester.tap(find.text('Começar'));
    await tester.pump();

    expect(find.text('treino 120'), findsOneWidget);
    expect(started, isTrue);
  });

  testWidgets('categorias não conclui sem respostas digitadas', (tester) async {
    var done = false;
    await tester.pumpWidget(
      _app(
        DailyDrillView(
          exercise: const ExerciseSpec(
            id: 1,
            type: 'daily',
            title: 'Categorias',
            variant: 'categories',
          ),
          onCompleted: (_) => done = true,
        ),
      ),
    );
    await tester.pump();

    await tester.ensureVisible(find.text('Concluir'));
    await tester.tap(find.text('Concluir'));
    await tester.pump();
    expect(done, isFalse);
    expect(
      find.text(
        'Escreva pelo menos algumas respostas. Sem isso, o treino não conta.',
      ),
      findsOneWidget,
    );

    for (var i = 0; i < 5; i++) {
      await tester.enterText(find.byType(TextField), 'casa$i');
      await tester.tap(find.text('Adicionar'));
      await tester.pump();
    }
    await tester.ensureVisible(find.text('Concluir'));
    await tester.tap(find.text('Concluir'));
    await tester.pump();
    expect(done, isTrue);
  });

  testWidgets('recontar não conclui com o campo vazio', (tester) async {
    var done = false;
    await tester.pumpWidget(
      _app(
        DailyDrillView(
          exercise: const ExerciseSpec(
            id: 2,
            type: 'daily',
            title: 'Recontar',
            variant: 'retell',
          ),
          onCompleted: (_) => done = true,
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('Já li'));
    await tester.pump();

    await tester.tap(find.text('Concluir'));
    await tester.pump();
    expect(done, isFalse);

    await tester.enterText(
      find.byType(TextField),
      'O pássaro voou da janela aberta.',
    );
    await tester.pump();
    await tester.tap(find.text('Concluir'));
    await tester.pump();
    expect(done, isTrue);
  });
}
