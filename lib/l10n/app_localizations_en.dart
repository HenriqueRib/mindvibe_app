// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MindVibe';

  @override
  String get appTagline => 'Mental Fitness';

  @override
  String get brandLine => 'A quiet place to train your mind.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabProfile => 'Profile';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionStart => 'Start training';

  @override
  String get actionLogin => 'Sign in';

  @override
  String get actionRegister => 'Create account';

  @override
  String get actionForgotPassword => 'Reset password';

  @override
  String get actionSend => 'Send';

  @override
  String get actionSave => 'Save';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionSubscribe => 'Subscribe';

  @override
  String get actionTransferDevice => 'Change device link';

  @override
  String get actionComingSoon => 'Coming soon';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPasswordConfirm => 'Confirm password';

  @override
  String get passwordShow => 'Show password';

  @override
  String get passwordHide => 'Hide password';

  @override
  String get fieldResetToken => 'Reset code';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationEmail => 'Enter a valid email.';

  @override
  String get validationPasswordMin => 'Password must be at least 8 characters.';

  @override
  String get validationPasswordMatch => 'Passwords do not match.';

  @override
  String get splashLoading => 'Preparing your space…';

  @override
  String get welcomeTitle => 'Welcome to MindVibe';

  @override
  String get welcomeBody =>
      'Just as you train your body at a gym, you can build a routine to train your mind.';

  @override
  String get welcomeLogin => 'I already have an account';

  @override
  String get welcomeRegister => 'Get started';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Pick up your training where you left off.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Email and password only. No social login.';

  @override
  String get forgotTitle => 'Reset password';

  @override
  String get forgotSubtitle => 'We will send a code to your email.';

  @override
  String get forgotSent =>
      'If this email is registered, you will receive instructions shortly.';

  @override
  String get resetTitle => 'Choose a new password';

  @override
  String get resetSubtitle => 'Use the code sent to your email.';

  @override
  String get resetSuccess =>
      'Password updated. Sign in with your new password.';

  @override
  String get deviceAssociatedTitle => 'This device already has an account';

  @override
  String deviceAssociatedBody(String email) {
    return 'This device already has an account registered with $email.';
  }

  @override
  String get deviceAssociatedHint =>
      'Sign in, reset the password, or change the device link after authenticating. We never create a new account silently.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorOffline =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get errorUnauthorized => 'Your session expired. Please sign in again.';

  @override
  String get errorNotFound => 'We could not find what you are looking for.';

  @override
  String get errorServer => 'The server is unavailable right now.';

  @override
  String get errorUpdateApp => 'Please update the app to continue.';

  @override
  String get onboardingWelcomeTitle => 'Let’s start slowly';

  @override
  String get onboardingWelcomeBody =>
      'In a few steps you choose what to strengthen and join your plan.';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingGoalTitle => 'What do you want to improve?';

  @override
  String get onboardingGoalHint =>
      'Pick one plan. You follow one at a time — you can switch later.';

  @override
  String get onboardingGoalFocusBody =>
      'Strengthen attention at work, study, and daily life. A 7-day plan.';

  @override
  String get onboardingGoalMindfulnessBody =>
      'Train presence and notice what is happening now, with more calm. A 5-day plan.';

  @override
  String get onboardingGoalMemoryBody =>
      'Remember with more clarity, at your pace. A 5-day plan.';

  @override
  String get onboardingGoalOthers => 'Other paths';

  @override
  String get onboardingExperienceTitle => 'How experienced are you?';

  @override
  String get onboardingReminderTitle => 'Want a daily reminder?';

  @override
  String get onboardingReminderBody =>
      'Local notification only, at the time you choose.';

  @override
  String get goalFocus => 'Focus';

  @override
  String get goalMemory => 'Memory';

  @override
  String get goalRelaxation => 'Relaxation';

  @override
  String get goalSleep => 'Sleep';

  @override
  String get goalHabit => 'Build the habit';

  @override
  String get goalBreathing => 'Breathing';

  @override
  String get goalMindfulness => 'Mindfulness';

  @override
  String get experienceBeginner => 'I am starting';

  @override
  String get experienceIntermediate => 'I have practiced a little';

  @override
  String get experienceExperienced => 'I already have a routine';

  @override
  String get reminderEnable => 'Remind me to train';

  @override
  String get reminderTime => 'Time';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeTodayTitle => 'Today’s training';

  @override
  String get homeQuestion => 'What should I do now?';

  @override
  String get homeStreak => 'Streak';

  @override
  String get homeMinutes => 'minutes';

  @override
  String homeDayProgress(int current, int total) {
    return 'day $current/$total';
  }

  @override
  String get homeCompleted => 'The next training unlocks tomorrow.';

  @override
  String get homeStartFirst => 'Start your first training';

  @override
  String get homeStartToday => 'Do today’s training';

  @override
  String get homeResumeTraining => 'Back to training';

  @override
  String get homeSeePlan => 'See my plan';

  @override
  String get homeCompletedEyebrow => 'Done for today';

  @override
  String homeTomorrowTraining(int day, String title) {
    return 'Unlocks tomorrow: day $day — $title';
  }

  @override
  String homeNextUnlocksOn(String date, int day, String title) {
    return 'Unlocks on $date: day $day — $title';
  }

  @override
  String get homeNoProgram => 'You are not enrolled in a training plan yet.';

  @override
  String get homeNoProgramBody =>
      'Choose what you want to improve and join your plan.';

  @override
  String get homeSessionSoon =>
      'The full session arrives in the next step. For now, this is your training for today.';

  @override
  String get homeNowTitle => 'Audio';

  @override
  String get homeNowBody =>
      'Open sessions you can listen to whenever you want.';

  @override
  String get homeNowSleep => 'Sleep';

  @override
  String get homeNowRelax => 'Relax';

  @override
  String get homeNowBreathe => 'Breathe';

  @override
  String get homeNowStudy => 'Study';

  @override
  String get homeNowWork => 'Work';

  @override
  String get homeNowAll => 'All';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get libraryAudiosTitle => 'All audio';

  @override
  String get libraryAudiosEmpty => 'No audio here right now.';

  @override
  String get librarySearch => 'Search';

  @override
  String get librarySearchHint => 'Search audio';

  @override
  String get libraryExercisesTitle => 'All exercises';

  @override
  String get libraryExercisesBody =>
      'Pick a short session and start whenever you want.';

  @override
  String get libraryExercisesEmpty => 'No published exercises right now.';

  @override
  String libraryMemoryMeta(int words, int seconds) {
    return '$words words · ${seconds}s to look';
  }

  @override
  String get libraryMemoryKindWords => 'Words · short term';

  @override
  String get libraryMemoryKindIcons => 'Pictures · visual';

  @override
  String get libraryMemoryKindOrder => 'Sequence';

  @override
  String get libraryMemoryKindDelayed => 'Hold in mind';

  @override
  String get libraryAttentionKindTarget => 'Tap only the target';

  @override
  String get libraryAttentionKindNogo => 'Tap everything except this';

  @override
  String get libraryAttentionKindChange => 'Tap when it changes';

  @override
  String get libraryAttentionKindGrid => 'Find the odd one out';

  @override
  String get libraryBreathingKindWave => 'Guided circle';

  @override
  String get libraryBreathingKindBox => 'Box 4-4-4-4';

  @override
  String get libraryBreathingKindLadder => '4-7-8';

  @override
  String get libraryBreathingKindTide => 'Tide · long exhale';

  @override
  String get libraryBreathingRoom => 'Breathing room';

  @override
  String get libraryBreathingRoomBody => 'Exercises and audio on one screen.';

  @override
  String get breathingHubTitle => 'Breathing';

  @override
  String get breathingHubBody =>
      'Guided exercises and audio to breathe at your own pace.';

  @override
  String get breathingHubExercises => 'Exercises';

  @override
  String get breathingHubAudios => 'Audio';

  @override
  String get breathingHubEmpty => 'No breathing content here right now.';

  @override
  String get homeExercisesTitle => 'Exercises';

  @override
  String get homeExercisesBody =>
      'Daily practice, attention, memory and breathing.';

  @override
  String get homeExerciseBreathing => 'Breathing';

  @override
  String get homeExerciseAttention => 'Attention';

  @override
  String get homeExerciseMemory => 'Memory';

  @override
  String get dailyHubTitle => 'Prática diária';

  @override
  String get dailyHubBody =>
      'Dez treinos curtos. A rotina de 15 minutos monta o dia por você.';

  @override
  String get dailyHubList => 'Escolha um treino';

  @override
  String get dailyStart => 'Começar';

  @override
  String get dailyFinish => 'Concluir';

  @override
  String get dailyNeedWrite =>
      'Escreva pelo menos algumas respostas. Sem isso, o treino não conta.';

  @override
  String get dailyNeedCount => 'Faça algumas contas antes de concluir.';

  @override
  String get dailyAdd => 'Adicionar';

  @override
  String dailyMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String dailyTimerLeft(int seconds) {
    return '$seconds s';
  }

  @override
  String get dailyCircuitTitle => 'Rotina de 15 minutos';

  @override
  String get dailyCircuitBody =>
      'Cinco minutos de concentração, cinco de memória, cinco de criatividade. Se a mente estiver saturada, inverte: sentidos, organização e silêncio.';

  @override
  String get dailyCircuitFocus => 'Hoje: treinar a mente.';

  @override
  String get dailyCircuitSaturated => 'Hoje: recuperar espaço.';

  @override
  String get dailyCircuitCta => 'Começar os 15 minutos';

  @override
  String get dailyRestToggle => 'Mente saturada hoje';

  @override
  String get dailyModeTrain => 'Treinar';

  @override
  String get dailyModeRest => 'Descansar';

  @override
  String get dailyReady => 'Já olhei';

  @override
  String get dailySkipThis => 'Pular esta';

  @override
  String get dailyLeaveTitle => 'Sair da rotina?';

  @override
  String get dailyLeaveBody => 'O passo atual não será guardado.';

  @override
  String get dailyLeaveConfirm => 'Sair';

  @override
  String get dailyDoneToday => 'Feito hoje';

  @override
  String get dailyHomeTitle => '15 minutos';

  @override
  String get dailyHomeCta => 'Rotina de hoje';

  @override
  String get dailyFamilyFocus => 'Concentração';

  @override
  String get dailyFamilyMemory => 'Memória';

  @override
  String get dailyFamilyPresence => 'Presença';

  @override
  String get dailyFamilyCreate => 'Criatividade';

  @override
  String dailyCircuitStep(int current, int total) {
    return '$current de $total';
  }

  @override
  String get dailyCircuitDone => 'Rotina concluída. Isso já é o treino.';

  @override
  String get dailyMetaObserve => '2 min · atenção';

  @override
  String get dailyMetaReverse => 'Memória de trabalho';

  @override
  String get dailyMetaCategories => '3 min · raciocínio';

  @override
  String get dailyMetaRetell => 'Compreensão';

  @override
  String get dailyMetaCountdown => 'Foco';

  @override
  String get dailyMetaSenses => 'Presente';

  @override
  String get dailyMetaTask => '10 min · uma coisa';

  @override
  String get dailyMetaUses => 'Criatividade';

  @override
  String get dailyMetaSort => 'Organizar a cabeça';

  @override
  String get dailyMetaSilence => '5 min · descanso';

  @override
  String get dailyObserveTitle => 'Observação consciente';

  @override
  String get dailyObserveBody =>
      'Escolha um objeto e observe. Cor, formato, textura, detalhes. Só isso.';

  @override
  String get dailyObservePick => 'O que você vai observar?';

  @override
  String dailyObserveLook(String object) {
    return 'Olhe para $object.';
  }

  @override
  String get dailyReverseTitle => 'Memória reversa';

  @override
  String get dailyReverseBody =>
      'Cinco palavras, números ou objetos. Depois, de trás para frente.';

  @override
  String get dailyReverseLook => 'Olhe. Depois some.';

  @override
  String get dailyReverseAsk => 'Toque de trás para frente.';

  @override
  String dailyReverseStep(int current, int total) {
    return '$current de $total';
  }

  @override
  String get dailyReverseHint => 'Próximo número';

  @override
  String get dailyReverseWrong => 'Não era esse. Tente o último que lembra.';

  @override
  String get dailyCategoriesTitle => 'Desafio das categorias';

  @override
  String get dailyCategoriesBody =>
      'Uma letra. Cinco animais, comidas, profissões e lugares.';

  @override
  String dailyCategoriesLetter(String letter) {
    return 'Letra $letter';
  }

  @override
  String get dailyRetellTitle => 'Recontar de memória';

  @override
  String get dailyRetellBody =>
      'Leia um texto curto. Depois explique com suas palavras.';

  @override
  String get dailyRetellRead => 'Leia com calma. Depois some o texto.';

  @override
  String get dailyRetellHide => 'Já li';

  @override
  String get dailyRetellWrite => 'Agora conte com suas palavras.';

  @override
  String get dailyRetellHint => 'O que ficou';

  @override
  String get dailyCountdownTitle => 'Contagem consciente';

  @override
  String get dailyCountdownBody =>
      'De 100 a 0, de 3 em 3. Se perder, volte ao último que lembra.';

  @override
  String get dailyCountdownAsk => 'Qual é o próximo, menos 3?';

  @override
  String get dailyCountdownMinus => 'menos 3';

  @override
  String get dailyCountdownHint => 'Próximo';

  @override
  String get dailyCountdownWrong => 'Volte ao último que lembra.';

  @override
  String get dailySensesTitle => 'Exercício dos sentidos';

  @override
  String get dailySensesBody =>
      'Cinco coisas que vê, quatro que toca, três sons, dois cheiros, uma no corpo.';

  @override
  String get dailySensesHint => 'Olhe em volta. Não precisa ser especial.';

  @override
  String get dailySensesSee => '5 coisas que você vê';

  @override
  String get dailySensesTouch => '4 que consegue tocar';

  @override
  String get dailySensesHear => '3 sons';

  @override
  String get dailySensesSmell => '2 cheiros';

  @override
  String get dailySensesFeel => '1 coisa no corpo';

  @override
  String get dailyTaskTitle => 'Uma tarefa por vez';

  @override
  String get dailyTaskBody =>
      'Dez minutos. Uma atividade. Sem celular e sem trocar.';

  @override
  String get dailyTaskPick => 'O que você vai fazer agora?';

  @override
  String dailyTaskDoing(String task) {
    return '$task. Só isto.';
  }

  @override
  String get dailyTaskPhone =>
      'Deixe o celular de lado. O timer continua aqui.';

  @override
  String get dailyUsesTitle => 'Usos de um objeto';

  @override
  String get dailyUsesBody => 'Um objeto comum. Dez usos diferentes.';

  @override
  String dailyUsesObject(String object) {
    return '10 usos para $object';
  }

  @override
  String get dailySortTitle => 'Diário mental';

  @override
  String get dailySortBody =>
      'Escreva o que está na cabeça. Depois separe: resolver, depois, ou não depende de mim.';

  @override
  String get dailySortDump => 'Tudo que está passando. Sem organizar.';

  @override
  String get dailySortHint => 'Uma coisa por linha';

  @override
  String get dailySortClassify => 'Classificar';

  @override
  String get dailySortPick => 'Onde cada uma fica?';

  @override
  String get dailySortResolve => 'Resolver';

  @override
  String get dailySortLater => 'Depois';

  @override
  String get dailySortNotMine => 'Não depende de mim';

  @override
  String get dailySilenceTitle => 'Silêncio intencional';

  @override
  String get dailySilenceBody =>
      'Cinco minutos sem aprender, assistir ou consumir. Só a respiração e os pensamentos passando.';

  @override
  String get dailySilenceHint => 'Não tente resolver nada. Observe o ar.';

  @override
  String get homeExploreTitle => 'The six rooms';

  @override
  String get homeExploreBody =>
      'Each point has its own program. Today’s training stays in the card above.';

  @override
  String get homeExploreAll => 'See plans';

  @override
  String get homeChoosePlan => 'Choose my plan';

  @override
  String get homeToolsTitle => 'Tools';

  @override
  String get homeToolsBody =>
      'A check-in, a full mind, a notebook and a way to close the night.';

  @override
  String get homeToolPomodoro => 'Pomodoro';

  @override
  String get homeToolCheckin => 'Check-in';

  @override
  String get homeToolClearMind => 'Full mind';

  @override
  String get homeToolJournal => 'Notebook';

  @override
  String get homeToolThought => 'Park';

  @override
  String get homeToolSilentRoom => 'Room';

  @override
  String get homeToolDayClose => 'Night';

  @override
  String get homeTagline => 'Breathe. Focus. Grow.';

  @override
  String get homeTodayEyebrow => 'Today\'s training';

  @override
  String get homeProgressSection => 'Your progress';

  @override
  String get homeKeepExploring => 'Keep exploring';

  @override
  String get homeAreaProgress => 'Your progress by area';

  @override
  String get homeNextTraining => 'Next training';

  @override
  String get homeMyTools => 'My tools';

  @override
  String get homeNumbersTitle => 'Your moment in numbers';

  @override
  String get homeQuote => 'Small daily choices build a stronger, calmer mind.';

  @override
  String get homeStatDays => 'Days';

  @override
  String get homeStatTrained => 'Trained';

  @override
  String get homeNowFocus => 'Focus';

  @override
  String get homeNowMemory => 'Memory';

  @override
  String get homeNowMindfulness => 'Mindfulness';

  @override
  String get homeCurrentStreak => 'Current streak';

  @override
  String get menuOpen => 'Academy menu';

  @override
  String get menuClose => 'Close menu';

  @override
  String get menuTitle => 'Mental Academy';

  @override
  String get menuSubtitle => 'Every room, in one place.';

  @override
  String get menuSectionTrain => 'Training';

  @override
  String get menuSectionAudio => 'Audio';

  @override
  String get menuSectionExercise => 'Exercises';

  @override
  String get menuSectionTools => 'Tools';

  @override
  String get menuSectionJourney => 'Journey';

  @override
  String get menuToday => 'Today\'s training';

  @override
  String get menuTodayHint => 'Your session for the day';

  @override
  String get menuPlans => 'Programs';

  @override
  String get menuPlansHint => 'The academy rooms';

  @override
  String get menuMyPlan => 'My plan';

  @override
  String get menuMyPlanHint => 'Days done and what’s next';

  @override
  String get menuExercisesHint => 'Atenção, memória e respiração';

  @override
  String get menuRoomHint => 'A full program';

  @override
  String get menuAudios => 'Library';

  @override
  String get menuAudiosHint => 'Listen at your own pace';

  @override
  String get menuSleepHint => 'Sounds for the night';

  @override
  String get menuRelaxHint => 'Ease the body and mind';

  @override
  String get menuFocusAudio => 'Focus audio';

  @override
  String get menuFocusAudioHint => 'A track for concentration';

  @override
  String get menuAttentionHint => 'Target training';

  @override
  String get menuMemoryHint => 'Words and presence';

  @override
  String get menuBreathingHint => 'A guided rhythm';

  @override
  String get menuDailyHint => 'Ten short drills and 15 minutes';

  @override
  String get menuPomodoroHint => 'Focus blocks';

  @override
  String get menuCheckinHint => 'Mood and energy';

  @override
  String get menuClearMindHint => 'One thing for today';

  @override
  String get menuJournalHint => 'Three lines, yours only';

  @override
  String get menuThoughtHint => 'Write, park, move on';

  @override
  String get menuSilentRoomHint => 'A presence block';

  @override
  String get menuDayCloseHint => 'Two minutes to close';

  @override
  String get menuProgressHint => 'Streak, climate and time';

  @override
  String get menuHistoryHint => 'Everything you did';

  @override
  String get menuRankingHint => 'Who is training';

  @override
  String get menuProfileHint => 'Account and preferences';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogEmpty => 'No published programs right now.';

  @override
  String catalogDays(int count) {
    return '$count days';
  }

  @override
  String catalogDayItem(int day, String title) {
    return 'Day $day · $title';
  }

  @override
  String get catalogBrowseHint =>
      'One plan at a time. If you switch, the current plan’s progress and report start over.';

  @override
  String catalogFreeDays(int count) {
    return '$count free days';
  }

  @override
  String get catalogPlanDays => 'The days of the plan';

  @override
  String get catalogEnroll => 'Start this plan';

  @override
  String get catalogEnrollCurrent => 'This is your plan';

  @override
  String get catalogSwitch => 'Switch to this plan';

  @override
  String get catalogSwitchTitle => 'Switch plans?';

  @override
  String get catalogSwitchBody =>
      'You can follow only one plan at a time. The progress and report of your current plan will be reset.';

  @override
  String get catalogSwitchConfirm => 'Switch anyway';

  @override
  String get momentListen => 'Listen';

  @override
  String get prepareStart => 'I’m ready';

  @override
  String sessionElapsed(String time) {
    return 'Time $time';
  }

  @override
  String get themeSection => 'Theme';

  @override
  String get themeSectionHint =>
      'Night theme gives breathing and the session a dark background.';

  @override
  String get themeDark => 'Night theme';

  @override
  String get themeDarkHint => 'Black background in the session and breathing.';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSectionHint => 'Choose the app language.';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get homeLayoutSection => 'Home layout';

  @override
  String get homeLayoutSectionHint => 'Choose how the home screen looks.';

  @override
  String get homeLayoutToday => 'Today\'s training';

  @override
  String get homeLayoutTodayHint =>
      'A scene of the day with today\'s session in focus.';

  @override
  String get homeLayoutTraining => 'Training first';

  @override
  String get homeLayoutTrainingHint => 'A large card to start right away.';

  @override
  String get homeLayoutProgress => 'Progress first';

  @override
  String get homeLayoutProgressHint => 'Streak, areas and the next session.';

  @override
  String get playerLoadError =>
      'The audio could not be played. Check your connection and try again.';

  @override
  String get playerReplay => 'Play again';

  @override
  String get paywallTitle => 'Continue with Premium';

  @override
  String get paywallBody =>
      'Extra audios, exercises and tools are part of Premium. The first days of the plan stay free.';

  @override
  String get paywallFreeLabel => 'Livre agora';

  @override
  String get paywallFreeList =>
      'Check-in, caderno, Mente cheia e os primeiros dias do seu plano.';

  @override
  String get paywallPremiumLabel => 'No Premium';

  @override
  String get paywallPremiumList =>
      'Áudios, prática diária, exercícios, pomodoro, sala silenciosa, pensamentos e o restante do plano.';

  @override
  String get paywallCtaSoon => 'Subscription coming soon';

  @override
  String get paywallCta => 'Subscribe to Premium';

  @override
  String get paywallCtaRenew => 'Renew Premium';

  @override
  String paywallCtaPrice(String price, String period) {
    return 'Subscribe to Premium · $price/$period';
  }

  @override
  String paywallPriceHint(String price, String period) {
    return '$price every $period, via Mercado Pago.';
  }

  @override
  String get paywallWaiting =>
      'Checkout opened in the browser. When you return, the app confirms the status.';

  @override
  String get paywallOpenError => 'Could not open checkout. Try again.';

  @override
  String get billingTitle => 'Subscription';

  @override
  String get billingHistoryTitle => 'Payment history';

  @override
  String get billingHistoryEmpty =>
      'Charges will show up here after a payment.';

  @override
  String get billingPeriodMonth => 'month';

  @override
  String billingPeriodDays(int count) {
    return '$count days';
  }

  @override
  String billingValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get billingStatusActive => 'Premium active';

  @override
  String get billingStatusPending => 'Waiting for confirmation';

  @override
  String get billingStatusFailed => 'Payment not approved';

  @override
  String get billingStatusExpired => 'Subscription ended';

  @override
  String get billingStatusNone => 'No subscription';

  @override
  String get billingPaymentApproved => 'Approved';

  @override
  String get billingPaymentPending => 'Pending';

  @override
  String get billingPaymentFailed => 'Not approved';

  @override
  String get billingPaymentRefunded => 'Refunded';

  @override
  String get profilePlanFree => 'Plano gratuito';

  @override
  String get profilePlanPremium => 'Premium';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileLogoutConfirm => 'Log out on this device?';

  @override
  String get profilePlaceholder =>
      'Account settings, reminders and account deletion come next.';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressPlaceholder =>
      'Your history, XP and day-7 report will appear here in the next step.';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteConfirm => 'Delete your account?';

  @override
  String get profileDeleteConfirmBody =>
      'Your account will stop working on this device. This cannot be undone here.';

  @override
  String get profileTerms => 'Terms of use';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileLegalPlaceholder =>
      'The legal text will be published later. This is only a reserved shortcut for now.';

  @override
  String get profileSaved => 'Profile updated.';

  @override
  String get profileEditName => 'Change name';

  @override
  String get profileNameHint => 'How you want to appear on the ranking.';

  @override
  String get profileAvatarHint =>
      'Tap the photo to pick a gallery image or a calm symbol. It shows on the ranking.';

  @override
  String get profilePhotoGallery => 'Choose from gallery';

  @override
  String get profileEmojiChoose => 'Use a symbol';

  @override
  String get profileEmojiTitle => 'A symbol for the ranking';

  @override
  String get profileEmojiBody =>
      'No selfie? Pick a quiet icon from the mental gym.';

  @override
  String get profilePhotoRemove => 'Remove photo';

  @override
  String get profileLegalOpenError => 'The page could not be opened right now.';

  @override
  String get profileMessageTitle => 'Message the team';

  @override
  String get profileMessageTileBody =>
      'A suggestion, a new idea, or a thank you.';

  @override
  String get profileMessageBody =>
      'Tell us what you missed, a new idea, or a thank you. Each message becomes a ticket we read.';

  @override
  String get profileMessageTypeSuggestion => 'Improvement';

  @override
  String get profileMessageTypeFeature => 'New feature';

  @override
  String get profileMessageTypeThanks => 'Thanks';

  @override
  String get profileMessageField => 'Your message';

  @override
  String get profileMessageHint =>
      'Keep it simple. What would help your training?';

  @override
  String get profileMessageTooShort =>
      'Write a little more so we can understand.';

  @override
  String get profileMessageSent => 'Message sent. Thank you for writing.';

  @override
  String get progressXp => 'XP';

  @override
  String get progressLevel => 'Level';

  @override
  String get progressSessions => 'Sessions';

  @override
  String get progressJourneyTitle => 'Your journey';

  @override
  String get progressTimeHint =>
      'Plan training and free audio, added together.';

  @override
  String get progressTimeUnderMinute => 'Under 1 min';

  @override
  String progressTimeOnlyMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String progressTimeHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String progressTimeCompactMinutes(int minutes) {
    return '${minutes}min';
  }

  @override
  String progressTimeCompactHours(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get progressEmptyTitle => 'Your journey is just beginning';

  @override
  String get progressEmptyBody =>
      'Complete your first training to take the first step. It only takes a few minutes.';

  @override
  String get progressEmptyCta => 'Start my first training';

  @override
  String get progressStreakTitle => 'Your current streak';

  @override
  String progressStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String progressHeroStats(String time, int count) {
    return '$time trained · $count sessions';
  }

  @override
  String get progressMoreTitle => 'More';

  @override
  String get progressStatTrained => 'trained';

  @override
  String get progressProgramTitle => 'Your program';

  @override
  String progressProgramDay(int current, int total) {
    return 'Day $current of $total';
  }

  @override
  String progressProgramDaysDone(int done, int total) {
    return '$done of $total days completed';
  }

  @override
  String get progressContinue => 'Continue training';

  @override
  String get progressWeekRhythmTitle => 'Your rhythm';

  @override
  String progressWeekDaysTrained(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You trained $count days this week',
      one: 'You trained 1 day this week',
    );
    return '$_temp0';
  }

  @override
  String progressWeekDeltaUp(String time) {
    return '+$time vs last week';
  }

  @override
  String progressWeekDeltaDown(String time) {
    return '$time less than last week';
  }

  @override
  String get progressMilestoneTitle => 'Next milestone';

  @override
  String progressMilestoneXp(int xp) {
    return '$xp XP to the next level';
  }

  @override
  String progressMilestoneXpBar(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String progressMilestoneStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneStreakRemain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneMinutes(int minutes) {
    return '$minutes minutes trained';
  }

  @override
  String progressMilestoneMinutesBar(int current, int target) {
    return '$current / $target min';
  }

  @override
  String get progressRecentTitle => 'Recent activity';

  @override
  String get progressSeeHistory => 'See history';

  @override
  String get rankingTitle => 'World ranking';

  @override
  String get rankingCardTitle => 'World ranking';

  @override
  String get rankingCardBody =>
      'See who is training around the world. Joining is optional.';

  @override
  String get rankingPeriodAll => 'All time';

  @override
  String get rankingPeriodWeekly => 'This week';

  @override
  String get rankingOptInTitle => 'Appear on the ranking';

  @override
  String get rankingOptInBody =>
      'Your name, photo or symbol, and XP become visible to other people in the app. You can leave whenever you want.';

  @override
  String get rankingOptInCta => 'Join the ranking';

  @override
  String get rankingOptOut => 'Leave the ranking';

  @override
  String get rankingEmpty =>
      'Nobody is on the ranking yet. You can be the first.';

  @override
  String rankingPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people on the ranking',
      one: '1 person on the ranking',
      zero: 'Nobody on the ranking yet',
    );
    return '$_temp0';
  }

  @override
  String get rankingYourPlace => 'Your place';

  @override
  String get rankingUnranked => 'Not on the ranking';

  @override
  String rankingXp(int xp) {
    return '$xp XP';
  }

  @override
  String rankingRank(int rank) {
    return '#$rank';
  }

  @override
  String get rankingYou => 'You';

  @override
  String get profileRanking => 'Appear on the ranking';

  @override
  String get profileRankingHint =>
      'Name, photo or symbol, and XP visible to other people.';

  @override
  String progressLevelName(String name) {
    return 'Current level: $name';
  }

  @override
  String get progressXpCardBody => 'It comes from training. Tap to see how.';

  @override
  String get progressChapterTitle => 'Current chapter';

  @override
  String get progressPathTitle => 'The path';

  @override
  String get progressJourneyStart => 'Start';

  @override
  String get progressJourneyWarm => 'First steps';

  @override
  String get progressJourneyRhythm => 'Rhythm';

  @override
  String get progressJourneyWalk => 'Path';

  @override
  String get progressJourneyDeep => 'Presence';

  @override
  String get progressJourneyConstancy => 'Constancy';

  @override
  String get progressJourneyCopy0 =>
      'You\'re at the beginning. One minute is already presence.';

  @override
  String get progressJourneyCopy1 => 'The first minutes already open the path.';

  @override
  String get progressJourneyCopy2 =>
      'Rhythm is showing up. Keep going, unhurried.';

  @override
  String get progressJourneyCopy3 =>
      'Your journey already has shape. This is real training.';

  @override
  String get progressStreakHint => 'days in motion';

  @override
  String get progressWeekChartTitle => 'This week';

  @override
  String get progressWeekChartEmpty =>
      'No time logged this week yet. A session or a track will show up here.';

  @override
  String progressWeekChartTotal(String time) {
    return '$time this week';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historyCardTitle => 'History';

  @override
  String get historyCardBody => 'Everything you did in the app.';

  @override
  String get historyEmpty =>
      'A training, an audio, an exercise, a pomodoro, a check-in or the notebook will show up here.';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String historyWhen(String weekday, String time) {
    return '$weekday at $time';
  }

  @override
  String get historyTypeExercise => 'Exercise';

  @override
  String get historyTypeSession => 'Training';

  @override
  String get historyTypeListen => 'Audio';

  @override
  String get historyTypePomodoro => 'Pomodoro';

  @override
  String get historyTypeCheckin => 'Check-in';

  @override
  String get historyTypeJournal => 'Notebook';

  @override
  String get historyTypeThought => 'Thought';

  @override
  String get historyTypeClearMind => 'Full mind';

  @override
  String get historyTypeDayClose => 'Closing';

  @override
  String get historyTypeSilentRoom => 'Quiet room';

  @override
  String get sessionPrepareTitle => 'Get ready';

  @override
  String sessionPrepareBody(int minutes) {
    return 'Find a calm place. This training takes about $minutes minutes. There may be audio: sound does not start on its own. If you are in a classroom or with other people, use headphones and tap play only when you are ready.';
  }

  @override
  String get sessionAudioWait =>
      'Audio does not start on its own. Tap play when you are in a calm place. If you are in a classroom or with other people, use headphones.';

  @override
  String get sessionAudioObjectiveTitle => 'In this audio';

  @override
  String get sessionAudioObjectiveFallback =>
      'As you listen, stay with the audio at your own pace. If your mind wanders, notice and return.';

  @override
  String get sessionCompleteTitle => 'Training complete';

  @override
  String get sessionSeeYouTomorrow => 'See you tomorrow';

  @override
  String get sessionCompletingTitle => 'Saving your training';

  @override
  String get sessionCompletingBody => 'One more moment in the Mental Academy.';

  @override
  String get sessionLoadingTitle => 'Preparing your training';

  @override
  String get sessionLoadingBody =>
      'Find a quiet place. The Mental Academy is about to begin.';

  @override
  String get planTitle => 'My plan';

  @override
  String get planUniqueHint => 'One plan at a time';

  @override
  String get planCadenceTitle => 'Training rhythm';

  @override
  String get planCadenceBody =>
      'You follow one plan at a time. The next day unlocks on your next training day, in your timezone. The same exercises can appear in other plans, but this is your curriculum now.';

  @override
  String get planCadenceDaily => 'Every day';

  @override
  String get planCadenceWeekdays => 'Weekdays';

  @override
  String get planCadenceHintDaily =>
      'The next training unlocks the following day in your timezone.';

  @override
  String get planCadenceHintWeekdays =>
      'Monday to Friday. If you finish on Friday, the next day unlocks on Monday.';

  @override
  String get planReminderHint => 'The reminder arrives at the time you choose.';

  @override
  String get planEmpty => 'You are not in a plan yet.';

  @override
  String planDaysDone(int done, int total) {
    return '$done of $total days';
  }

  @override
  String get planSettings => 'Rhythm and reminder';

  @override
  String get planDoneForToday => 'Done for today.';

  @override
  String planNextUnlocksTomorrow(String title) {
    return 'Unlocks tomorrow: $title';
  }

  @override
  String planNextTraining(String title, String date) {
    return 'Unlocks on $date: $title';
  }

  @override
  String get planDayDone => 'Done';

  @override
  String get planDayToday => 'Today';

  @override
  String get planDayTomorrow => 'Tomorrow';

  @override
  String planDayLocked(String date) {
    return 'Unlocks on $date';
  }

  @override
  String planDayLabel(int day, String title) {
    return 'Day $day — $title';
  }

  @override
  String sessionXpAwarded(int xp) {
    return '+$xp XP';
  }

  @override
  String sessionBlockOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get breathingInhale => 'INHALE';

  @override
  String get breathingHold => 'HOLD';

  @override
  String get breathingExhale => 'EXHALE';

  @override
  String get breathingRest => 'REST';

  @override
  String breathingCycle(int current, int total) {
    return 'cycle $current/$total';
  }

  @override
  String get playerPlay => 'Play';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerNext => 'Next';

  @override
  String get playerNowPlaying => 'Now playing';

  @override
  String get playerVolume => 'Volume';

  @override
  String get playerCoverExpand => 'Expand cover';

  @override
  String get playerPrevious => 'Previous';

  @override
  String get playerRepeat => 'Repeat';

  @override
  String get playerFavorite => 'Favorite';

  @override
  String get playerFavorited => 'Saved';

  @override
  String get playerTimer => 'Timer';

  @override
  String get playerTimerOff => 'No timer';

  @override
  String get playerAboutTitle => 'About this session';

  @override
  String get playerAboutBody =>
      'Listen at your own pace. Pause whenever you need and come back when it feels right.';

  @override
  String get attentionPrompt => 'Tap only when the target appears.';

  @override
  String get attentionBriefingTitle => 'Target attention';

  @override
  String get attentionBriefingBody =>
      'Shapes will appear. Tap only the figure below. If another one shows up, don’t tap. The pace speeds up gradually.';

  @override
  String get attentionBriefingNogoTitle => 'Hold the tap';

  @override
  String get attentionBriefingNogoBody =>
      'Tap every shape except the one below. The training is to hold the impulse.';

  @override
  String get attentionBriefingChangeTitle => 'When it changes';

  @override
  String get attentionBriefingChangeBody =>
      'Tap only when the shape is different from the previous one. If it’s the same, wait.';

  @override
  String get attentionBriefingGridTitle => 'Find the odd one';

  @override
  String get attentionBriefingGridBody =>
      'Nine shapes appear together. Tap only the one that doesn’t match the others.';

  @override
  String get attentionTargetLabel => 'Tap only this shape';

  @override
  String get attentionNogoLabel => 'Don’t tap this shape';

  @override
  String get attentionChangeLabel => 'Tap when the shape changes';

  @override
  String get attentionGridLabel => 'Tap the odd one out';

  @override
  String get attentionPreviousLabel => 'Previous';

  @override
  String get breathingBriefingTitle => 'Guided breathing';

  @override
  String get breathingBriefingBody =>
      'Follow the circle. Inhale, hold and exhale with the rhythm. No rush, no perfection.';

  @override
  String get breathingBriefingBoxTitle => 'Box breathing';

  @override
  String get breathingBriefingBoxBody =>
      'A square, four sides. Inhale, hold, exhale and rest. The dot walks with you.';

  @override
  String get breathingBriefingLadderTitle => '4-7-8';

  @override
  String get breathingBriefingLadderBody =>
      'Inhale for 4, hold for 7, exhale for 8. The column rises and falls with the breath.';

  @override
  String get breathingBriefingTideTitle => 'Long tide';

  @override
  String get breathingBriefingTideBody =>
      'The exhale is longer than the inhale. Follow the tide in and out. Don’t force it.';

  @override
  String get memoryBriefingTitle => 'Word memory';

  @override
  String get memoryBriefingBody =>
      'First look at the words. Then mark only the ones you remember.';

  @override
  String get memoryBriefingIconsTitle => 'Visual memory';

  @override
  String get memoryBriefingIconsBody =>
      'Look at the pictures. Then mark only the ones you saw.';

  @override
  String get memoryBriefingOrderTitle => 'Sequence memory';

  @override
  String get memoryBriefingOrderBody =>
      'Words appear one by one. Then tap them in the same order.';

  @override
  String get memoryBriefingDelayedTitle => 'Hold in mind';

  @override
  String get memoryBriefingDelayedBody =>
      'Look, wait a little with what remains, then mark what you remember.';

  @override
  String get exerciseBriefingStart => 'Start';

  @override
  String get exerciseDurationLabel => 'How long do you want to train?';

  @override
  String exerciseDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String attentionHits(int count) {
    return 'Hits: $count';
  }

  @override
  String attentionMisses(int count) {
    return 'Misses: $count';
  }

  @override
  String get memoryStudyTitle => 'Look at the words';

  @override
  String get memorySelectTitle => 'Which words do you remember?';

  @override
  String get memoryStudyIconsTitle => 'Look at the pictures';

  @override
  String get memorySelectIconsTitle => 'Which pictures did you see?';

  @override
  String get memoryHoldTitle => 'Hold them in mind';

  @override
  String get memoryHoldBody =>
      'They’re gone from the screen. Stay with what remains, without rehearsing.';

  @override
  String get memoryOrderStudyTitle => 'Watch the order';

  @override
  String get memoryOrderSelectTitle => 'Tap in the same order';

  @override
  String get memoryOrderReset => 'Start over';

  @override
  String get memoryWordsTitle => 'My words';

  @override
  String get memoryWordsHint =>
      'Add your own words. They join the exercise, shuffled in a new order each time.';

  @override
  String get memoryWordsAdd => 'Add my words';

  @override
  String get memoryWordsEmpty =>
      'You have no custom words yet. Training uses a random set.';

  @override
  String get memoryWordsField => 'New word';

  @override
  String memoryWordsCount(int count) {
    return '$count of your words';
  }

  @override
  String get ratingSelect => 'Choose a value';

  @override
  String get unknownExercise => 'Please update the app for this exercise.';

  @override
  String get exerciseRoomDone => 'Session complete.';

  @override
  String get notificationTitle => 'MindVibe';

  @override
  String get notificationBody => 'Today’s training is waiting for you. 🧠';

  @override
  String get actionDelete => 'Delete account';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String get pomodoroHint => '25 minutes of attention, 5 of rest. No pressure.';

  @override
  String get pomodoroFocus => 'Focus';

  @override
  String get pomodoroBreak => 'Break';

  @override
  String get pomodoroStart => 'Start';

  @override
  String get pomodoroPause => 'Pause';

  @override
  String get pomodoroReset => 'Reset';

  @override
  String get pomodoroPresetClassic => '25 + 5';

  @override
  String get pomodoroPresetShort => '15 + 5';

  @override
  String get pomodoroPresetLong => '50 + 10';

  @override
  String pomodoroRounds(int count) {
    return '$count blocks done';
  }

  @override
  String get checkinTitle => 'Check-in';

  @override
  String get checkinHint =>
      'How are you right now? One tap on each axis. Ten seconds.';

  @override
  String get checkinMoodTitle => 'Mood';

  @override
  String get checkinEnergyTitle => 'Energy';

  @override
  String checkinMood(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Very heavy',
      '2': 'Heavy',
      '3': 'Neutral',
      '4': 'Light',
      '5': 'Good',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinEnergy(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Drained',
      '2': 'Low',
      '3': 'Medium',
      '4': 'Steady',
      '5': 'High',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinWeight(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'A heavy day',
      '2': 'A quieter day',
      '3': 'A balanced day',
      '4': 'A moving day',
      '5': 'A light day',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get checkinSaved => 'Saved. This becomes today’s climate on progress.';

  @override
  String get checkinSaving => 'Saving…';

  @override
  String get checkinSeeProgress => 'See on progress';

  @override
  String get checkinUpdateHint => 'Tap again if the day has changed.';

  @override
  String get checkinPromptLater => 'Not now';

  @override
  String get progressCheckinTitle => 'Today’s climate';

  @override
  String get progressCheckinEmpty => 'How is the day? Ten seconds, one tap.';

  @override
  String get progressCheckinCta => 'Check in';

  @override
  String progressCheckinBody(String mood, String energy) {
    return 'Mood $mood · Energy $energy';
  }

  @override
  String get progressStreakCheckinHint =>
      'The streak is showing up. Climate explains the weight of the day better than minutes alone.';

  @override
  String get clearMindTitle => 'Full mind';

  @override
  String get clearMindIntro =>
      'This is not the time for more information. It is time to slow down and recover space.';

  @override
  String get clearMindStart => 'Start';

  @override
  String get clearMindPauseBody =>
      'Step back. Breathe. Don’t try to solve anything.';

  @override
  String get clearMindSkipPause => 'I already breathed';

  @override
  String get clearMindDumpBody =>
      'Write what is going through your head. Don’t organize it yet.';

  @override
  String get clearMindDumpHint => 'What won’t let go';

  @override
  String get clearMindAdd => 'One more';

  @override
  String get clearMindDumpNext => 'Continue';

  @override
  String get clearMindQuestion =>
      'Of all these things in your head right now, which is the only one that really needs your attention today?';

  @override
  String get clearMindPickHint => 'Tap one. The rest can wait.';

  @override
  String get clearMindKeepOne => 'Keep this one';

  @override
  String get clearMindDoneEyebrow => 'Today, only this';

  @override
  String clearMindParked(int count) {
    return 'The rest was parked ($count). It does not need to be solved today.';
  }

  @override
  String get clearMindParkedNone => 'Just this. Nothing else to park.';

  @override
  String get clearMindDone => 'Done';

  @override
  String get clearMindSeeLot => 'See the lot';

  @override
  String get clearMindOneThing => 'One thing at a time';

  @override
  String get clearMindHomeCard => 'Today, only this';

  @override
  String get clearMindHomeCta => 'Mind full? Unload it and keep one thing.';

  @override
  String get clearMindFromCheckin => 'Is your mind full?';

  @override
  String get journalTitle => 'Notebook';

  @override
  String get journalHint =>
      'Three lines. A morning intention, emptying the head, or 3 gratitudes. Short, private, back tomorrow.';

  @override
  String journalPrompt(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'Morning intention',
      'unload': 'Empty the head',
      'gratitude': '3 gratitudes',
      'other': 'Notebook',
    });
    return '$_temp0';
  }

  @override
  String journalPromptHint(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'What you carry into the day.',
      'unload': 'Put down what is taking up space.',
      'gratitude': 'Three small things that are still here.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get journalIntention1 => 'What matters today?';

  @override
  String get journalIntention2 => 'One small step';

  @override
  String get journalIntention3 => 'How I want to arrive tonight';

  @override
  String get journalUnload1 => 'What is occupying my head?';

  @override
  String get journalUnload2 => 'What can wait';

  @override
  String get journalUnload3 => 'What I let go of now';

  @override
  String get journalGratitude1 => 'One good thing';

  @override
  String get journalGratitude2 => 'Another';

  @override
  String get journalGratitude3 => 'One more';

  @override
  String get journalSave => 'Save';

  @override
  String get journalUpdate => 'Update today';

  @override
  String get journalSaved =>
      'Saved. Only you can read this. Tomorrow the notebook comes back empty.';

  @override
  String get journalPrivate =>
      'Nobody else sees this. Not even on the ranking.';

  @override
  String get journalWeek => 'Days you wrote';

  @override
  String get silentRoomTitle => 'Quiet room';

  @override
  String get silentRoomHint =>
      'One presence block. No cycle, no break. For when Pomodoro feels heavy.';

  @override
  String get silentRoomPresence => 'Presence';

  @override
  String get silentRoomDone => 'Block complete';

  @override
  String silentRoomMinutes(int count) {
    return '$count min';
  }

  @override
  String get thoughtTitle => 'Park the thought';

  @override
  String get thoughtHint =>
      'Write what’s occupying your mind. Save it and move on — to training, audio, or sleep.';

  @override
  String get thoughtPlaceholder => 'What won’t let go';

  @override
  String get thoughtSave => 'Park and continue';

  @override
  String get thoughtSaved => 'It’s parked. Your mind can move on.';

  @override
  String get thoughtPrivate =>
      'Only you can read this. It never goes to the ranking.';

  @override
  String get thoughtContinue => 'Move on to';

  @override
  String get thoughtContinueTraining => 'Training';

  @override
  String get thoughtContinueAudio => 'Audio';

  @override
  String get thoughtContinueSleep => 'Sleep';

  @override
  String get thoughtLot => 'Parked';

  @override
  String get thoughtLotEmpty => 'Nothing parked.';

  @override
  String get thoughtLotFull => 'The lot is full. Let one go to park another.';

  @override
  String get thoughtRelease => 'Let go';

  @override
  String get dayCloseTitle => 'Close the day';

  @override
  String get dayCloseHint =>
      'Two minutes. What stayed, what you let go, a short audio. Close the academy the way training closes the day in the body.';

  @override
  String get dayCloseKept => 'What stayed';

  @override
  String get dayCloseReleased => 'What you let go';

  @override
  String get dayCloseSave => 'Close the day';

  @override
  String get dayCloseUpdate => 'Update today';

  @override
  String get dayCloseSaved =>
      'The day is closed. Only you can read this. Now the short audio.';

  @override
  String get dayClosePrivate =>
      'Only you can read this. It never goes to the ranking.';

  @override
  String get dayCloseAudio => 'Short audio';

  @override
  String get dayClosePlay => 'Listen';

  @override
  String get dayCloseWeek => 'Nights you closed';

  @override
  String get xpInfoTitle => 'About XP';

  @override
  String get xpInfoLead =>
      'XP grows when you finish a training session. Tools and audio stay with the day — they don’t add points.';

  @override
  String get xpInfoGivesTitle => 'What gives XP';

  @override
  String get xpInfoGivesBody =>
      'Completing a program session. Finishing a cycle. Achievements tied to training.';

  @override
  String get xpInfoSkipsTitle => 'What doesn’t';

  @override
  String get xpInfoSkipsBody =>
      'Check-in, full mind, notebook, parking a thought, closing the day, Pomodoro, the quiet room, and listening to audio. They live in history and climate. No XP.';

  @override
  String get xpInfoWhereTitle => 'Where it shows';

  @override
  String get xpInfoWhereBody =>
      'On Progress, on home, and at the end of a session. On the ranking, only if you choose to appear.';

  @override
  String get xpInfoStreakTitle => 'Streak';

  @override
  String get xpInfoStreakBody =>
      'The streak counts days with a completed training. Check-in is the day’s climate, not the streak.';
}

/// The translations for English, as used in the United States (`en_US`).
class AppLocalizationsEnUs extends AppLocalizationsEn {
  AppLocalizationsEnUs() : super('en_US');

  @override
  String get appName => 'MindVibe';

  @override
  String get appTagline => 'Mental Fitness';

  @override
  String get brandLine => 'A quiet place to train your mind.';

  @override
  String get tabHome => 'Home';

  @override
  String get tabProgress => 'Progress';

  @override
  String get tabProfile => 'Profile';

  @override
  String get actionContinue => 'Continue';

  @override
  String get actionBack => 'Back';

  @override
  String get actionStart => 'Start training';

  @override
  String get actionLogin => 'Sign in';

  @override
  String get actionRegister => 'Create account';

  @override
  String get actionForgotPassword => 'Reset password';

  @override
  String get actionSend => 'Send';

  @override
  String get actionSave => 'Save';

  @override
  String get actionLogout => 'Log out';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionSubscribe => 'Subscribe';

  @override
  String get actionTransferDevice => 'Change device link';

  @override
  String get actionComingSoon => 'Coming soon';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldEmail => 'Email';

  @override
  String get fieldPassword => 'Password';

  @override
  String get fieldPasswordConfirm => 'Confirm password';

  @override
  String get passwordShow => 'Show password';

  @override
  String get passwordHide => 'Hide password';

  @override
  String get fieldResetToken => 'Reset code';

  @override
  String get validationRequired => 'This field is required.';

  @override
  String get validationEmail => 'Enter a valid email.';

  @override
  String get validationPasswordMin => 'Password must be at least 8 characters.';

  @override
  String get validationPasswordMatch => 'Passwords do not match.';

  @override
  String get splashLoading => 'Preparing your space…';

  @override
  String get welcomeTitle => 'Welcome to MindVibe';

  @override
  String get welcomeBody =>
      'Just as you train your body at a gym, you can build a routine to train your mind.';

  @override
  String get welcomeLogin => 'I already have an account';

  @override
  String get welcomeRegister => 'Get started';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Pick up your training where you left off.';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Email and password only. No social login.';

  @override
  String get forgotTitle => 'Reset password';

  @override
  String get forgotSubtitle => 'We will send a code to your email.';

  @override
  String get forgotSent =>
      'If this email is registered, you will receive instructions shortly.';

  @override
  String get resetTitle => 'Choose a new password';

  @override
  String get resetSubtitle => 'Use the code sent to your email.';

  @override
  String get resetSuccess =>
      'Password updated. Sign in with your new password.';

  @override
  String get deviceAssociatedTitle => 'This device already has an account';

  @override
  String deviceAssociatedBody(String email) {
    return 'This device already has an account registered with $email.';
  }

  @override
  String get deviceAssociatedHint =>
      'Sign in, reset the password, or change the device link after authenticating. We never create a new account silently.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorOffline =>
      'You appear to be offline. Check your connection and try again.';

  @override
  String get errorUnauthorized => 'Your session expired. Please sign in again.';

  @override
  String get errorNotFound => 'We could not find what you are looking for.';

  @override
  String get errorServer => 'The server is unavailable right now.';

  @override
  String get errorUpdateApp => 'Please update the app to continue.';

  @override
  String get onboardingWelcomeTitle => 'Let’s start slowly';

  @override
  String get onboardingWelcomeBody =>
      'In a few steps you choose what to strengthen and join your plan.';

  @override
  String get onboardingNameTitle => 'What should we call you?';

  @override
  String get onboardingGoalTitle => 'What do you want to improve?';

  @override
  String get onboardingGoalHint =>
      'Pick one plan. You follow one at a time — you can switch later.';

  @override
  String get onboardingGoalFocusBody =>
      'Strengthen attention at work, study, and daily life. A 7-day plan.';

  @override
  String get onboardingGoalMindfulnessBody =>
      'Train presence and notice what is happening now, with more calm. A 5-day plan.';

  @override
  String get onboardingGoalMemoryBody =>
      'Remember with more clarity, at your pace. A 5-day plan.';

  @override
  String get onboardingGoalOthers => 'Other paths';

  @override
  String get onboardingExperienceTitle => 'How experienced are you?';

  @override
  String get onboardingReminderTitle => 'Want a daily reminder?';

  @override
  String get onboardingReminderBody =>
      'Local notification only, at the time you choose.';

  @override
  String get goalFocus => 'Focus';

  @override
  String get goalMemory => 'Memory';

  @override
  String get goalRelaxation => 'Relaxation';

  @override
  String get goalSleep => 'Sleep';

  @override
  String get goalHabit => 'Build the habit';

  @override
  String get goalBreathing => 'Breathing';

  @override
  String get goalMindfulness => 'Mindfulness';

  @override
  String get experienceBeginner => 'I am starting';

  @override
  String get experienceIntermediate => 'I have practiced a little';

  @override
  String get experienceExperienced => 'I already have a routine';

  @override
  String get reminderEnable => 'Remind me to train';

  @override
  String get reminderTime => 'Time';

  @override
  String homeGreeting(String name) {
    return 'Hi, $name';
  }

  @override
  String get homeTodayTitle => 'Today’s training';

  @override
  String get homeQuestion => 'What should I do now?';

  @override
  String get homeStreak => 'Streak';

  @override
  String get homeMinutes => 'minutes';

  @override
  String homeDayProgress(int current, int total) {
    return 'day $current/$total';
  }

  @override
  String get homeCompleted => 'The next training unlocks tomorrow.';

  @override
  String get homeStartFirst => 'Start your first training';

  @override
  String get homeStartToday => 'Do today’s training';

  @override
  String get homeResumeTraining => 'Back to training';

  @override
  String get homeSeePlan => 'See my plan';

  @override
  String get homeCompletedEyebrow => 'Done for today';

  @override
  String homeTomorrowTraining(int day, String title) {
    return 'Unlocks tomorrow: day $day — $title';
  }

  @override
  String homeNextUnlocksOn(String date, int day, String title) {
    return 'Unlocks on $date: day $day — $title';
  }

  @override
  String get homeNoProgram => 'You are not enrolled in a training plan yet.';

  @override
  String get homeNoProgramBody =>
      'Choose what you want to improve and join your plan.';

  @override
  String get homeSessionSoon =>
      'The full session arrives in the next step. For now, this is your training for today.';

  @override
  String get homeNowTitle => 'Audio';

  @override
  String get homeNowBody =>
      'Open sessions you can listen to whenever you want.';

  @override
  String get homeNowSleep => 'Sleep';

  @override
  String get homeNowRelax => 'Relax';

  @override
  String get homeNowBreathe => 'Breathe';

  @override
  String get homeNowStudy => 'Study';

  @override
  String get homeNowWork => 'Work';

  @override
  String get homeNowAll => 'All';

  @override
  String get homeSeeAll => 'See all';

  @override
  String get libraryAudiosTitle => 'All audio';

  @override
  String get libraryAudiosEmpty => 'No audio here right now.';

  @override
  String get librarySearch => 'Search';

  @override
  String get librarySearchHint => 'Search audio';

  @override
  String get libraryExercisesTitle => 'All exercises';

  @override
  String get libraryExercisesBody =>
      'Pick a short session and start whenever you want.';

  @override
  String get libraryExercisesEmpty => 'No published exercises right now.';

  @override
  String libraryMemoryMeta(int words, int seconds) {
    return '$words words · ${seconds}s to look';
  }

  @override
  String get libraryMemoryKindWords => 'Words · short term';

  @override
  String get libraryMemoryKindIcons => 'Pictures · visual';

  @override
  String get libraryMemoryKindOrder => 'Sequence';

  @override
  String get libraryMemoryKindDelayed => 'Hold in mind';

  @override
  String get libraryAttentionKindTarget => 'Tap only the target';

  @override
  String get libraryAttentionKindNogo => 'Tap everything except this';

  @override
  String get libraryAttentionKindChange => 'Tap when it changes';

  @override
  String get libraryAttentionKindGrid => 'Find the odd one out';

  @override
  String get libraryBreathingKindWave => 'Guided circle';

  @override
  String get libraryBreathingKindBox => 'Box 4-4-4-4';

  @override
  String get libraryBreathingKindLadder => '4-7-8';

  @override
  String get libraryBreathingKindTide => 'Tide · long exhale';

  @override
  String get libraryBreathingRoom => 'Breathing room';

  @override
  String get libraryBreathingRoomBody => 'Exercises and audio on one screen.';

  @override
  String get breathingHubTitle => 'Breathing';

  @override
  String get breathingHubBody =>
      'Guided exercises and audio to breathe at your own pace.';

  @override
  String get breathingHubExercises => 'Exercises';

  @override
  String get breathingHubAudios => 'Audio';

  @override
  String get breathingHubEmpty => 'No breathing content here right now.';

  @override
  String get homeExercisesTitle => 'Exercises';

  @override
  String get homeExercisesBody =>
      'Daily practice, attention, memory and breathing.';

  @override
  String get homeExerciseBreathing => 'Breathing';

  @override
  String get homeExerciseAttention => 'Attention';

  @override
  String get homeExerciseMemory => 'Memory';

  @override
  String get homeExploreTitle => 'The six rooms';

  @override
  String get homeExploreBody =>
      'Each point has its own program. Today’s training stays in the card above.';

  @override
  String get homeExploreAll => 'See plans';

  @override
  String get homeChoosePlan => 'Choose my plan';

  @override
  String get homeToolsTitle => 'Tools';

  @override
  String get homeToolsBody =>
      'A check-in, a full mind, a notebook and a way to close the night.';

  @override
  String get homeToolPomodoro => 'Pomodoro';

  @override
  String get homeToolCheckin => 'Check-in';

  @override
  String get homeToolClearMind => 'Full mind';

  @override
  String get homeToolJournal => 'Notebook';

  @override
  String get homeToolThought => 'Park';

  @override
  String get homeToolSilentRoom => 'Room';

  @override
  String get homeToolDayClose => 'Night';

  @override
  String get homeTagline => 'Breathe. Focus. Grow.';

  @override
  String get homeTodayEyebrow => 'Today\'s training';

  @override
  String get homeProgressSection => 'Your progress';

  @override
  String get homeKeepExploring => 'Keep exploring';

  @override
  String get homeAreaProgress => 'Your progress by area';

  @override
  String get homeNextTraining => 'Next training';

  @override
  String get homeMyTools => 'My tools';

  @override
  String get homeNumbersTitle => 'Your moment in numbers';

  @override
  String get homeQuote => 'Small daily choices build a stronger, calmer mind.';

  @override
  String get homeStatDays => 'Days';

  @override
  String get homeStatTrained => 'Trained';

  @override
  String get homeNowFocus => 'Focus';

  @override
  String get homeNowMemory => 'Memory';

  @override
  String get homeNowMindfulness => 'Mindfulness';

  @override
  String get homeCurrentStreak => 'Current streak';

  @override
  String get menuOpen => 'Academy menu';

  @override
  String get menuClose => 'Close menu';

  @override
  String get menuTitle => 'Mental Academy';

  @override
  String get menuSubtitle => 'Every room, in one place.';

  @override
  String get menuSectionTrain => 'Training';

  @override
  String get menuSectionAudio => 'Audio';

  @override
  String get menuSectionExercise => 'Exercises';

  @override
  String get menuSectionTools => 'Tools';

  @override
  String get menuSectionJourney => 'Journey';

  @override
  String get menuToday => 'Today\'s training';

  @override
  String get menuTodayHint => 'Your session for the day';

  @override
  String get menuPlans => 'Programs';

  @override
  String get menuPlansHint => 'The academy rooms';

  @override
  String get menuMyPlan => 'My plan';

  @override
  String get menuMyPlanHint => 'Days done and what’s next';

  @override
  String get menuRoomHint => 'A full program';

  @override
  String get menuAudios => 'Library';

  @override
  String get menuAudiosHint => 'Listen at your own pace';

  @override
  String get menuSleepHint => 'Sounds for the night';

  @override
  String get menuRelaxHint => 'Ease the body and mind';

  @override
  String get menuFocusAudio => 'Focus audio';

  @override
  String get menuFocusAudioHint => 'A track for concentration';

  @override
  String get menuAttentionHint => 'Target training';

  @override
  String get menuMemoryHint => 'Words and presence';

  @override
  String get menuBreathingHint => 'A guided rhythm';

  @override
  String get menuDailyHint => 'Ten short drills and 15 minutes';

  @override
  String get menuPomodoroHint => 'Focus blocks';

  @override
  String get menuCheckinHint => 'Mood and energy';

  @override
  String get menuClearMindHint => 'One thing for today';

  @override
  String get menuJournalHint => 'Three lines, yours only';

  @override
  String get menuThoughtHint => 'Write, park, move on';

  @override
  String get menuSilentRoomHint => 'A presence block';

  @override
  String get menuDayCloseHint => 'Two minutes to close';

  @override
  String get menuProgressHint => 'Streak, climate and time';

  @override
  String get menuHistoryHint => 'Everything you did';

  @override
  String get menuRankingHint => 'Who is training';

  @override
  String get menuProfileHint => 'Account and preferences';

  @override
  String get catalogTitle => 'Catalog';

  @override
  String get catalogEmpty => 'No published programs right now.';

  @override
  String catalogDays(int count) {
    return '$count days';
  }

  @override
  String catalogDayItem(int day, String title) {
    return 'Day $day · $title';
  }

  @override
  String get catalogBrowseHint =>
      'One plan at a time. If you switch, the current plan’s progress and report start over.';

  @override
  String catalogFreeDays(int count) {
    return '$count free days';
  }

  @override
  String get catalogPlanDays => 'The days of the plan';

  @override
  String get catalogEnroll => 'Start this plan';

  @override
  String get catalogEnrollCurrent => 'This is your plan';

  @override
  String get catalogSwitch => 'Switch to this plan';

  @override
  String get catalogSwitchTitle => 'Switch plans?';

  @override
  String get catalogSwitchBody =>
      'You can follow only one plan at a time. The progress and report of your current plan will be reset.';

  @override
  String get catalogSwitchConfirm => 'Switch anyway';

  @override
  String get momentListen => 'Listen';

  @override
  String get prepareStart => 'I’m ready';

  @override
  String sessionElapsed(String time) {
    return 'Time $time';
  }

  @override
  String get themeSection => 'Theme';

  @override
  String get themeSectionHint =>
      'Night theme gives breathing and the session a dark background.';

  @override
  String get themeDark => 'Night theme';

  @override
  String get themeDarkHint => 'Black background in the session and breathing.';

  @override
  String get languageSection => 'Language';

  @override
  String get languageSectionHint => 'Choose the app language.';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get homeLayoutSection => 'Home layout';

  @override
  String get homeLayoutSectionHint => 'Choose how the home screen looks.';

  @override
  String get homeLayoutToday => 'Today\'s training';

  @override
  String get homeLayoutTodayHint =>
      'A scene of the day with today\'s session in focus.';

  @override
  String get homeLayoutTraining => 'Training first';

  @override
  String get homeLayoutTrainingHint => 'A large card to start right away.';

  @override
  String get homeLayoutProgress => 'Progress first';

  @override
  String get homeLayoutProgressHint => 'Streak, areas and the next session.';

  @override
  String get playerLoadError =>
      'The audio could not be played. Check your connection and try again.';

  @override
  String get playerReplay => 'Play again';

  @override
  String get paywallTitle => 'Continue with Premium';

  @override
  String get paywallBody =>
      'Extra audios, exercises and tools are part of Premium. The first days of the plan stay free.';

  @override
  String get paywallCtaSoon => 'Subscription coming soon';

  @override
  String get paywallCta => 'Subscribe to Premium';

  @override
  String get paywallCtaRenew => 'Renew Premium';

  @override
  String paywallCtaPrice(String price, String period) {
    return 'Subscribe to Premium · $price/$period';
  }

  @override
  String paywallPriceHint(String price, String period) {
    return '$price every $period, via Mercado Pago.';
  }

  @override
  String get paywallWaiting =>
      'Checkout opened in the browser. When you return, the app confirms the status.';

  @override
  String get paywallOpenError => 'Could not open checkout. Try again.';

  @override
  String get billingTitle => 'Subscription';

  @override
  String get billingHistoryTitle => 'Payment history';

  @override
  String get billingHistoryEmpty =>
      'Charges will show up here after a payment.';

  @override
  String get billingPeriodMonth => 'month';

  @override
  String billingPeriodDays(int count) {
    return '$count days';
  }

  @override
  String billingValidUntil(String date) {
    return 'Valid until $date';
  }

  @override
  String get billingStatusActive => 'Premium active';

  @override
  String get billingStatusPending => 'Waiting for confirmation';

  @override
  String get billingStatusFailed => 'Payment not approved';

  @override
  String get billingStatusExpired => 'Subscription ended';

  @override
  String get billingStatusNone => 'No subscription';

  @override
  String get billingPaymentApproved => 'Approved';

  @override
  String get billingPaymentPending => 'Pending';

  @override
  String get billingPaymentFailed => 'Not approved';

  @override
  String get billingPaymentRefunded => 'Refunded';

  @override
  String get profileTitle => 'Profile';

  @override
  String get profileAccountTitle => 'Account';

  @override
  String get profileLogoutConfirm => 'Log out on this device?';

  @override
  String get profilePlaceholder =>
      'Account settings, reminders and account deletion come next.';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressPlaceholder =>
      'Your history, XP and day-7 report will appear here in the next step.';

  @override
  String get profileDeleteAccount => 'Delete account';

  @override
  String get profileDeleteConfirm => 'Delete your account?';

  @override
  String get profileDeleteConfirmBody =>
      'Your account will stop working on this device. This cannot be undone here.';

  @override
  String get profileTerms => 'Terms of use';

  @override
  String get profilePrivacy => 'Privacy policy';

  @override
  String get profileLegalPlaceholder =>
      'The legal text will be published later. This is only a reserved shortcut for now.';

  @override
  String get profileSaved => 'Profile updated.';

  @override
  String get profileEditName => 'Change name';

  @override
  String get profileNameHint => 'How you want to appear on the ranking.';

  @override
  String get profileAvatarHint =>
      'Tap the photo to pick a gallery image or a calm symbol. It shows on the ranking.';

  @override
  String get profilePhotoGallery => 'Choose from gallery';

  @override
  String get profileEmojiChoose => 'Use a symbol';

  @override
  String get profileEmojiTitle => 'A symbol for the ranking';

  @override
  String get profileEmojiBody =>
      'No selfie? Pick a quiet icon from the mental gym.';

  @override
  String get profilePhotoRemove => 'Remove photo';

  @override
  String get profileLegalOpenError => 'The page could not be opened right now.';

  @override
  String get profileMessageTitle => 'Message the team';

  @override
  String get profileMessageTileBody =>
      'A suggestion, a new idea, or a thank you.';

  @override
  String get profileMessageBody =>
      'Tell us what you missed, a new idea, or a thank you. Each message becomes a ticket we read.';

  @override
  String get profileMessageTypeSuggestion => 'Improvement';

  @override
  String get profileMessageTypeFeature => 'New feature';

  @override
  String get profileMessageTypeThanks => 'Thanks';

  @override
  String get profileMessageField => 'Your message';

  @override
  String get profileMessageHint =>
      'Keep it simple. What would help your training?';

  @override
  String get profileMessageTooShort =>
      'Write a little more so we can understand.';

  @override
  String get profileMessageSent => 'Message sent. Thank you for writing.';

  @override
  String get progressXp => 'XP';

  @override
  String get progressLevel => 'Level';

  @override
  String get progressSessions => 'Sessions';

  @override
  String get progressJourneyTitle => 'Your journey';

  @override
  String get progressTimeHint =>
      'Plan training and free audio, added together.';

  @override
  String get progressTimeUnderMinute => 'Under 1 min';

  @override
  String progressTimeOnlyMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String progressTimeHours(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String progressTimeCompactMinutes(int minutes) {
    return '${minutes}min';
  }

  @override
  String progressTimeCompactHours(int hours, int minutes) {
    return '${hours}h ${minutes}min';
  }

  @override
  String get progressEmptyTitle => 'Your journey is just beginning';

  @override
  String get progressEmptyBody =>
      'Complete your first training to take the first step. It only takes a few minutes.';

  @override
  String get progressEmptyCta => 'Start my first training';

  @override
  String get progressStreakTitle => 'Your current streak';

  @override
  String progressStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String progressHeroStats(String time, int count) {
    return '$time trained · $count sessions';
  }

  @override
  String get progressMoreTitle => 'More';

  @override
  String get progressStatTrained => 'trained';

  @override
  String get progressProgramTitle => 'Your program';

  @override
  String progressProgramDay(int current, int total) {
    return 'Day $current of $total';
  }

  @override
  String progressProgramDaysDone(int done, int total) {
    return '$done of $total days completed';
  }

  @override
  String get progressContinue => 'Continue training';

  @override
  String get progressWeekRhythmTitle => 'Your rhythm';

  @override
  String progressWeekDaysTrained(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'You trained $count days this week',
      one: 'You trained 1 day this week',
    );
    return '$_temp0';
  }

  @override
  String progressWeekDeltaUp(String time) {
    return '+$time vs last week';
  }

  @override
  String progressWeekDeltaDown(String time) {
    return '$time less than last week';
  }

  @override
  String get progressMilestoneTitle => 'Next milestone';

  @override
  String progressMilestoneXp(int xp) {
    return '$xp XP to the next level';
  }

  @override
  String progressMilestoneXpBar(int current, int target) {
    return '$current / $target XP';
  }

  @override
  String progressMilestoneStreak(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days in a row',
      one: '1 day in a row',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneStreakRemain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days left',
      one: '1 day left',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneMinutes(int minutes) {
    return '$minutes minutes trained';
  }

  @override
  String progressMilestoneMinutesBar(int current, int target) {
    return '$current / $target min';
  }

  @override
  String get progressRecentTitle => 'Recent activity';

  @override
  String get progressSeeHistory => 'See history';

  @override
  String get rankingTitle => 'World ranking';

  @override
  String get rankingCardTitle => 'World ranking';

  @override
  String get rankingCardBody =>
      'See who is training around the world. Joining is optional.';

  @override
  String get rankingPeriodAll => 'All time';

  @override
  String get rankingPeriodWeekly => 'This week';

  @override
  String get rankingOptInTitle => 'Appear on the ranking';

  @override
  String get rankingOptInBody =>
      'Your name, photo or symbol, and XP become visible to other people in the app. You can leave whenever you want.';

  @override
  String get rankingOptInCta => 'Join the ranking';

  @override
  String get rankingOptOut => 'Leave the ranking';

  @override
  String get rankingEmpty =>
      'Nobody is on the ranking yet. You can be the first.';

  @override
  String rankingPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count people on the ranking',
      one: '1 person on the ranking',
      zero: 'Nobody on the ranking yet',
    );
    return '$_temp0';
  }

  @override
  String get rankingYourPlace => 'Your place';

  @override
  String get rankingUnranked => 'Not on the ranking';

  @override
  String rankingXp(int xp) {
    return '$xp XP';
  }

  @override
  String rankingRank(int rank) {
    return '#$rank';
  }

  @override
  String get rankingYou => 'You';

  @override
  String get profileRanking => 'Appear on the ranking';

  @override
  String get profileRankingHint =>
      'Name, photo or symbol, and XP visible to other people.';

  @override
  String progressLevelName(String name) {
    return 'Current level: $name';
  }

  @override
  String get progressXpCardBody => 'It comes from training. Tap to see how.';

  @override
  String get progressChapterTitle => 'Current chapter';

  @override
  String get progressPathTitle => 'The path';

  @override
  String get progressJourneyStart => 'Start';

  @override
  String get progressJourneyWarm => 'First steps';

  @override
  String get progressJourneyRhythm => 'Rhythm';

  @override
  String get progressJourneyWalk => 'Path';

  @override
  String get progressJourneyDeep => 'Presence';

  @override
  String get progressJourneyConstancy => 'Constancy';

  @override
  String get progressJourneyCopy0 =>
      'You\'re at the beginning. One minute is already presence.';

  @override
  String get progressJourneyCopy1 => 'The first minutes already open the path.';

  @override
  String get progressJourneyCopy2 =>
      'Rhythm is showing up. Keep going, unhurried.';

  @override
  String get progressJourneyCopy3 =>
      'Your journey already has shape. This is real training.';

  @override
  String get progressStreakHint => 'days in motion';

  @override
  String get progressWeekChartTitle => 'This week';

  @override
  String get progressWeekChartEmpty =>
      'No time logged this week yet. A session or a track will show up here.';

  @override
  String progressWeekChartTotal(String time) {
    return '$time this week';
  }

  @override
  String get historyTitle => 'History';

  @override
  String get historyCardTitle => 'History';

  @override
  String get historyCardBody => 'Everything you did in the app.';

  @override
  String get historyEmpty =>
      'A training, an audio, an exercise, a pomodoro, a check-in or the notebook will show up here.';

  @override
  String get historyToday => 'Today';

  @override
  String get historyYesterday => 'Yesterday';

  @override
  String historyWhen(String weekday, String time) {
    return '$weekday at $time';
  }

  @override
  String get historyTypeExercise => 'Exercise';

  @override
  String get historyTypeSession => 'Training';

  @override
  String get historyTypeListen => 'Audio';

  @override
  String get historyTypePomodoro => 'Pomodoro';

  @override
  String get historyTypeCheckin => 'Check-in';

  @override
  String get historyTypeJournal => 'Notebook';

  @override
  String get historyTypeThought => 'Thought';

  @override
  String get historyTypeClearMind => 'Full mind';

  @override
  String get historyTypeDayClose => 'Closing';

  @override
  String get historyTypeSilentRoom => 'Quiet room';

  @override
  String get sessionPrepareTitle => 'Get ready';

  @override
  String sessionPrepareBody(int minutes) {
    return 'Find a calm place. This training takes about $minutes minutes. There may be audio: sound does not start on its own. If you are in a classroom or with other people, use headphones and tap play only when you are ready.';
  }

  @override
  String get sessionAudioWait =>
      'Audio does not start on its own. Tap play when you are in a calm place. If you are in a classroom or with other people, use headphones.';

  @override
  String get sessionAudioObjectiveTitle => 'In this audio';

  @override
  String get sessionAudioObjectiveFallback =>
      'As you listen, stay with the audio at your own pace. If your mind wanders, notice and return.';

  @override
  String get sessionCompleteTitle => 'Training complete';

  @override
  String get sessionSeeYouTomorrow => 'See you tomorrow';

  @override
  String get sessionCompletingTitle => 'Saving your training';

  @override
  String get sessionCompletingBody => 'One more moment in the Mental Academy.';

  @override
  String get sessionLoadingTitle => 'Preparing your training';

  @override
  String get sessionLoadingBody =>
      'Find a quiet place. The Mental Academy is about to begin.';

  @override
  String get planTitle => 'My plan';

  @override
  String get planUniqueHint => 'One plan at a time';

  @override
  String get planCadenceTitle => 'Training rhythm';

  @override
  String get planCadenceBody =>
      'You follow one plan at a time. The next day unlocks on your next training day, in your timezone. The same exercises can appear in other plans, but this is your curriculum now.';

  @override
  String get planCadenceDaily => 'Every day';

  @override
  String get planCadenceWeekdays => 'Weekdays';

  @override
  String get planCadenceHintDaily =>
      'The next training unlocks the following day in your timezone.';

  @override
  String get planCadenceHintWeekdays =>
      'Monday to Friday. If you finish on Friday, the next day unlocks on Monday.';

  @override
  String get planReminderHint => 'The reminder arrives at the time you choose.';

  @override
  String get planEmpty => 'You are not in a plan yet.';

  @override
  String planDaysDone(int done, int total) {
    return '$done of $total days';
  }

  @override
  String get planSettings => 'Rhythm and reminder';

  @override
  String get planDoneForToday => 'Done for today.';

  @override
  String planNextUnlocksTomorrow(String title) {
    return 'Unlocks tomorrow: $title';
  }

  @override
  String planNextTraining(String title, String date) {
    return 'Unlocks on $date: $title';
  }

  @override
  String get planDayDone => 'Done';

  @override
  String get planDayToday => 'Today';

  @override
  String get planDayTomorrow => 'Tomorrow';

  @override
  String planDayLocked(String date) {
    return 'Unlocks on $date';
  }

  @override
  String planDayLabel(int day, String title) {
    return 'Day $day — $title';
  }

  @override
  String sessionXpAwarded(int xp) {
    return '+$xp XP';
  }

  @override
  String sessionBlockOf(int current, int total) {
    return '$current of $total';
  }

  @override
  String get breathingInhale => 'INHALE';

  @override
  String get breathingHold => 'HOLD';

  @override
  String get breathingExhale => 'EXHALE';

  @override
  String get breathingRest => 'REST';

  @override
  String breathingCycle(int current, int total) {
    return 'cycle $current/$total';
  }

  @override
  String get playerPlay => 'Play';

  @override
  String get playerPause => 'Pause';

  @override
  String get playerNext => 'Next';

  @override
  String get playerNowPlaying => 'Now playing';

  @override
  String get playerVolume => 'Volume';

  @override
  String get playerCoverExpand => 'Expand cover';

  @override
  String get playerPrevious => 'Previous';

  @override
  String get playerRepeat => 'Repeat';

  @override
  String get playerFavorite => 'Favorite';

  @override
  String get playerFavorited => 'Saved';

  @override
  String get playerTimer => 'Timer';

  @override
  String get playerTimerOff => 'No timer';

  @override
  String get playerAboutTitle => 'About this session';

  @override
  String get playerAboutBody =>
      'Listen at your own pace. Pause whenever you need and come back when it feels right.';

  @override
  String get attentionPrompt => 'Tap only when the target appears.';

  @override
  String get attentionBriefingTitle => 'Target attention';

  @override
  String get attentionBriefingBody =>
      'Shapes will appear. Tap only the figure below. If another one shows up, don’t tap. The pace speeds up gradually.';

  @override
  String get attentionBriefingNogoTitle => 'Hold the tap';

  @override
  String get attentionBriefingNogoBody =>
      'Tap every shape except the one below. The training is to hold the impulse.';

  @override
  String get attentionBriefingChangeTitle => 'When it changes';

  @override
  String get attentionBriefingChangeBody =>
      'Tap only when the shape is different from the previous one. If it’s the same, wait.';

  @override
  String get attentionBriefingGridTitle => 'Find the odd one';

  @override
  String get attentionBriefingGridBody =>
      'Nine shapes appear together. Tap only the one that doesn’t match the others.';

  @override
  String get attentionTargetLabel => 'Tap only this shape';

  @override
  String get attentionNogoLabel => 'Don’t tap this shape';

  @override
  String get attentionChangeLabel => 'Tap when the shape changes';

  @override
  String get attentionGridLabel => 'Tap the odd one out';

  @override
  String get attentionPreviousLabel => 'Previous';

  @override
  String get breathingBriefingTitle => 'Guided breathing';

  @override
  String get breathingBriefingBody =>
      'Follow the circle. Inhale, hold and exhale with the rhythm. No rush, no perfection.';

  @override
  String get breathingBriefingBoxTitle => 'Box breathing';

  @override
  String get breathingBriefingBoxBody =>
      'A square, four sides. Inhale, hold, exhale and rest. The dot walks with you.';

  @override
  String get breathingBriefingLadderTitle => '4-7-8';

  @override
  String get breathingBriefingLadderBody =>
      'Inhale for 4, hold for 7, exhale for 8. The column rises and falls with the breath.';

  @override
  String get breathingBriefingTideTitle => 'Long tide';

  @override
  String get breathingBriefingTideBody =>
      'The exhale is longer than the inhale. Follow the tide in and out. Don’t force it.';

  @override
  String get memoryBriefingTitle => 'Word memory';

  @override
  String get memoryBriefingBody =>
      'First look at the words. Then mark only the ones you remember.';

  @override
  String get memoryBriefingIconsTitle => 'Visual memory';

  @override
  String get memoryBriefingIconsBody =>
      'Look at the pictures. Then mark only the ones you saw.';

  @override
  String get memoryBriefingOrderTitle => 'Sequence memory';

  @override
  String get memoryBriefingOrderBody =>
      'Words appear one by one. Then tap them in the same order.';

  @override
  String get memoryBriefingDelayedTitle => 'Hold in mind';

  @override
  String get memoryBriefingDelayedBody =>
      'Look, wait a little with what remains, then mark what you remember.';

  @override
  String get exerciseBriefingStart => 'Start';

  @override
  String get exerciseDurationLabel => 'How long do you want to train?';

  @override
  String exerciseDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String attentionHits(int count) {
    return 'Hits: $count';
  }

  @override
  String attentionMisses(int count) {
    return 'Misses: $count';
  }

  @override
  String get memoryStudyTitle => 'Look at the words';

  @override
  String get memorySelectTitle => 'Which words do you remember?';

  @override
  String get memoryStudyIconsTitle => 'Look at the pictures';

  @override
  String get memorySelectIconsTitle => 'Which pictures did you see?';

  @override
  String get memoryHoldTitle => 'Hold them in mind';

  @override
  String get memoryHoldBody =>
      'They’re gone from the screen. Stay with what remains, without rehearsing.';

  @override
  String get memoryOrderStudyTitle => 'Watch the order';

  @override
  String get memoryOrderSelectTitle => 'Tap in the same order';

  @override
  String get memoryOrderReset => 'Start over';

  @override
  String get memoryWordsTitle => 'My words';

  @override
  String get memoryWordsHint =>
      'Add your own words. They join the exercise, shuffled in a new order each time.';

  @override
  String get memoryWordsAdd => 'Add my words';

  @override
  String get memoryWordsEmpty =>
      'You have no custom words yet. Training uses a random set.';

  @override
  String get memoryWordsField => 'New word';

  @override
  String memoryWordsCount(int count) {
    return '$count of your words';
  }

  @override
  String get ratingSelect => 'Choose a value';

  @override
  String get unknownExercise => 'Please update the app for this exercise.';

  @override
  String get exerciseRoomDone => 'Session complete.';

  @override
  String get notificationTitle => 'MindVibe';

  @override
  String get notificationBody => 'Today’s training is waiting for you. 🧠';

  @override
  String get actionDelete => 'Delete account';

  @override
  String get emptyTitle => 'Nothing here yet';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String get pomodoroHint => '25 minutes of attention, 5 of rest. No pressure.';

  @override
  String get pomodoroFocus => 'Focus';

  @override
  String get pomodoroBreak => 'Break';

  @override
  String get pomodoroStart => 'Start';

  @override
  String get pomodoroPause => 'Pause';

  @override
  String get pomodoroReset => 'Reset';

  @override
  String get pomodoroPresetClassic => '25 + 5';

  @override
  String get pomodoroPresetShort => '15 + 5';

  @override
  String get pomodoroPresetLong => '50 + 10';

  @override
  String pomodoroRounds(int count) {
    return '$count blocks done';
  }

  @override
  String get checkinTitle => 'Check-in';

  @override
  String get checkinHint =>
      'How are you right now? One tap on each axis. Ten seconds.';

  @override
  String get checkinMoodTitle => 'Mood';

  @override
  String get checkinEnergyTitle => 'Energy';

  @override
  String checkinMood(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Very heavy',
      '2': 'Heavy',
      '3': 'Neutral',
      '4': 'Light',
      '5': 'Good',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinEnergy(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Drained',
      '2': 'Low',
      '3': 'Medium',
      '4': 'Steady',
      '5': 'High',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinWeight(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'A heavy day',
      '2': 'A quieter day',
      '3': 'A balanced day',
      '4': 'A moving day',
      '5': 'A light day',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get checkinSaved => 'Saved. This becomes today’s climate on progress.';

  @override
  String get checkinSaving => 'Saving…';

  @override
  String get checkinSeeProgress => 'See on progress';

  @override
  String get checkinUpdateHint => 'Tap again if the day has changed.';

  @override
  String get checkinPromptLater => 'Not now';

  @override
  String get progressCheckinTitle => 'Today’s climate';

  @override
  String get progressCheckinEmpty => 'How is the day? Ten seconds, one tap.';

  @override
  String get progressCheckinCta => 'Check in';

  @override
  String progressCheckinBody(String mood, String energy) {
    return 'Mood $mood · Energy $energy';
  }

  @override
  String get progressStreakCheckinHint =>
      'The streak is showing up. Climate explains the weight of the day better than minutes alone.';

  @override
  String get clearMindTitle => 'Full mind';

  @override
  String get clearMindIntro =>
      'This is not the time for more information. It is time to slow down and recover space.';

  @override
  String get clearMindStart => 'Start';

  @override
  String get clearMindPauseBody =>
      'Step back. Breathe. Don’t try to solve anything.';

  @override
  String get clearMindSkipPause => 'I already breathed';

  @override
  String get clearMindDumpBody =>
      'Write what is going through your head. Don’t organize it yet.';

  @override
  String get clearMindDumpHint => 'What won’t let go';

  @override
  String get clearMindAdd => 'One more';

  @override
  String get clearMindDumpNext => 'Continue';

  @override
  String get clearMindQuestion =>
      'Of all these things in your head right now, which is the only one that really needs your attention today?';

  @override
  String get clearMindPickHint => 'Tap one. The rest can wait.';

  @override
  String get clearMindKeepOne => 'Keep this one';

  @override
  String get clearMindDoneEyebrow => 'Today, only this';

  @override
  String clearMindParked(int count) {
    return 'The rest was parked ($count). It does not need to be solved today.';
  }

  @override
  String get clearMindParkedNone => 'Just this. Nothing else to park.';

  @override
  String get clearMindDone => 'Done';

  @override
  String get clearMindSeeLot => 'See the lot';

  @override
  String get clearMindOneThing => 'One thing at a time';

  @override
  String get clearMindHomeCard => 'Today, only this';

  @override
  String get clearMindHomeCta => 'Mind full? Unload it and keep one thing.';

  @override
  String get clearMindFromCheckin => 'Is your mind full?';

  @override
  String get journalTitle => 'Notebook';

  @override
  String get journalHint =>
      'Three lines. A morning intention, emptying the head, or 3 gratitudes. Short, private, back tomorrow.';

  @override
  String journalPrompt(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'Morning intention',
      'unload': 'Empty the head',
      'gratitude': '3 gratitudes',
      'other': 'Notebook',
    });
    return '$_temp0';
  }

  @override
  String journalPromptHint(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'What you carry into the day.',
      'unload': 'Put down what is taking up space.',
      'gratitude': 'Three small things that are still here.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get journalIntention1 => 'What matters today?';

  @override
  String get journalIntention2 => 'One small step';

  @override
  String get journalIntention3 => 'How I want to arrive tonight';

  @override
  String get journalUnload1 => 'What is occupying my head?';

  @override
  String get journalUnload2 => 'What can wait';

  @override
  String get journalUnload3 => 'What I let go of now';

  @override
  String get journalGratitude1 => 'One good thing';

  @override
  String get journalGratitude2 => 'Another';

  @override
  String get journalGratitude3 => 'One more';

  @override
  String get journalSave => 'Save';

  @override
  String get journalUpdate => 'Update today';

  @override
  String get journalSaved =>
      'Saved. Only you can read this. Tomorrow the notebook comes back empty.';

  @override
  String get journalPrivate =>
      'Nobody else sees this. Not even on the ranking.';

  @override
  String get journalWeek => 'Days you wrote';

  @override
  String get silentRoomTitle => 'Quiet room';

  @override
  String get silentRoomHint =>
      'One presence block. No cycle, no break. For when Pomodoro feels heavy.';

  @override
  String get silentRoomPresence => 'Presence';

  @override
  String get silentRoomDone => 'Block complete';

  @override
  String silentRoomMinutes(int count) {
    return '$count min';
  }

  @override
  String get thoughtTitle => 'Park the thought';

  @override
  String get thoughtHint =>
      'Write what’s occupying your mind. Save it and move on — to training, audio, or sleep.';

  @override
  String get thoughtPlaceholder => 'What won’t let go';

  @override
  String get thoughtSave => 'Park and continue';

  @override
  String get thoughtSaved => 'It’s parked. Your mind can move on.';

  @override
  String get thoughtPrivate =>
      'Only you can read this. It never goes to the ranking.';

  @override
  String get thoughtContinue => 'Move on to';

  @override
  String get thoughtContinueTraining => 'Training';

  @override
  String get thoughtContinueAudio => 'Audio';

  @override
  String get thoughtContinueSleep => 'Sleep';

  @override
  String get thoughtLot => 'Parked';

  @override
  String get thoughtLotEmpty => 'Nothing parked.';

  @override
  String get thoughtLotFull => 'The lot is full. Let one go to park another.';

  @override
  String get thoughtRelease => 'Let go';

  @override
  String get dayCloseTitle => 'Close the day';

  @override
  String get dayCloseHint =>
      'Two minutes. What stayed, what you let go, a short audio. Close the academy the way training closes the day in the body.';

  @override
  String get dayCloseKept => 'What stayed';

  @override
  String get dayCloseReleased => 'What you let go';

  @override
  String get dayCloseSave => 'Close the day';

  @override
  String get dayCloseUpdate => 'Update today';

  @override
  String get dayCloseSaved =>
      'The day is closed. Only you can read this. Now the short audio.';

  @override
  String get dayClosePrivate =>
      'Only you can read this. It never goes to the ranking.';

  @override
  String get dayCloseAudio => 'Short audio';

  @override
  String get dayClosePlay => 'Listen';

  @override
  String get dayCloseWeek => 'Nights you closed';

  @override
  String get xpInfoTitle => 'About XP';

  @override
  String get xpInfoLead =>
      'XP grows when you finish a training session. Tools and audio stay with the day — they don’t add points.';

  @override
  String get xpInfoGivesTitle => 'What gives XP';

  @override
  String get xpInfoGivesBody =>
      'Completing a program session. Finishing a cycle. Achievements tied to training.';

  @override
  String get xpInfoSkipsTitle => 'What doesn’t';

  @override
  String get xpInfoSkipsBody =>
      'Check-in, full mind, notebook, parking a thought, closing the day, Pomodoro, the quiet room, and listening to audio. They live in history and climate. No XP.';

  @override
  String get xpInfoWhereTitle => 'Where it shows';

  @override
  String get xpInfoWhereBody =>
      'On Progress, on home, and at the end of a session. On the ranking, only if you choose to appear.';

  @override
  String get xpInfoStreakTitle => 'Streak';

  @override
  String get xpInfoStreakBody =>
      'The streak counts days with a completed training. Check-in is the day’s climate, not the streak.';
}
