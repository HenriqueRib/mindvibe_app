// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'MindVibe';

  @override
  String get appTagline => 'Academia Mental';

  @override
  String get brandLine => 'Um lugar tranquilo para treinar sua mente.';

  @override
  String get tabHome => 'Início';

  @override
  String get tabProgress => 'Progresso';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionStart => 'Começar treino';

  @override
  String get actionLogin => 'Entrar';

  @override
  String get actionRegister => 'Criar conta';

  @override
  String get actionForgotPassword => 'Recuperar senha';

  @override
  String get actionSend => 'Enviar';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionLogout => 'Sair';

  @override
  String get actionRetry => 'Tentar de novo';

  @override
  String get actionSkip => 'Pular';

  @override
  String get actionSubscribe => 'Assinar';

  @override
  String get actionTransferDevice => 'Trocar associação';

  @override
  String get actionComingSoon => 'Em breve';

  @override
  String get fieldName => 'Nome';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPassword => 'Senha';

  @override
  String get fieldPasswordConfirm => 'Confirmar senha';

  @override
  String get passwordShow => 'Mostrar senha';

  @override
  String get passwordHide => 'Ocultar senha';

  @override
  String get fieldResetToken => 'Código de redefinição';

  @override
  String get validationRequired => 'Preencha este campo.';

  @override
  String get validationEmail => 'Digite um e-mail válido.';

  @override
  String get validationPasswordMin =>
      'A senha precisa ter pelo menos 8 caracteres.';

  @override
  String get validationPasswordMatch => 'As senhas não coincidem.';

  @override
  String get splashLoading => 'Preparando seu espaço…';

  @override
  String get welcomeTitle => 'Bem-vindo à MindVibe';

  @override
  String get welcomeBody =>
      'Assim como você treina seu corpo em uma academia, você pode criar uma rotina para treinar sua mente.';

  @override
  String get welcomeLogin => 'Já tenho conta';

  @override
  String get welcomeRegister => 'Começar agora';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginSubtitle => 'Continue seu treino de onde parou.';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get registerSubtitle => 'Só e-mail e senha. Sem redes sociais.';

  @override
  String get forgotTitle => 'Recuperar senha';

  @override
  String get forgotSubtitle => 'Enviaremos um código para o seu e-mail.';

  @override
  String get forgotSent =>
      'Se este e-mail estiver cadastrado, você receberá as instruções em instantes.';

  @override
  String get resetTitle => 'Redefinir senha';

  @override
  String get resetSubtitle => 'Use o código recebido por e-mail.';

  @override
  String get resetSuccess => 'Senha atualizada. Entre com a nova senha.';

  @override
  String get deviceAssociatedTitle => 'Este aparelho já tem uma conta';

  @override
  String deviceAssociatedBody(String email) {
    return 'Este aparelho já possui uma conta cadastrada com o e-mail $email.';
  }

  @override
  String get deviceAssociatedHint =>
      'Entre nessa conta, recupere a senha ou troque a associação depois de autenticar. Não criamos uma conta nova em silêncio.';

  @override
  String get errorGeneric => 'Algo não saiu como esperado. Tente de novo.';

  @override
  String get errorOffline =>
      'Sem conexão. Verifique a internet e tente novamente.';

  @override
  String get errorUnauthorized => 'Sua sessão expirou. Entre novamente.';

  @override
  String get errorNotFound => 'Não encontramos o que você procura.';

  @override
  String get errorServer => 'O servidor está indisponível no momento.';

  @override
  String get errorUpdateApp => 'Atualize o aplicativo para continuar.';

  @override
  String get onboardingWelcomeTitle => 'Vamos começar com calma';

  @override
  String get onboardingWelcomeBody =>
      'Em poucos passos você escolhe o que quer fortalecer e entra no seu plano.';

  @override
  String get onboardingNameTitle => 'Como podemos te chamar?';

  @override
  String get onboardingGoalTitle => 'O que você quer melhorar?';

  @override
  String get onboardingGoalHint =>
      'Escolha um plano. Você segue um por vez — pode trocar depois.';

  @override
  String get onboardingGoalFocusBody =>
      'Fortalecer a atenção no trabalho, no estudo e no dia a dia. Plano de 7 dias.';

  @override
  String get onboardingGoalMindfulnessBody =>
      'Treinar presença e notar o que acontece agora, com mais calma. Plano de 5 dias.';

  @override
  String get onboardingGoalMemoryBody =>
      'Lembrar com mais clareza, no seu ritmo. Plano de 5 dias.';

  @override
  String get onboardingGoalOthers => 'Outros caminhos';

  @override
  String get onboardingExperienceTitle => 'Como está sua prática?';

  @override
  String get onboardingReminderTitle => 'Quer um lembrete diário?';

  @override
  String get onboardingReminderBody =>
      'Só uma notificação local, no horário que você escolher.';

  @override
  String get goalFocus => 'Foco';

  @override
  String get goalMemory => 'Memória';

  @override
  String get goalRelaxation => 'Relaxamento';

  @override
  String get goalSleep => 'Sono';

  @override
  String get goalHabit => 'Criar o hábito';

  @override
  String get goalBreathing => 'Respiração';

  @override
  String get goalMindfulness => 'Atenção plena';

  @override
  String get experienceBeginner => 'Estou começando';

  @override
  String get experienceIntermediate => 'Já pratiquei um pouco';

  @override
  String get experienceExperienced => 'Já tenho rotina';

  @override
  String get reminderEnable => 'Lembrar-me de treinar';

  @override
  String get reminderTime => 'Horário';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeTodayTitle => 'Seu treino de hoje';

  @override
  String get homeQuestion => 'O que eu devo fazer agora?';

  @override
  String get homeStreak => 'Sequência';

  @override
  String get homeMinutes => 'minutos';

  @override
  String homeDayProgress(int current, int total) {
    return 'dia $current/$total';
  }

  @override
  String get homeCompleted => 'O próximo treino libera amanhã.';

  @override
  String get homeStartFirst => 'Inicie seu primeiro treino';

  @override
  String get homeStartToday => 'Fazer o treino de hoje';

  @override
  String get homeResumeTraining => 'Voltar ao treino';

  @override
  String get homeSeePlan => 'Ver meu plano';

  @override
  String get homeCompletedEyebrow => 'Feito por hoje';

  @override
  String homeTomorrowTraining(int day, String title) {
    return 'Amanhã libera: dia $day — $title';
  }

  @override
  String homeNextUnlocksOn(String date, int day, String title) {
    return 'Libera em $date: dia $day — $title';
  }

  @override
  String get homeNoProgram => 'Você ainda não está em um plano de treino.';

  @override
  String get homeNoProgramBody =>
      'Escolha o que você quer melhorar e entre no seu plano.';

  @override
  String get homeSessionSoon =>
      'A sessão completa chega na próxima etapa. Por enquanto, este é o seu treino do dia.';

  @override
  String get homeNowTitle => 'Áudios';

  @override
  String get homeNowBody => 'Sessões livres para ouvir quando quiser.';

  @override
  String get homeNowSleep => 'Dormir';

  @override
  String get homeNowRelax => 'Relaxar';

  @override
  String get homeNowBreathe => 'Respirar';

  @override
  String get homeNowStudy => 'Estudar';

  @override
  String get homeNowWork => 'Trabalhar';

  @override
  String get homeNowAll => 'Todos';

  @override
  String get homeSeeAll => 'Ver todos';

  @override
  String get libraryAudiosTitle => 'Todos os áudios';

  @override
  String get libraryAudiosEmpty => 'Nenhum áudio por aqui agora.';

  @override
  String get librarySearch => 'Buscar';

  @override
  String get librarySearchHint => 'Buscar áudios';

  @override
  String get libraryExercisesTitle => 'Todos os exercícios';

  @override
  String get libraryExercisesBody =>
      'Escolha um treino curto e comece quando quiser.';

  @override
  String get libraryExercisesEmpty => 'Nenhum exercício publicado agora.';

  @override
  String libraryMemoryMeta(int words, int seconds) {
    return '$words palavras · ${seconds}s para olhar';
  }

  @override
  String get libraryMemoryKindWords => 'Palavras · curto prazo';

  @override
  String get libraryMemoryKindIcons => 'Figuras · visual';

  @override
  String get libraryMemoryKindOrder => 'Sequência';

  @override
  String get libraryMemoryKindDelayed => 'Segurar na mente';

  @override
  String get libraryAttentionKindTarget => 'Toque só no alvo';

  @override
  String get libraryAttentionKindNogo => 'Toque em tudo, menos nisto';

  @override
  String get libraryAttentionKindChange => 'Toque quando mudar';

  @override
  String get libraryAttentionKindGrid => 'Ache a figura diferente';

  @override
  String get libraryBreathingKindWave => 'Círculo guiado';

  @override
  String get libraryBreathingKindBox => 'Caixa 4-4-4-4';

  @override
  String get libraryBreathingKindLadder => '4-7-8';

  @override
  String get libraryBreathingKindTide => 'Maré · expirar longo';

  @override
  String get libraryBreathingRoom => 'Sala de respiração';

  @override
  String get libraryBreathingRoomBody => 'Exercícios e áudios numa tela só.';

  @override
  String get breathingHubTitle => 'Respiração';

  @override
  String get breathingHubBody =>
      'Exercícios guiados e áudios para respirar no seu ritmo.';

  @override
  String get breathingHubExercises => 'Exercícios';

  @override
  String get breathingHubAudios => 'Áudios';

  @override
  String get breathingHubEmpty => 'Nada de respiração por aqui agora.';

  @override
  String get homeExercisesTitle => 'Exercícios';

  @override
  String get homeExercisesBody =>
      'Prática diária, atenção, memória e respiração.';

  @override
  String get homeExerciseBreathing => 'Respiração';

  @override
  String get homeExerciseAttention => 'Atenção';

  @override
  String get homeExerciseMemory => 'Memória';

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
  String get homeExploreTitle => 'As seis salas';

  @override
  String get homeExploreBody =>
      'Cada ponto tem o próprio programa. O treino de hoje continua no card de cima.';

  @override
  String get homeExploreAll => 'Ver planos';

  @override
  String get homeChoosePlan => 'Escolher meu plano';

  @override
  String get homeToolsTitle => 'Ferramentas';

  @override
  String get homeToolsBody =>
      'Check-in, mente cheia, caderno e o encerramento da noite.';

  @override
  String get homeToolPomodoro => 'Pomodoro';

  @override
  String get homeToolCheckin => 'Check-in';

  @override
  String get homeToolClearMind => 'Mente cheia';

  @override
  String get homeToolJournal => 'Caderno';

  @override
  String get homeToolThought => 'Estacionar';

  @override
  String get homeToolSilentRoom => 'Sala';

  @override
  String get homeToolDayClose => 'Noite';

  @override
  String get homeTagline => 'Respire. Foque. Evolua.';

  @override
  String get homeTodayEyebrow => 'Treino de hoje';

  @override
  String get homeProgressSection => 'Seu progresso';

  @override
  String get homeKeepExploring => 'Continue explorando';

  @override
  String get homeAreaProgress => 'Seu progresso por área';

  @override
  String get homeNextTraining => 'Próximo treino';

  @override
  String get homeMyTools => 'Minhas ferramentas';

  @override
  String get homeNumbersTitle => 'Seu momento em números';

  @override
  String get homeQuote =>
      'Pequenas escolhas diárias constroem uma mente mais forte e tranquila.';

  @override
  String get homeStatDays => 'Dias';

  @override
  String get homeStatTrained => 'Treinados';

  @override
  String get homeNowFocus => 'Foco';

  @override
  String get homeNowMemory => 'Memória';

  @override
  String get homeNowMindfulness => 'Atenção plena';

  @override
  String get homeCurrentStreak => 'Sequência atual';

  @override
  String get menuOpen => 'Menu da academia';

  @override
  String get menuClose => 'Fechar menu';

  @override
  String get menuTitle => 'Academia Mental';

  @override
  String get menuSubtitle => 'Todas as salas, num só lugar.';

  @override
  String get menuSectionTrain => 'Treino';

  @override
  String get menuSectionAudio => 'Áudios';

  @override
  String get menuSectionExercise => 'Exercícios';

  @override
  String get menuSectionTools => 'Ferramentas';

  @override
  String get menuSectionJourney => 'Jornada';

  @override
  String get menuToday => 'Treino de hoje';

  @override
  String get menuTodayHint => 'Sua sessão do dia';

  @override
  String get menuPlans => 'Planos';

  @override
  String get menuPlansHint => 'As salas da academia';

  @override
  String get menuMyPlan => 'Meu plano';

  @override
  String get menuMyPlanHint => 'Dias feitos e os próximos';

  @override
  String get menuExercisesHint => 'Atenção, memória e respiração';

  @override
  String get menuRoomHint => 'Um programa completo';

  @override
  String get menuAudios => 'Biblioteca';

  @override
  String get menuAudiosHint => 'Ouça no seu ritmo';

  @override
  String get menuSleepHint => 'Sons para a noite';

  @override
  String get menuRelaxHint => 'Soltar o corpo e a mente';

  @override
  String get menuFocusAudio => 'Áudios de foco';

  @override
  String get menuFocusAudioHint => 'Trilha para concentração';

  @override
  String get menuAttentionHint => 'Treino de alvo';

  @override
  String get menuMemoryHint => 'Palavras e presença';

  @override
  String get menuBreathingHint => 'Ritmo guiado';

  @override
  String get menuDailyHint => 'Dez treinos curtos e 15 minutos';

  @override
  String get menuPomodoroHint => 'Blocos de atenção';

  @override
  String get menuCheckinHint => 'Humor e energia';

  @override
  String get menuClearMindHint => 'Uma coisa só para hoje';

  @override
  String get menuJournalHint => 'Três linhas, só suas';

  @override
  String get menuThoughtHint => 'Escreve, guarda, segue';

  @override
  String get menuSilentRoomHint => 'Um bloco de presença';

  @override
  String get menuDayCloseHint => 'Dois minutos para fechar';

  @override
  String get menuProgressHint => 'Sequência, clima e tempo';

  @override
  String get menuHistoryHint => 'Tudo que você fez';

  @override
  String get menuRankingHint => 'Quem está treinando';

  @override
  String get menuProfileHint => 'Conta e preferências';

  @override
  String get catalogTitle => 'Catálogo';

  @override
  String get catalogEmpty => 'Nenhum programa publicado agora.';

  @override
  String catalogDays(int count) {
    return '$count dias';
  }

  @override
  String catalogDayItem(int day, String title) {
    return 'Dia $day · $title';
  }

  @override
  String get catalogBrowseHint =>
      'Um plano por vez. Se você trocar, o progresso e o relatório do plano atual são zerados.';

  @override
  String catalogFreeDays(int count) {
    return '$count dias livres';
  }

  @override
  String get catalogPlanDays => 'Os dias do plano';

  @override
  String get catalogEnroll => 'Começar este plano';

  @override
  String get catalogEnrollCurrent => 'Este é o seu plano';

  @override
  String get catalogSwitch => 'Trocar para este plano';

  @override
  String get catalogSwitchTitle => 'Trocar de plano?';

  @override
  String get catalogSwitchBody =>
      'Você só pode seguir um plano por vez. O progresso e o relatório do plano atual serão zerados.';

  @override
  String get catalogSwitchConfirm => 'Trocar mesmo assim';

  @override
  String get momentListen => 'Ouvir';

  @override
  String get prepareStart => 'Estou pronto';

  @override
  String sessionElapsed(String time) {
    return 'Tempo $time';
  }

  @override
  String get themeSection => 'Tema';

  @override
  String get themeSectionHint =>
      'O tema da noite deixa a respiração e a sessão com fundo escuro.';

  @override
  String get themeDark => 'Tema da noite';

  @override
  String get themeDarkHint => 'Fundo preto na sessão e na respiração.';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSectionHint => 'Escolha o idioma do aplicativo.';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get homeLayoutSection => 'Layout da home';

  @override
  String get homeLayoutSectionHint => 'Escolha como a tela inicial aparece.';

  @override
  String get homeLayoutToday => 'Treino de hoje';

  @override
  String get homeLayoutTodayHint => 'Imagem do dia e o treino em destaque.';

  @override
  String get homeLayoutTraining => 'Foco no treino';

  @override
  String get homeLayoutTrainingHint => 'Card grande para começar agora.';

  @override
  String get homeLayoutProgress => 'Foco no progresso';

  @override
  String get homeLayoutProgressHint => 'Sequência, áreas e o próximo treino.';

  @override
  String get playerLoadError =>
      'Não foi possível tocar o áudio. Verifique a conexão e tente de novo.';

  @override
  String get playerReplay => 'Ouvir de novo';

  @override
  String get paywallTitle => 'Continue com o Premium';

  @override
  String get paywallBody =>
      'Áudios, exercícios extras e ferramentas avançadas fazem parte do Premium. Os primeiros dias do plano continuam livres.';

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
  String get paywallCtaSoon => 'Assinatura em breve';

  @override
  String get paywallCta => 'Assinar Premium';

  @override
  String get paywallCtaRenew => 'Renovar Premium';

  @override
  String paywallCtaPrice(String price, String period) {
    return 'Assinar Premium · $price/$period';
  }

  @override
  String paywallPriceHint(String price, String period) {
    return '$price a cada $period, via Mercado Pago.';
  }

  @override
  String get paywallWaiting =>
      'Pagamento aberto no navegador. Quando voltar, o app confirma o status.';

  @override
  String get paywallOpenError =>
      'Não foi possível abrir o checkout. Tente de novo.';

  @override
  String get billingTitle => 'Assinatura';

  @override
  String get billingHistoryTitle => 'Histórico de pagamentos';

  @override
  String get billingHistoryEmpty =>
      'Quando houver uma cobrança, ela aparece aqui.';

  @override
  String get billingPeriodMonth => 'mês';

  @override
  String billingPeriodDays(int count) {
    return '$count dias';
  }

  @override
  String billingValidUntil(String date) {
    return 'Válido até $date';
  }

  @override
  String get billingStatusActive => 'Premium ativo';

  @override
  String get billingStatusPending => 'Aguardando confirmação';

  @override
  String get billingStatusFailed => 'Pagamento não aprovado';

  @override
  String get billingStatusExpired => 'Assinatura encerrada';

  @override
  String get billingStatusNone => 'Sem assinatura';

  @override
  String get billingPaymentApproved => 'Aprovado';

  @override
  String get billingPaymentPending => 'Pendente';

  @override
  String get billingPaymentFailed => 'Não aprovado';

  @override
  String get billingPaymentRefunded => 'Estornado';

  @override
  String get profilePlanFree => 'Plano gratuito';

  @override
  String get profilePlanPremium => 'Premium';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileAccountTitle => 'Conta';

  @override
  String get profileLogoutConfirm => 'Sair da conta neste aparelho?';

  @override
  String get profilePlaceholder =>
      'Ajustes de conta, lembretes e exclusão chegam a seguir.';

  @override
  String get progressTitle => 'Progresso';

  @override
  String get progressPlaceholder =>
      'Seu histórico, XP e o relatório do dia 7 aparecem aqui na próxima etapa.';

  @override
  String get profileDeleteAccount => 'Excluir conta';

  @override
  String get profileDeleteConfirm => 'Excluir sua conta?';

  @override
  String get profileDeleteConfirmBody =>
      'Sua conta deixa de funcionar neste aparelho. Esta ação não pode ser desfeita por aqui.';

  @override
  String get profileTerms => 'Termos de uso';

  @override
  String get profilePrivacy => 'Política de privacidade';

  @override
  String get profileLegalPlaceholder =>
      'O texto jurídico ainda será publicado. Até lá, este é só um atalho reservado.';

  @override
  String get profileSaved => 'Perfil atualizado.';

  @override
  String get profileEditName => 'Alterar nome';

  @override
  String get profileNameHint => 'Como você quer aparecer no ranking.';

  @override
  String get profileAvatarHint =>
      'Toque na foto para escolher uma imagem da galeria ou um símbolo calmo. Ela aparece no ranking.';

  @override
  String get profilePhotoGallery => 'Escolher da galeria';

  @override
  String get profileEmojiChoose => 'Usar um símbolo';

  @override
  String get profileEmojiTitle => 'Um símbolo para o ranking';

  @override
  String get profileEmojiBody =>
      'Sem selfie? Escolha um ícone tranquilo da academia mental.';

  @override
  String get profilePhotoRemove => 'Remover foto';

  @override
  String get profileLegalOpenError => 'Não foi possível abrir a página agora.';

  @override
  String get profileMessageTitle => 'Falar com o time';

  @override
  String get profileMessageTileBody => 'Sugestão, ideia nova ou um obrigado.';

  @override
  String get profileMessageBody =>
      'Conte o que sentiu falta, uma ideia nova ou um agradecimento. Cada mensagem vira um chamado para a gente ler.';

  @override
  String get profileMessageTypeSuggestion => 'Melhoria';

  @override
  String get profileMessageTypeFeature => 'Nova função';

  @override
  String get profileMessageTypeThanks => 'Agradecimento';

  @override
  String get profileMessageField => 'Sua mensagem';

  @override
  String get profileMessageHint =>
      'Pode ser simples. O que ajudaria no seu treino?';

  @override
  String get profileMessageTooShort =>
      'Escreva um pouco mais para a gente entender.';

  @override
  String get profileMessageSent => 'Mensagem enviada. Obrigado por escrever.';

  @override
  String get progressXp => 'XP';

  @override
  String get progressLevel => 'Nível';

  @override
  String get progressSessions => 'Sessões';

  @override
  String get progressJourneyTitle => 'Sua jornada';

  @override
  String get progressTimeHint => 'Treinos do plano e áudios livres, somados.';

  @override
  String get progressTimeUnderMinute => 'Menos de 1 min';

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
  String get progressEmptyTitle => 'Sua jornada está começando';

  @override
  String get progressEmptyBody =>
      'Complete seu primeiro treino para dar o primeiro passo. Leva só alguns minutos.';

  @override
  String get progressEmptyCta => 'Começar meu primeiro treino';

  @override
  String get progressStreakTitle => 'Sua sequência atual';

  @override
  String progressStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias consecutivos',
      one: '1 dia consecutivo',
    );
    return '$_temp0';
  }

  @override
  String progressHeroStats(String time, int count) {
    return '$time treinados · $count sessões';
  }

  @override
  String get progressMoreTitle => 'Mais';

  @override
  String get progressStatTrained => 'treinados';

  @override
  String get progressProgramTitle => 'Seu programa';

  @override
  String progressProgramDay(int current, int total) {
    return 'Dia $current de $total';
  }

  @override
  String progressProgramDaysDone(int done, int total) {
    return '$done de $total dias concluídos';
  }

  @override
  String get progressContinue => 'Continuar treino';

  @override
  String get progressWeekRhythmTitle => 'Seu ritmo';

  @override
  String progressWeekDaysTrained(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você treinou $count dias esta semana',
      one: 'Você treinou 1 dia esta semana',
    );
    return '$_temp0';
  }

  @override
  String progressWeekDeltaUp(String time) {
    return '+$time que na semana passada';
  }

  @override
  String progressWeekDeltaDown(String time) {
    return '$time a menos que na semana passada';
  }

  @override
  String get progressMilestoneTitle => 'Próximo marco';

  @override
  String progressMilestoneXp(int xp) {
    return '$xp XP para o próximo nível';
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
      other: '$count dias consecutivos',
      one: '1 dia consecutivo',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneStreakRemain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneMinutes(int minutes) {
    return '$minutes minutos treinados';
  }

  @override
  String progressMilestoneMinutesBar(int current, int target) {
    return '$current / $target min';
  }

  @override
  String get progressRecentTitle => 'Atividade recente';

  @override
  String get progressSeeHistory => 'Ver histórico';

  @override
  String get rankingTitle => 'Ranking mundial';

  @override
  String get rankingCardTitle => 'Ranking mundial';

  @override
  String get rankingCardBody =>
      'Veja quem está treinando pelo mundo. A entrada é opcional.';

  @override
  String get rankingPeriodAll => 'Geral';

  @override
  String get rankingPeriodWeekly => 'Semana';

  @override
  String get rankingOptInTitle => 'Aparecer no ranking';

  @override
  String get rankingOptInBody =>
      'Seu nome, foto ou símbolo e o XP ficam visíveis para outras pessoas do app. Você pode sair quando quiser.';

  @override
  String get rankingOptInCta => 'Entrar no ranking';

  @override
  String get rankingOptOut => 'Sair do ranking';

  @override
  String get rankingEmpty =>
      'Ainda não há pessoas no ranking. Você pode ser a primeira.';

  @override
  String rankingPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas no ranking',
      one: '1 pessoa no ranking',
      zero: 'Ninguém no ranking ainda',
    );
    return '$_temp0';
  }

  @override
  String get rankingYourPlace => 'Sua posição';

  @override
  String get rankingUnranked => 'Fora do ranking';

  @override
  String rankingXp(int xp) {
    return '$xp XP';
  }

  @override
  String rankingRank(int rank) {
    return '#$rank';
  }

  @override
  String get rankingYou => 'Você';

  @override
  String get profileRanking => 'Aparecer no ranking';

  @override
  String get profileRankingHint =>
      'Nome, foto ou símbolo e XP visíveis para outras pessoas.';

  @override
  String progressLevelName(String name) {
    return 'Nível atual: $name';
  }

  @override
  String get progressXpCardBody => 'Vem dos treinos. Toque para entender.';

  @override
  String get progressChapterTitle => 'Capítulo atual';

  @override
  String get progressPathTitle => 'O caminho';

  @override
  String get progressJourneyStart => 'Começo';

  @override
  String get progressJourneyWarm => 'Passos';

  @override
  String get progressJourneyRhythm => 'Ritmo';

  @override
  String get progressJourneyWalk => 'Caminho';

  @override
  String get progressJourneyDeep => 'Presença';

  @override
  String get progressJourneyConstancy => 'Constância';

  @override
  String get progressJourneyCopy0 =>
      'Você está no começo. Um minuto já é presença.';

  @override
  String get progressJourneyCopy1 => 'Os primeiros minutos já abrem o caminho.';

  @override
  String get progressJourneyCopy2 =>
      'O ritmo começa a aparecer. Continue sem pressa.';

  @override
  String get progressJourneyCopy3 =>
      'Sua jornada já tem corpo. Isso é treino de verdade.';

  @override
  String get progressStreakHint => 'dias em movimento';

  @override
  String get progressWeekChartTitle => 'Esta semana';

  @override
  String get progressWeekChartEmpty =>
      'Ainda não há tempo nesta semana. Um áudio ou um treino já aparece aqui.';

  @override
  String progressWeekChartTotal(String time) {
    return '$time nesta semana';
  }

  @override
  String get historyTitle => 'Histórico';

  @override
  String get historyCardTitle => 'Histórico';

  @override
  String get historyCardBody => 'Tudo que você fez no app.';

  @override
  String get historyEmpty =>
      'Um treino, um áudio, um exercício, um pomodoro, um check-in ou o caderno já aparece aqui.';

  @override
  String get historyToday => 'Hoje';

  @override
  String get historyYesterday => 'Ontem';

  @override
  String historyWhen(String weekday, String time) {
    return '$weekday às $time';
  }

  @override
  String get historyTypeExercise => 'Exercício';

  @override
  String get historyTypeSession => 'Treino';

  @override
  String get historyTypeListen => 'Áudio';

  @override
  String get historyTypePomodoro => 'Pomodoro';

  @override
  String get historyTypeCheckin => 'Check-in';

  @override
  String get historyTypeJournal => 'Caderno';

  @override
  String get historyTypeThought => 'Pensamento';

  @override
  String get historyTypeClearMind => 'Mente cheia';

  @override
  String get historyTypeDayClose => 'Encerramento';

  @override
  String get historyTypeSilentRoom => 'Sala silenciosa';

  @override
  String get sessionPrepareTitle => 'Prepare-se';

  @override
  String sessionPrepareBody(int minutes) {
    return 'Encontre um lugar calmo. O treino leva cerca de $minutes minutos. Pode haver áudio: o som não começa sozinho. Se estiver em uma sala de aula ou com outras pessoas, use fone e toque em play só quando estiver pronto.';
  }

  @override
  String get sessionAudioWait =>
      'O áudio não começa sozinho. Toque em play quando estiver em um lugar calmo. Se estiver em uma sala de aula ou com outras pessoas, use fone.';

  @override
  String get sessionAudioObjectiveTitle => 'Neste áudio';

  @override
  String get sessionAudioObjectiveFallback =>
      'Ao ouvir, acompanhe o áudio no seu ritmo. Se a mente sair, note e volte.';

  @override
  String get sessionCompleteTitle => 'Treino concluído';

  @override
  String get sessionSeeYouTomorrow => 'Até amanhã';

  @override
  String get sessionCompletingTitle => 'Guardando seu treino';

  @override
  String get sessionCompletingBody => 'Só mais um instante na Academia Mental.';

  @override
  String get sessionLoadingTitle => 'Preparando seu treino';

  @override
  String get sessionLoadingBody =>
      'Encontre um lugar calmo. A Academia Mental já vai começar.';

  @override
  String get planTitle => 'Meu plano';

  @override
  String get planUniqueHint => 'Plano único';

  @override
  String get planCadenceTitle => 'Ritmo do treino';

  @override
  String get planCadenceBody =>
      'Você segue um plano por vez. O próximo dia libera no próximo dia de treino, no seu fuso. Os mesmos exercícios podem aparecer em outros planos, mas o seu currículo agora é este.';

  @override
  String get planCadenceDaily => 'Todos os dias';

  @override
  String get planCadenceWeekdays => 'Dias úteis';

  @override
  String get planCadenceHintDaily =>
      'O próximo treino libera no dia seguinte, no seu fuso.';

  @override
  String get planCadenceHintWeekdays =>
      'Segunda a sexta. Se você concluir na sexta, o próximo libera na segunda.';

  @override
  String get planReminderHint => 'O aviso chega no horário escolhido.';

  @override
  String get planEmpty => 'Você ainda não está em um plano.';

  @override
  String planDaysDone(int done, int total) {
    return '$done de $total dias';
  }

  @override
  String get planSettings => 'Ritmo e lembrete';

  @override
  String get planDoneForToday => 'Feito por hoje.';

  @override
  String planNextUnlocksTomorrow(String title) {
    return 'Amanhã libera: $title';
  }

  @override
  String planNextTraining(String title, String date) {
    return 'Libera em $date: $title';
  }

  @override
  String get planDayDone => 'Concluído';

  @override
  String get planDayToday => 'Hoje';

  @override
  String get planDayTomorrow => 'Amanhã';

  @override
  String planDayLocked(String date) {
    return 'Libera em $date';
  }

  @override
  String planDayLabel(int day, String title) {
    return 'Dia $day — $title';
  }

  @override
  String sessionXpAwarded(int xp) {
    return '+$xp XP';
  }

  @override
  String sessionBlockOf(int current, int total) {
    return '$current de $total';
  }

  @override
  String get breathingInhale => 'INSPIRAR';

  @override
  String get breathingHold => 'SEGURAR';

  @override
  String get breathingExhale => 'EXPIRAR';

  @override
  String get breathingRest => 'PAUSA';

  @override
  String breathingCycle(int current, int total) {
    return 'ciclo $current/$total';
  }

  @override
  String get playerPlay => 'Tocar';

  @override
  String get playerPause => 'Pausar';

  @override
  String get playerNext => 'Próxima';

  @override
  String get playerNowPlaying => 'Tocando agora';

  @override
  String get playerVolume => 'Volume';

  @override
  String get playerCoverExpand => 'Ampliar capa';

  @override
  String get playerPrevious => 'Anterior';

  @override
  String get playerRepeat => 'Repetir';

  @override
  String get playerFavorite => 'Favoritar';

  @override
  String get playerFavorited => 'Na sua lista';

  @override
  String get playerTimer => 'Timer';

  @override
  String get playerTimerOff => 'Sem timer';

  @override
  String get playerAboutTitle => 'Sobre esta sessão';

  @override
  String get playerAboutBody =>
      'Ouça no seu ritmo. Pause quando quiser e volte quando fizer sentido.';

  @override
  String get attentionPrompt => 'Toque só quando aparecer o alvo.';

  @override
  String get attentionBriefingTitle => 'Atenção ao alvo';

  @override
  String get attentionBriefingBody =>
      'Figuras vão aparecer. Toque somente na figura abaixo. Se vier outra, não toque. O ritmo acelera aos poucos.';

  @override
  String get attentionBriefingNogoTitle => 'Controle o toque';

  @override
  String get attentionBriefingNogoBody =>
      'Toque em todas as figuras, menos na que aparece abaixo. O treino é segurar o impulso.';

  @override
  String get attentionBriefingChangeTitle => 'Quando muda';

  @override
  String get attentionBriefingChangeBody =>
      'Toque só quando a figura for diferente da anterior. Se for a mesma, espere.';

  @override
  String get attentionBriefingGridTitle => 'Ache o diferente';

  @override
  String get attentionBriefingGridBody =>
      'Nove figuras aparecem juntas. Toque só na que não combina com as outras.';

  @override
  String get attentionTargetLabel => 'Toque só nesta figura';

  @override
  String get attentionNogoLabel => 'Não toque nesta figura';

  @override
  String get attentionChangeLabel => 'Toque quando a figura mudar';

  @override
  String get attentionGridLabel => 'Toque a que é diferente';

  @override
  String get attentionPreviousLabel => 'Anterior';

  @override
  String get breathingBriefingTitle => 'Respiração guiada';

  @override
  String get breathingBriefingBody =>
      'Acompanhe o círculo. Inspire, segure e expire no ritmo. Sem pressa e sem perfeição.';

  @override
  String get breathingBriefingBoxTitle => 'Respiração em caixa';

  @override
  String get breathingBriefingBoxBody =>
      'Um quadrado, quatro lados. Inspire, segure, expire e pause. O ponto anda com você.';

  @override
  String get breathingBriefingLadderTitle => '4-7-8';

  @override
  String get breathingBriefingLadderBody =>
      'Inspire em 4, segure em 7, expire em 8. A coluna sobe e desce com o ar.';

  @override
  String get breathingBriefingTideTitle => 'Maré longa';

  @override
  String get breathingBriefingTideBody =>
      'A expiração é mais longa que a inspiração. Acompanhe a maré indo e voltando. Sem forçar.';

  @override
  String get memoryBriefingTitle => 'Memória de palavras';

  @override
  String get memoryBriefingBody =>
      'Primeiro observe as palavras. Depois marque só as que você lembra.';

  @override
  String get memoryBriefingIconsTitle => 'Memória visual';

  @override
  String get memoryBriefingIconsBody =>
      'Observe as figuras. Depois marque só as que você viu.';

  @override
  String get memoryBriefingOrderTitle => 'Memória de sequência';

  @override
  String get memoryBriefingOrderBody =>
      'As palavras aparecem uma a uma. Depois toque na mesma ordem.';

  @override
  String get memoryBriefingDelayedTitle => 'Segurar na mente';

  @override
  String get memoryBriefingDelayedBody =>
      'Observe, espere um pouco com o que ficou, depois marque o que lembra.';

  @override
  String get exerciseBriefingStart => 'Começar';

  @override
  String get exerciseDurationLabel => 'Quanto tempo você quer treinar?';

  @override
  String exerciseDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String attentionHits(int count) {
    return 'Acertos: $count';
  }

  @override
  String attentionMisses(int count) {
    return 'Erros: $count';
  }

  @override
  String get memoryStudyTitle => 'Observe as palavras';

  @override
  String get memorySelectTitle => 'Quais palavras você lembra?';

  @override
  String get memoryStudyIconsTitle => 'Observe as figuras';

  @override
  String get memorySelectIconsTitle => 'Quais figuras você viu?';

  @override
  String get memoryHoldTitle => 'Segure na mente';

  @override
  String get memoryHoldBody =>
      'Elas saíram da tela. Fique com o que ficou, sem ensaiar.';

  @override
  String get memoryOrderStudyTitle => 'Veja a ordem';

  @override
  String get memoryOrderSelectTitle => 'Toque na mesma ordem';

  @override
  String get memoryOrderReset => 'Começar de novo';

  @override
  String get memoryWordsTitle => 'Minhas palavras';

  @override
  String get memoryWordsHint =>
      'Adicione palavras suas. Elas entram no exercício, misturadas e em ordem nova a cada vez.';

  @override
  String get memoryWordsAdd => 'Adicionar minhas palavras';

  @override
  String get memoryWordsEmpty =>
      'Ainda não há palavras suas. O treino usa um conjunto aleatório.';

  @override
  String get memoryWordsField => 'Nova palavra';

  @override
  String memoryWordsCount(int count) {
    return '$count palavras suas';
  }

  @override
  String get ratingSelect => 'Escolha um valor';

  @override
  String get unknownExercise => 'Atualize o aplicativo para este exercício.';

  @override
  String get exerciseRoomDone => 'Sessão concluída.';

  @override
  String get notificationTitle => 'MindVibe';

  @override
  String get notificationBody =>
      'Seu treino de hoje está esperando por você. 🧠';

  @override
  String get actionDelete => 'Excluir conta';

  @override
  String get emptyTitle => 'Nada por aqui ainda';

  @override
  String get loadingLabel => 'Carregando…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String get pomodoroHint => '25 minutos de atenção, 5 de pausa. Sem pressão.';

  @override
  String get pomodoroFocus => 'Foco';

  @override
  String get pomodoroBreak => 'Pausa';

  @override
  String get pomodoroStart => 'Começar';

  @override
  String get pomodoroPause => 'Pausar';

  @override
  String get pomodoroReset => 'Recomeçar';

  @override
  String get pomodoroPresetClassic => '25 + 5';

  @override
  String get pomodoroPresetShort => '15 + 5';

  @override
  String get pomodoroPresetLong => '50 + 10';

  @override
  String pomodoroRounds(int count) {
    return '$count blocos feitos';
  }

  @override
  String get checkinTitle => 'Check-in';

  @override
  String get checkinHint =>
      'Como está agora? Um toque em cada eixo. Dez segundos.';

  @override
  String get checkinMoodTitle => 'Humor';

  @override
  String get checkinEnergyTitle => 'Energia';

  @override
  String checkinMood(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Muito pesado',
      '2': 'Pesado',
      '3': 'Neutro',
      '4': 'Leve',
      '5': 'Bom',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinEnergy(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Sem força',
      '2': 'Baixa',
      '3': 'Média',
      '4': 'Boa',
      '5': 'Alta',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinWeight(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Dia pesado',
      '2': 'Dia mais calmo',
      '3': 'Dia em equilíbrio',
      '4': 'Dia em movimento',
      '5': 'Dia leve',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get checkinSaved =>
      'Registrado. Isso vira o clima de hoje no progresso.';

  @override
  String get checkinSaving => 'Guardando…';

  @override
  String get checkinSeeProgress => 'Ver no progresso';

  @override
  String get checkinUpdateHint => 'Pode tocar de novo se o dia mudou.';

  @override
  String get checkinPromptLater => 'Agora não';

  @override
  String get progressCheckinTitle => 'Clima do dia';

  @override
  String get progressCheckinEmpty => 'Como está o dia? Dez segundos, um toque.';

  @override
  String get progressCheckinCta => 'Fazer check-in';

  @override
  String progressCheckinBody(String mood, String energy) {
    return 'Humor $mood · Energia $energy';
  }

  @override
  String get progressStreakCheckinHint =>
      'A sequência é aparecer. O clima explica o peso do dia melhor do que só os minutos.';

  @override
  String get clearMindTitle => 'Mente cheia';

  @override
  String get clearMindIntro =>
      'Não é hora de mais informação. É hora de desacelerar e recuperar espaço.';

  @override
  String get clearMindStart => 'Começar';

  @override
  String get clearMindPauseBody =>
      'Afastar. Respirar. Sem tentar resolver nada.';

  @override
  String get clearMindSkipPause => 'Já respirei';

  @override
  String get clearMindDumpBody =>
      'Escreve o que está passando pela cabeça. Sem organizar.';

  @override
  String get clearMindDumpHint => 'O que não larga agora';

  @override
  String get clearMindAdd => 'Mais uma';

  @override
  String get clearMindDumpNext => 'Continuar';

  @override
  String get clearMindQuestion =>
      'Dessas coisas todas que estão na sua cabeça agora, qual é a única que realmente precisa da sua atenção hoje?';

  @override
  String get clearMindPickHint => 'Toque em uma. O resto pode esperar.';

  @override
  String get clearMindKeepOne => 'Ficar com esta';

  @override
  String get clearMindDoneEyebrow => 'Hoje, só isto';

  @override
  String clearMindParked(int count) {
    return 'O resto foi estacionado ($count). Não precisa ser resolvido hoje.';
  }

  @override
  String get clearMindParkedNone => 'Só isto. Nada mais para estacionar.';

  @override
  String get clearMindDone => 'Pronto';

  @override
  String get clearMindSeeLot => 'Ver o pátio';

  @override
  String get clearMindOneThing => 'Uma coisa por vez';

  @override
  String get clearMindHomeCard => 'Hoje, só isto';

  @override
  String get clearMindHomeCta =>
      'Cabeça cheia? Descarrega e fica com uma coisa só.';

  @override
  String get clearMindFromCheckin => 'Está com a mente cheia?';

  @override
  String get journalTitle => 'Caderno';

  @override
  String get journalHint =>
      'Três linhas. Intenção da manhã, descarregar a cabeça, ou 3 gratidões. Curto, privado, volta amanhã.';

  @override
  String journalPrompt(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'Intenção da manhã',
      'unload': 'Descarregar a cabeça',
      'gratitude': '3 gratidões',
      'other': 'Caderno',
    });
    return '$_temp0';
  }

  @override
  String journalPromptHint(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'O que você leva para o dia.',
      'unload': 'Tira da mente o que está ocupando espaço.',
      'gratitude': 'Três coisas pequenas que ainda estão aqui.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get journalIntention1 => 'O que importa hoje?';

  @override
  String get journalIntention2 => 'Um passo pequeno';

  @override
  String get journalIntention3 => 'Como quero chegar à noite';

  @override
  String get journalUnload1 => 'O que está ocupando a cabeça?';

  @override
  String get journalUnload2 => 'O que pode esperar';

  @override
  String get journalUnload3 => 'O que eu solto agora';

  @override
  String get journalGratitude1 => 'Uma coisa boa';

  @override
  String get journalGratitude2 => 'Outra';

  @override
  String get journalGratitude3 => 'Mais uma';

  @override
  String get journalSave => 'Guardar';

  @override
  String get journalUpdate => 'Atualizar hoje';

  @override
  String get journalSaved =>
      'Guardado. Só você lê. Amanhã o caderno volta em branco.';

  @override
  String get journalPrivate => 'Ninguém mais vê. Nem no ranking.';

  @override
  String get journalWeek => 'Dias em que você escreveu';

  @override
  String get silentRoomTitle => 'Sala silenciosa';

  @override
  String get silentRoomHint =>
      'Um bloco de presença. Sem ciclo, sem pausa. Para quem acha o Pomodoro pesado.';

  @override
  String get silentRoomPresence => 'Presença';

  @override
  String get silentRoomDone => 'Bloco concluído';

  @override
  String silentRoomMinutes(int count) {
    return '$count min';
  }

  @override
  String get thoughtTitle => 'Estacionar o pensamento';

  @override
  String get thoughtHint =>
      'Escreve o que está ocupando a mente. Guarda e segue — para o treino, o áudio ou o sono.';

  @override
  String get thoughtPlaceholder => 'O que não larga agora';

  @override
  String get thoughtSave => 'Guardar e seguir';

  @override
  String get thoughtSaved => 'Está guardado. A mente pode seguir.';

  @override
  String get thoughtPrivate => 'Só você lê. Não vai para o ranking.';

  @override
  String get thoughtContinue => 'Seguir para';

  @override
  String get thoughtContinueTraining => 'Treino';

  @override
  String get thoughtContinueAudio => 'Áudio';

  @override
  String get thoughtContinueSleep => 'Sono';

  @override
  String get thoughtLot => 'No pátio';

  @override
  String get thoughtLotEmpty => 'Nada estacionado.';

  @override
  String get thoughtLotFull =>
      'O pátio está cheio. Solte um pensamento para estacionar outro.';

  @override
  String get thoughtRelease => 'Soltar';

  @override
  String get dayCloseTitle => 'Encerramento do dia';

  @override
  String get dayCloseHint =>
      'Dois minutos. O que ficou, o que solta, um áudio curto. Fecha a academia como o treino fecha o dia no corpo.';

  @override
  String get dayCloseKept => 'O que ficou';

  @override
  String get dayCloseReleased => 'O que solta';

  @override
  String get dayCloseSave => 'Fechar o dia';

  @override
  String get dayCloseUpdate => 'Atualizar hoje';

  @override
  String get dayCloseSaved =>
      'O dia está fechado. Só você lê. Agora o áudio curto.';

  @override
  String get dayClosePrivate => 'Só você lê. Não vai para o ranking.';

  @override
  String get dayCloseAudio => 'Áudio curto';

  @override
  String get dayClosePlay => 'Ouvir';

  @override
  String get dayCloseWeek => 'Noites em que você fechou';

  @override
  String get xpInfoTitle => 'Sobre o XP';

  @override
  String get xpInfoLead =>
      'XP cresce quando você conclui um treino. As ferramentas e os áudios acompanham o dia, sem somar pontos.';

  @override
  String get xpInfoGivesTitle => 'O que dá XP';

  @override
  String get xpInfoGivesBody =>
      'Concluir a sessão do programa. Terminar um ciclo. Conquistas ligadas ao treino.';

  @override
  String get xpInfoSkipsTitle => 'O que não dá';

  @override
  String get xpInfoSkipsBody =>
      'Check-in, mente cheia, caderno, estacionar o pensamento, encerramento, Pomodoro, sala silenciosa e ouvir áudios. Eles ficam no histórico e no clima. Sem XP.';

  @override
  String get xpInfoWhereTitle => 'Onde aparece';

  @override
  String get xpInfoWhereBody =>
      'Em Progresso, na home e no fim do treino. No ranking, só se você quiser aparecer.';

  @override
  String get xpInfoStreakTitle => 'Sequência';

  @override
  String get xpInfoStreakBody =>
      'A sequência conta dias com treino concluído. O check-in é o clima do dia, não a sequência.';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get appName => 'MindVibe';

  @override
  String get appTagline => 'Academia Mental';

  @override
  String get brandLine => 'Um lugar tranquilo para treinar sua mente.';

  @override
  String get tabHome => 'Início';

  @override
  String get tabProgress => 'Progresso';

  @override
  String get tabProfile => 'Perfil';

  @override
  String get actionContinue => 'Continuar';

  @override
  String get actionBack => 'Voltar';

  @override
  String get actionStart => 'Começar treino';

  @override
  String get actionLogin => 'Entrar';

  @override
  String get actionRegister => 'Criar conta';

  @override
  String get actionForgotPassword => 'Recuperar senha';

  @override
  String get actionSend => 'Enviar';

  @override
  String get actionSave => 'Salvar';

  @override
  String get actionLogout => 'Sair';

  @override
  String get actionRetry => 'Tentar de novo';

  @override
  String get actionSkip => 'Pular';

  @override
  String get actionSubscribe => 'Assinar';

  @override
  String get actionTransferDevice => 'Trocar associação';

  @override
  String get actionComingSoon => 'Em breve';

  @override
  String get fieldName => 'Nome';

  @override
  String get fieldEmail => 'E-mail';

  @override
  String get fieldPassword => 'Senha';

  @override
  String get fieldPasswordConfirm => 'Confirmar senha';

  @override
  String get passwordShow => 'Mostrar senha';

  @override
  String get passwordHide => 'Ocultar senha';

  @override
  String get fieldResetToken => 'Código de redefinição';

  @override
  String get validationRequired => 'Preencha este campo.';

  @override
  String get validationEmail => 'Digite um e-mail válido.';

  @override
  String get validationPasswordMin =>
      'A senha precisa ter pelo menos 8 caracteres.';

  @override
  String get validationPasswordMatch => 'As senhas não coincidem.';

  @override
  String get splashLoading => 'Preparando seu espaço…';

  @override
  String get welcomeTitle => 'Bem-vindo à MindVibe';

  @override
  String get welcomeBody =>
      'Assim como você treina seu corpo em uma academia, você pode criar uma rotina para treinar sua mente.';

  @override
  String get welcomeLogin => 'Já tenho conta';

  @override
  String get welcomeRegister => 'Começar agora';

  @override
  String get loginTitle => 'Entrar';

  @override
  String get loginSubtitle => 'Continue seu treino de onde parou.';

  @override
  String get registerTitle => 'Criar conta';

  @override
  String get registerSubtitle => 'Só e-mail e senha. Sem redes sociais.';

  @override
  String get forgotTitle => 'Recuperar senha';

  @override
  String get forgotSubtitle => 'Enviaremos um código para o seu e-mail.';

  @override
  String get forgotSent =>
      'Se este e-mail estiver cadastrado, você receberá as instruções em instantes.';

  @override
  String get resetTitle => 'Redefinir senha';

  @override
  String get resetSubtitle => 'Use o código recebido por e-mail.';

  @override
  String get resetSuccess => 'Senha atualizada. Entre com a nova senha.';

  @override
  String get deviceAssociatedTitle => 'Este aparelho já tem uma conta';

  @override
  String deviceAssociatedBody(String email) {
    return 'Este aparelho já possui uma conta cadastrada com o e-mail $email.';
  }

  @override
  String get deviceAssociatedHint =>
      'Entre nessa conta, recupere a senha ou troque a associação depois de autenticar. Não criamos uma conta nova em silêncio.';

  @override
  String get errorGeneric => 'Algo não saiu como esperado. Tente de novo.';

  @override
  String get errorOffline =>
      'Sem conexão. Verifique a internet e tente novamente.';

  @override
  String get errorUnauthorized => 'Sua sessão expirou. Entre novamente.';

  @override
  String get errorNotFound => 'Não encontramos o que você procura.';

  @override
  String get errorServer => 'O servidor está indisponível no momento.';

  @override
  String get errorUpdateApp => 'Atualize o aplicativo para continuar.';

  @override
  String get onboardingWelcomeTitle => 'Vamos começar com calma';

  @override
  String get onboardingWelcomeBody =>
      'Em poucos passos você escolhe o que quer fortalecer e entra no seu plano.';

  @override
  String get onboardingNameTitle => 'Como podemos te chamar?';

  @override
  String get onboardingGoalTitle => 'O que você quer melhorar?';

  @override
  String get onboardingGoalHint =>
      'Escolha um plano. Você segue um por vez — pode trocar depois.';

  @override
  String get onboardingGoalFocusBody =>
      'Fortalecer a atenção no trabalho, no estudo e no dia a dia. Plano de 7 dias.';

  @override
  String get onboardingGoalMindfulnessBody =>
      'Treinar presença e notar o que acontece agora, com mais calma. Plano de 5 dias.';

  @override
  String get onboardingGoalMemoryBody =>
      'Lembrar com mais clareza, no seu ritmo. Plano de 5 dias.';

  @override
  String get onboardingGoalOthers => 'Outros caminhos';

  @override
  String get onboardingExperienceTitle => 'Como está sua prática?';

  @override
  String get onboardingReminderTitle => 'Quer um lembrete diário?';

  @override
  String get onboardingReminderBody =>
      'Só uma notificação local, no horário que você escolher.';

  @override
  String get goalFocus => 'Foco';

  @override
  String get goalMemory => 'Memória';

  @override
  String get goalRelaxation => 'Relaxamento';

  @override
  String get goalSleep => 'Sono';

  @override
  String get goalHabit => 'Criar o hábito';

  @override
  String get goalBreathing => 'Respiração';

  @override
  String get goalMindfulness => 'Atenção plena';

  @override
  String get experienceBeginner => 'Estou começando';

  @override
  String get experienceIntermediate => 'Já pratiquei um pouco';

  @override
  String get experienceExperienced => 'Já tenho rotina';

  @override
  String get reminderEnable => 'Lembrar-me de treinar';

  @override
  String get reminderTime => 'Horário';

  @override
  String homeGreeting(String name) {
    return 'Olá, $name';
  }

  @override
  String get homeTodayTitle => 'Seu treino de hoje';

  @override
  String get homeQuestion => 'O que eu devo fazer agora?';

  @override
  String get homeStreak => 'Sequência';

  @override
  String get homeMinutes => 'minutos';

  @override
  String homeDayProgress(int current, int total) {
    return 'dia $current/$total';
  }

  @override
  String get homeCompleted => 'O próximo treino libera amanhã.';

  @override
  String get homeStartFirst => 'Inicie seu primeiro treino';

  @override
  String get homeStartToday => 'Fazer o treino de hoje';

  @override
  String get homeResumeTraining => 'Voltar ao treino';

  @override
  String get homeSeePlan => 'Ver meu plano';

  @override
  String get homeCompletedEyebrow => 'Feito por hoje';

  @override
  String homeTomorrowTraining(int day, String title) {
    return 'Amanhã libera: dia $day — $title';
  }

  @override
  String homeNextUnlocksOn(String date, int day, String title) {
    return 'Libera em $date: dia $day — $title';
  }

  @override
  String get homeNoProgram => 'Você ainda não está em um plano de treino.';

  @override
  String get homeNoProgramBody =>
      'Escolha o que você quer melhorar e entre no seu plano.';

  @override
  String get homeSessionSoon =>
      'A sessão completa chega na próxima etapa. Por enquanto, este é o seu treino do dia.';

  @override
  String get homeNowTitle => 'Áudios';

  @override
  String get homeNowBody => 'Sessões livres para ouvir quando quiser.';

  @override
  String get homeNowSleep => 'Dormir';

  @override
  String get homeNowRelax => 'Relaxar';

  @override
  String get homeNowBreathe => 'Respirar';

  @override
  String get homeNowStudy => 'Estudar';

  @override
  String get homeNowWork => 'Trabalhar';

  @override
  String get homeNowAll => 'Todos';

  @override
  String get homeSeeAll => 'Ver todos';

  @override
  String get libraryAudiosTitle => 'Todos os áudios';

  @override
  String get libraryAudiosEmpty => 'Nenhum áudio por aqui agora.';

  @override
  String get librarySearch => 'Buscar';

  @override
  String get librarySearchHint => 'Buscar áudios';

  @override
  String get libraryExercisesTitle => 'Todos os exercícios';

  @override
  String get libraryExercisesBody =>
      'Escolha um treino curto e comece quando quiser.';

  @override
  String get libraryExercisesEmpty => 'Nenhum exercício publicado agora.';

  @override
  String libraryMemoryMeta(int words, int seconds) {
    return '$words palavras · ${seconds}s para olhar';
  }

  @override
  String get libraryMemoryKindWords => 'Palavras · curto prazo';

  @override
  String get libraryMemoryKindIcons => 'Figuras · visual';

  @override
  String get libraryMemoryKindOrder => 'Sequência';

  @override
  String get libraryMemoryKindDelayed => 'Segurar na mente';

  @override
  String get libraryAttentionKindTarget => 'Toque só no alvo';

  @override
  String get libraryAttentionKindNogo => 'Toque em tudo, menos nisto';

  @override
  String get libraryAttentionKindChange => 'Toque quando mudar';

  @override
  String get libraryAttentionKindGrid => 'Ache a figura diferente';

  @override
  String get libraryBreathingKindWave => 'Círculo guiado';

  @override
  String get libraryBreathingKindBox => 'Caixa 4-4-4-4';

  @override
  String get libraryBreathingKindLadder => '4-7-8';

  @override
  String get libraryBreathingKindTide => 'Maré · expirar longo';

  @override
  String get libraryBreathingRoom => 'Sala de respiração';

  @override
  String get libraryBreathingRoomBody => 'Exercícios e áudios numa tela só.';

  @override
  String get breathingHubTitle => 'Respiração';

  @override
  String get breathingHubBody =>
      'Exercícios guiados e áudios para respirar no seu ritmo.';

  @override
  String get breathingHubExercises => 'Exercícios';

  @override
  String get breathingHubAudios => 'Áudios';

  @override
  String get breathingHubEmpty => 'Nada de respiração por aqui agora.';

  @override
  String get homeExercisesTitle => 'Exercícios';

  @override
  String get homeExercisesBody =>
      'Prática diária, atenção, memória e respiração.';

  @override
  String get homeExerciseBreathing => 'Respiração';

  @override
  String get homeExerciseAttention => 'Atenção';

  @override
  String get homeExerciseMemory => 'Memória';

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
  String get homeExploreTitle => 'As seis salas';

  @override
  String get homeExploreBody =>
      'Cada ponto tem o próprio programa. O treino de hoje continua no card de cima.';

  @override
  String get homeExploreAll => 'Ver planos';

  @override
  String get homeChoosePlan => 'Escolher meu plano';

  @override
  String get homeToolsTitle => 'Ferramentas';

  @override
  String get homeToolsBody =>
      'Check-in, mente cheia, caderno e o encerramento da noite.';

  @override
  String get homeToolPomodoro => 'Pomodoro';

  @override
  String get homeToolCheckin => 'Check-in';

  @override
  String get homeToolClearMind => 'Mente cheia';

  @override
  String get homeToolJournal => 'Caderno';

  @override
  String get homeToolThought => 'Estacionar';

  @override
  String get homeToolSilentRoom => 'Sala';

  @override
  String get homeToolDayClose => 'Noite';

  @override
  String get homeTagline => 'Respire. Foque. Evolua.';

  @override
  String get homeTodayEyebrow => 'Treino de hoje';

  @override
  String get homeProgressSection => 'Seu progresso';

  @override
  String get homeKeepExploring => 'Continue explorando';

  @override
  String get homeAreaProgress => 'Seu progresso por área';

  @override
  String get homeNextTraining => 'Próximo treino';

  @override
  String get homeMyTools => 'Minhas ferramentas';

  @override
  String get homeNumbersTitle => 'Seu momento em números';

  @override
  String get homeQuote =>
      'Pequenas escolhas diárias constroem uma mente mais forte e tranquila.';

  @override
  String get homeStatDays => 'Dias';

  @override
  String get homeStatTrained => 'Treinados';

  @override
  String get homeNowFocus => 'Foco';

  @override
  String get homeNowMemory => 'Memória';

  @override
  String get homeNowMindfulness => 'Atenção plena';

  @override
  String get homeCurrentStreak => 'Sequência atual';

  @override
  String get menuOpen => 'Menu da academia';

  @override
  String get menuClose => 'Fechar menu';

  @override
  String get menuTitle => 'Academia Mental';

  @override
  String get menuSubtitle => 'Todas as salas, num só lugar.';

  @override
  String get menuSectionTrain => 'Treino';

  @override
  String get menuSectionAudio => 'Áudios';

  @override
  String get menuSectionExercise => 'Exercícios';

  @override
  String get menuSectionTools => 'Ferramentas';

  @override
  String get menuSectionJourney => 'Jornada';

  @override
  String get menuToday => 'Treino de hoje';

  @override
  String get menuTodayHint => 'Sua sessão do dia';

  @override
  String get menuPlans => 'Planos';

  @override
  String get menuPlansHint => 'Trocar ou conhecer outro plano';

  @override
  String get menuMyPlan => 'Meu plano';

  @override
  String get menuMyPlanHint => 'Sessão de hoje, dias e ritmo';

  @override
  String get menuExercisesHint => 'Atenção, memória e respiração';

  @override
  String get menuRoomHint => 'Um programa completo';

  @override
  String get menuAudios => 'Biblioteca';

  @override
  String get menuAudiosHint => 'Ouça no seu ritmo';

  @override
  String get menuSleepHint => 'Sons para a noite';

  @override
  String get menuRelaxHint => 'Soltar o corpo e a mente';

  @override
  String get menuFocusAudio => 'Áudios de foco';

  @override
  String get menuFocusAudioHint => 'Trilha para concentração';

  @override
  String get menuAttentionHint => 'Treino de alvo';

  @override
  String get menuMemoryHint => 'Palavras e presença';

  @override
  String get menuBreathingHint => 'Ritmo guiado';

  @override
  String get menuDailyHint => 'Dez treinos curtos e 15 minutos';

  @override
  String get menuPomodoroHint => 'Blocos de atenção';

  @override
  String get menuCheckinHint => 'Humor e energia';

  @override
  String get menuClearMindHint => 'Uma coisa só para hoje';

  @override
  String get menuJournalHint => 'Três linhas, só suas';

  @override
  String get menuThoughtHint => 'Escreve, guarda, segue';

  @override
  String get menuSilentRoomHint => 'Um bloco de presença';

  @override
  String get menuDayCloseHint => 'Dois minutos para fechar';

  @override
  String get menuProgressHint => 'Sequência, clima e tempo';

  @override
  String get menuHistoryHint => 'Tudo que você fez';

  @override
  String get menuRankingHint => 'Quem está treinando';

  @override
  String get menuProfileHint => 'Conta e preferências';

  @override
  String get catalogTitle => 'Catálogo';

  @override
  String get catalogEmpty => 'Nenhum programa publicado agora.';

  @override
  String catalogDays(int count) {
    return '$count dias';
  }

  @override
  String catalogDayItem(int day, String title) {
    return 'Dia $day · $title';
  }

  @override
  String get catalogBrowseHint =>
      'Um plano por vez. Se você trocar, o progresso e o relatório do plano atual são zerados.';

  @override
  String catalogFreeDays(int count) {
    return '$count dias livres';
  }

  @override
  String get catalogPlanDays => 'Os dias do plano';

  @override
  String get catalogEnroll => 'Começar este plano';

  @override
  String get catalogEnrollCurrent => 'Este é o seu plano';

  @override
  String get catalogSwitch => 'Trocar para este plano';

  @override
  String get catalogSwitchTitle => 'Trocar de plano?';

  @override
  String get catalogSwitchBody =>
      'Você só pode seguir um plano por vez. O progresso e o relatório do plano atual serão zerados.';

  @override
  String get catalogSwitchConfirm => 'Trocar mesmo assim';

  @override
  String get momentListen => 'Ouvir';

  @override
  String get prepareStart => 'Estou pronto';

  @override
  String sessionElapsed(String time) {
    return 'Tempo $time';
  }

  @override
  String get themeSection => 'Tema';

  @override
  String get themeSectionHint =>
      'O tema da noite deixa a respiração e a sessão com fundo escuro.';

  @override
  String get themeDark => 'Tema da noite';

  @override
  String get themeDarkHint => 'Fundo preto na sessão e na respiração.';

  @override
  String get languageSection => 'Idioma';

  @override
  String get languageSectionHint => 'Escolha o idioma do aplicativo.';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageEnglish => 'English';

  @override
  String get homeLayoutSection => 'Layout da home';

  @override
  String get homeLayoutSectionHint => 'Escolha como a tela inicial aparece.';

  @override
  String get homeLayoutToday => 'Treino de hoje';

  @override
  String get homeLayoutTodayHint => 'Imagem do dia e o treino em destaque.';

  @override
  String get homeLayoutTraining => 'Foco no treino';

  @override
  String get homeLayoutTrainingHint => 'Card grande para começar agora.';

  @override
  String get homeLayoutProgress => 'Foco no progresso';

  @override
  String get homeLayoutProgressHint => 'Sequência, áreas e o próximo treino.';

  @override
  String get playerLoadError =>
      'Não foi possível tocar o áudio. Verifique a conexão e tente de novo.';

  @override
  String get playerReplay => 'Ouvir de novo';

  @override
  String get paywallTitle => 'Continue com o Premium';

  @override
  String get paywallBody =>
      'Áudios, exercícios extras e ferramentas avançadas fazem parte do Premium. Check-in, caderno, Mente cheia e os primeiros dias do plano continuam livres.';

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
  String get paywallCtaSoon => 'Assinatura em breve';

  @override
  String get paywallCta => 'Assinar Premium';

  @override
  String get paywallCtaRenew => 'Renovar Premium';

  @override
  String paywallCtaPrice(String price, String period) {
    return 'Assinar Premium · $price/$period';
  }

  @override
  String paywallPriceHint(String price, String period) {
    return '$price a cada $period, via Mercado Pago.';
  }

  @override
  String get paywallWaiting =>
      'Pagamento aberto no navegador. Quando voltar, o app confirma o status.';

  @override
  String get paywallOpenError =>
      'Não foi possível abrir o checkout. Tente de novo.';

  @override
  String get billingTitle => 'Assinatura';

  @override
  String get billingHistoryTitle => 'Histórico de pagamentos';

  @override
  String get billingHistoryEmpty =>
      'Quando houver uma cobrança, ela aparece aqui.';

  @override
  String get billingPeriodMonth => 'mês';

  @override
  String billingPeriodDays(int count) {
    return '$count dias';
  }

  @override
  String billingValidUntil(String date) {
    return 'Válido até $date';
  }

  @override
  String get billingStatusActive => 'Premium ativo';

  @override
  String get billingStatusPending => 'Aguardando confirmação';

  @override
  String get billingStatusFailed => 'Pagamento não aprovado';

  @override
  String get billingStatusExpired => 'Assinatura encerrada';

  @override
  String get billingStatusNone => 'Sem assinatura';

  @override
  String get billingPaymentApproved => 'Aprovado';

  @override
  String get billingPaymentPending => 'Pendente';

  @override
  String get billingPaymentFailed => 'Não aprovado';

  @override
  String get billingPaymentRefunded => 'Estornado';

  @override
  String get profilePlanFree => 'Plano gratuito';

  @override
  String get profilePlanPremium => 'Premium';

  @override
  String get profileTitle => 'Perfil';

  @override
  String get profileAccountTitle => 'Conta';

  @override
  String get profileLogoutConfirm => 'Sair da conta neste aparelho?';

  @override
  String get profilePlaceholder =>
      'Ajustes de conta, lembretes e exclusão chegam a seguir.';

  @override
  String get progressTitle => 'Progresso';

  @override
  String get progressPlaceholder =>
      'Seu histórico, XP e o relatório do dia 7 aparecem aqui na próxima etapa.';

  @override
  String get profileDeleteAccount => 'Excluir conta';

  @override
  String get profileDeleteConfirm => 'Excluir sua conta?';

  @override
  String get profileDeleteConfirmBody =>
      'Sua conta deixa de funcionar neste aparelho. Esta ação não pode ser desfeita por aqui.';

  @override
  String get profileTerms => 'Termos de uso';

  @override
  String get profilePrivacy => 'Política de privacidade';

  @override
  String get profileLegalPlaceholder =>
      'O texto jurídico ainda será publicado. Até lá, este é só um atalho reservado.';

  @override
  String get profileSaved => 'Perfil atualizado.';

  @override
  String get profileEditName => 'Alterar nome';

  @override
  String get profileNameHint => 'Como você quer aparecer no ranking.';

  @override
  String get profileAvatarHint =>
      'Toque na foto para escolher uma imagem da galeria ou um símbolo calmo. Ela aparece no ranking.';

  @override
  String get profilePhotoGallery => 'Escolher da galeria';

  @override
  String get profileEmojiChoose => 'Usar um símbolo';

  @override
  String get profileEmojiTitle => 'Um símbolo para o ranking';

  @override
  String get profileEmojiBody =>
      'Sem selfie? Escolha um ícone tranquilo da academia mental.';

  @override
  String get profilePhotoRemove => 'Remover foto';

  @override
  String get profileLegalOpenError => 'Não foi possível abrir a página agora.';

  @override
  String get profileMessageTitle => 'Falar com o time';

  @override
  String get profileMessageTileBody => 'Sugestão, ideia nova ou um obrigado.';

  @override
  String get profileMessageBody =>
      'Conte o que sentiu falta, uma ideia nova ou um agradecimento. Cada mensagem vira um chamado para a gente ler.';

  @override
  String get profileMessageTypeSuggestion => 'Melhoria';

  @override
  String get profileMessageTypeFeature => 'Nova função';

  @override
  String get profileMessageTypeThanks => 'Agradecimento';

  @override
  String get profileMessageField => 'Sua mensagem';

  @override
  String get profileMessageHint =>
      'Pode ser simples. O que ajudaria no seu treino?';

  @override
  String get profileMessageTooShort =>
      'Escreva um pouco mais para a gente entender.';

  @override
  String get profileMessageSent => 'Mensagem enviada. Obrigado por escrever.';

  @override
  String get progressXp => 'XP';

  @override
  String get progressLevel => 'Nível';

  @override
  String get progressSessions => 'Sessões';

  @override
  String get progressJourneyTitle => 'Sua jornada';

  @override
  String get progressTimeHint => 'Treinos do plano e áudios livres, somados.';

  @override
  String get progressTimeUnderMinute => 'Menos de 1 min';

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
  String get progressEmptyTitle => 'Sua jornada está começando';

  @override
  String get progressEmptyBody =>
      'Complete seu primeiro treino para dar o primeiro passo. Leva só alguns minutos.';

  @override
  String get progressEmptyCta => 'Começar meu primeiro treino';

  @override
  String get progressStreakTitle => 'Sua sequência atual';

  @override
  String progressStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias consecutivos',
      one: '1 dia consecutivo',
    );
    return '$_temp0';
  }

  @override
  String progressHeroStats(String time, int count) {
    return '$time treinados · $count sessões';
  }

  @override
  String get progressMoreTitle => 'Mais';

  @override
  String get progressStatTrained => 'treinados';

  @override
  String get progressProgramTitle => 'Seu programa';

  @override
  String progressProgramDay(int current, int total) {
    return 'Dia $current de $total';
  }

  @override
  String progressProgramDaysDone(int done, int total) {
    return '$done de $total dias concluídos';
  }

  @override
  String get progressContinue => 'Continuar treino';

  @override
  String get progressWeekRhythmTitle => 'Seu ritmo';

  @override
  String progressWeekDaysTrained(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Você treinou $count dias esta semana',
      one: 'Você treinou 1 dia esta semana',
    );
    return '$_temp0';
  }

  @override
  String progressWeekDeltaUp(String time) {
    return '+$time que na semana passada';
  }

  @override
  String progressWeekDeltaDown(String time) {
    return '$time a menos que na semana passada';
  }

  @override
  String get progressMilestoneTitle => 'Próximo marco';

  @override
  String progressMilestoneXp(int xp) {
    return '$xp XP para o próximo nível';
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
      other: '$count dias consecutivos',
      one: '1 dia consecutivo',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneStreakRemain(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Faltam $count dias',
      one: 'Falta 1 dia',
    );
    return '$_temp0';
  }

  @override
  String progressMilestoneMinutes(int minutes) {
    return '$minutes minutos treinados';
  }

  @override
  String progressMilestoneMinutesBar(int current, int target) {
    return '$current / $target min';
  }

  @override
  String get progressRecentTitle => 'Atividade recente';

  @override
  String get progressSeeHistory => 'Ver histórico';

  @override
  String get rankingTitle => 'Ranking mundial';

  @override
  String get rankingCardTitle => 'Ranking mundial';

  @override
  String get rankingCardBody =>
      'Veja quem está treinando pelo mundo. A entrada é opcional.';

  @override
  String get rankingPeriodAll => 'Geral';

  @override
  String get rankingPeriodWeekly => 'Semana';

  @override
  String get rankingOptInTitle => 'Aparecer no ranking';

  @override
  String get rankingOptInBody =>
      'Seu nome, foto ou símbolo e o XP ficam visíveis para outras pessoas do app. Você pode sair quando quiser.';

  @override
  String get rankingOptInCta => 'Entrar no ranking';

  @override
  String get rankingOptOut => 'Sair do ranking';

  @override
  String get rankingEmpty =>
      'Ainda não há pessoas no ranking. Você pode ser a primeira.';

  @override
  String rankingPlayers(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pessoas no ranking',
      one: '1 pessoa no ranking',
      zero: 'Ninguém no ranking ainda',
    );
    return '$_temp0';
  }

  @override
  String get rankingYourPlace => 'Sua posição';

  @override
  String get rankingUnranked => 'Fora do ranking';

  @override
  String rankingXp(int xp) {
    return '$xp XP';
  }

  @override
  String rankingRank(int rank) {
    return '#$rank';
  }

  @override
  String get rankingYou => 'Você';

  @override
  String get profileRanking => 'Aparecer no ranking';

  @override
  String get profileRankingHint =>
      'Nome, foto ou símbolo e XP visíveis para outras pessoas.';

  @override
  String progressLevelName(String name) {
    return 'Nível atual: $name';
  }

  @override
  String get progressXpCardBody => 'Vem dos treinos. Toque para entender.';

  @override
  String get progressChapterTitle => 'Capítulo atual';

  @override
  String get progressPathTitle => 'O caminho';

  @override
  String get progressJourneyStart => 'Começo';

  @override
  String get progressJourneyWarm => 'Passos';

  @override
  String get progressJourneyRhythm => 'Ritmo';

  @override
  String get progressJourneyWalk => 'Caminho';

  @override
  String get progressJourneyDeep => 'Presença';

  @override
  String get progressJourneyConstancy => 'Constância';

  @override
  String get progressJourneyCopy0 =>
      'Você está no começo. Um minuto já é presença.';

  @override
  String get progressJourneyCopy1 => 'Os primeiros minutos já abrem o caminho.';

  @override
  String get progressJourneyCopy2 =>
      'O ritmo começa a aparecer. Continue sem pressa.';

  @override
  String get progressJourneyCopy3 =>
      'Sua jornada já tem corpo. Isso é treino de verdade.';

  @override
  String get progressStreakHint => 'dias em movimento';

  @override
  String get progressWeekChartTitle => 'Esta semana';

  @override
  String get progressWeekChartEmpty =>
      'Ainda não há tempo nesta semana. Um áudio ou um treino já aparece aqui.';

  @override
  String progressWeekChartTotal(String time) {
    return '$time nesta semana';
  }

  @override
  String get historyTitle => 'Histórico';

  @override
  String get historyCardTitle => 'Histórico';

  @override
  String get historyCardBody => 'Tudo que você fez no app.';

  @override
  String get historyEmpty =>
      'Um treino, um áudio, um exercício, um pomodoro, um check-in ou o caderno já aparece aqui.';

  @override
  String get historyToday => 'Hoje';

  @override
  String get historyYesterday => 'Ontem';

  @override
  String historyWhen(String weekday, String time) {
    return '$weekday às $time';
  }

  @override
  String get historyTypeExercise => 'Exercício';

  @override
  String get historyTypeSession => 'Treino';

  @override
  String get historyTypeListen => 'Áudio';

  @override
  String get historyTypePomodoro => 'Pomodoro';

  @override
  String get historyTypeCheckin => 'Check-in';

  @override
  String get historyTypeJournal => 'Caderno';

  @override
  String get historyTypeThought => 'Pensamento';

  @override
  String get historyTypeClearMind => 'Mente cheia';

  @override
  String get historyTypeDayClose => 'Encerramento';

  @override
  String get historyTypeSilentRoom => 'Sala silenciosa';

  @override
  String get sessionPrepareTitle => 'Prepare-se';

  @override
  String sessionPrepareBody(int minutes) {
    return 'Encontre um lugar calmo. O treino leva cerca de $minutes minutos. Pode haver áudio: o som não começa sozinho. Se estiver em uma sala de aula ou com outras pessoas, use fone e toque em play só quando estiver pronto.';
  }

  @override
  String get sessionAudioWait =>
      'O áudio não começa sozinho. Toque em play quando estiver em um lugar calmo. Se estiver em uma sala de aula ou com outras pessoas, use fone.';

  @override
  String get sessionAudioObjectiveTitle => 'Neste áudio';

  @override
  String get sessionAudioObjectiveFallback =>
      'Ao ouvir, acompanhe o áudio no seu ritmo. Se a mente sair, note e volte.';

  @override
  String get sessionCompleteTitle => 'Treino concluído';

  @override
  String get sessionSeeYouTomorrow => 'Até amanhã';

  @override
  String get sessionCompletingTitle => 'Guardando seu treino';

  @override
  String get sessionCompletingBody => 'Só mais um instante na Academia Mental.';

  @override
  String get sessionLoadingTitle => 'Preparando seu treino';

  @override
  String get sessionLoadingBody =>
      'Encontre um lugar calmo. A Academia Mental já vai começar.';

  @override
  String get planTitle => 'Meu plano';

  @override
  String get planUniqueHint => 'Plano único';

  @override
  String get planCadenceTitle => 'Ritmo do treino';

  @override
  String get planCadenceBody =>
      'Você segue um plano por vez. O próximo dia libera no próximo dia de treino, no seu fuso. Os mesmos exercícios podem aparecer em outros planos, mas o seu currículo agora é este.';

  @override
  String get planCadenceDaily => 'Todos os dias';

  @override
  String get planCadenceWeekdays => 'Dias úteis';

  @override
  String get planCadenceHintDaily =>
      'O próximo treino libera no dia seguinte, no seu fuso.';

  @override
  String get planCadenceHintWeekdays =>
      'Segunda a sexta. Se você concluir na sexta, o próximo libera na segunda.';

  @override
  String get planReminderHint => 'O aviso chega no horário escolhido.';

  @override
  String get planEmpty => 'Você ainda não está em um plano.';

  @override
  String planDaysDone(int done, int total) {
    return '$done de $total dias';
  }

  @override
  String get planSettings => 'Ritmo e lembrete';

  @override
  String get planDoneForToday => 'Feito por hoje.';

  @override
  String planNextUnlocksTomorrow(String title) {
    return 'Amanhã libera: $title';
  }

  @override
  String planNextTraining(String title, String date) {
    return 'Libera em $date: $title';
  }

  @override
  String get planDayDone => 'Concluído';

  @override
  String get planDayToday => 'Hoje';

  @override
  String get planDayTomorrow => 'Amanhã';

  @override
  String planDayLocked(String date) {
    return 'Libera em $date';
  }

  @override
  String planDayLabel(int day, String title) {
    return 'Dia $day — $title';
  }

  @override
  String sessionXpAwarded(int xp) {
    return '+$xp XP';
  }

  @override
  String sessionBlockOf(int current, int total) {
    return '$current de $total';
  }

  @override
  String get breathingInhale => 'INSPIRAR';

  @override
  String get breathingHold => 'SEGURAR';

  @override
  String get breathingExhale => 'EXPIRAR';

  @override
  String get breathingRest => 'PAUSA';

  @override
  String breathingCycle(int current, int total) {
    return 'ciclo $current/$total';
  }

  @override
  String get playerPlay => 'Tocar';

  @override
  String get playerPause => 'Pausar';

  @override
  String get playerNext => 'Próxima';

  @override
  String get playerNowPlaying => 'Tocando agora';

  @override
  String get playerVolume => 'Volume';

  @override
  String get playerCoverExpand => 'Ampliar capa';

  @override
  String get playerPrevious => 'Anterior';

  @override
  String get playerRepeat => 'Repetir';

  @override
  String get playerFavorite => 'Favoritar';

  @override
  String get playerFavorited => 'Na sua lista';

  @override
  String get playerTimer => 'Timer';

  @override
  String get playerTimerOff => 'Sem timer';

  @override
  String get playerAboutTitle => 'Sobre esta sessão';

  @override
  String get playerAboutBody =>
      'Ouça no seu ritmo. Pause quando quiser e volte quando fizer sentido.';

  @override
  String get attentionPrompt => 'Toque só quando aparecer o alvo.';

  @override
  String get attentionBriefingTitle => 'Atenção ao alvo';

  @override
  String get attentionBriefingBody =>
      'Figuras vão aparecer. Toque somente na figura abaixo. Se vier outra, não toque. O ritmo acelera aos poucos.';

  @override
  String get attentionBriefingNogoTitle => 'Controle o toque';

  @override
  String get attentionBriefingNogoBody =>
      'Toque em todas as figuras, menos na que aparece abaixo. O treino é segurar o impulso.';

  @override
  String get attentionBriefingChangeTitle => 'Quando muda';

  @override
  String get attentionBriefingChangeBody =>
      'Toque só quando a figura for diferente da anterior. Se for a mesma, espere.';

  @override
  String get attentionBriefingGridTitle => 'Ache o diferente';

  @override
  String get attentionBriefingGridBody =>
      'Nove figuras aparecem juntas. Toque só na que não combina com as outras.';

  @override
  String get attentionTargetLabel => 'Toque só nesta figura';

  @override
  String get attentionNogoLabel => 'Não toque nesta figura';

  @override
  String get attentionChangeLabel => 'Toque quando a figura mudar';

  @override
  String get attentionGridLabel => 'Toque a que é diferente';

  @override
  String get attentionPreviousLabel => 'Anterior';

  @override
  String get breathingBriefingTitle => 'Respiração guiada';

  @override
  String get breathingBriefingBody =>
      'Acompanhe o círculo. Inspire, segure e expire no ritmo. Sem pressa e sem perfeição.';

  @override
  String get breathingBriefingBoxTitle => 'Respiração em caixa';

  @override
  String get breathingBriefingBoxBody =>
      'Um quadrado, quatro lados. Inspire, segure, expire e pause. O ponto anda com você.';

  @override
  String get breathingBriefingLadderTitle => '4-7-8';

  @override
  String get breathingBriefingLadderBody =>
      'Inspire em 4, segure em 7, expire em 8. A coluna sobe e desce com o ar.';

  @override
  String get breathingBriefingTideTitle => 'Maré longa';

  @override
  String get breathingBriefingTideBody =>
      'A expiração é mais longa que a inspiração. Acompanhe a maré indo e voltando. Sem forçar.';

  @override
  String get memoryBriefingTitle => 'Memória de palavras';

  @override
  String get memoryBriefingBody =>
      'Primeiro observe as palavras. Depois marque só as que você lembra.';

  @override
  String get memoryBriefingIconsTitle => 'Memória visual';

  @override
  String get memoryBriefingIconsBody =>
      'Observe as figuras. Depois marque só as que você viu.';

  @override
  String get memoryBriefingOrderTitle => 'Memória de sequência';

  @override
  String get memoryBriefingOrderBody =>
      'As palavras aparecem uma a uma. Depois toque na mesma ordem.';

  @override
  String get memoryBriefingDelayedTitle => 'Segurar na mente';

  @override
  String get memoryBriefingDelayedBody =>
      'Observe, espere um pouco com o que ficou, depois marque o que lembra.';

  @override
  String get exerciseBriefingStart => 'Começar';

  @override
  String get exerciseDurationLabel => 'Quanto tempo você quer treinar?';

  @override
  String exerciseDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String attentionHits(int count) {
    return 'Acertos: $count';
  }

  @override
  String attentionMisses(int count) {
    return 'Erros: $count';
  }

  @override
  String get memoryStudyTitle => 'Observe as palavras';

  @override
  String get memorySelectTitle => 'Quais palavras você lembra?';

  @override
  String get memoryStudyIconsTitle => 'Observe as figuras';

  @override
  String get memorySelectIconsTitle => 'Quais figuras você viu?';

  @override
  String get memoryHoldTitle => 'Segure na mente';

  @override
  String get memoryHoldBody =>
      'Elas saíram da tela. Fique com o que ficou, sem ensaiar.';

  @override
  String get memoryOrderStudyTitle => 'Veja a ordem';

  @override
  String get memoryOrderSelectTitle => 'Toque na mesma ordem';

  @override
  String get memoryOrderReset => 'Começar de novo';

  @override
  String get memoryWordsTitle => 'Minhas palavras';

  @override
  String get memoryWordsHint =>
      'Adicione palavras suas. Elas entram no exercício, misturadas e em ordem nova a cada vez.';

  @override
  String get memoryWordsAdd => 'Adicionar minhas palavras';

  @override
  String get memoryWordsEmpty =>
      'Ainda não há palavras suas. O treino usa um conjunto aleatório.';

  @override
  String get memoryWordsField => 'Nova palavra';

  @override
  String memoryWordsCount(int count) {
    return '$count palavras suas';
  }

  @override
  String get ratingSelect => 'Escolha um valor';

  @override
  String get unknownExercise => 'Atualize o aplicativo para este exercício.';

  @override
  String get exerciseRoomDone => 'Sessão concluída.';

  @override
  String get notificationTitle => 'MindVibe';

  @override
  String get notificationBody =>
      'Seu treino de hoje está esperando por você. 🧠';

  @override
  String get actionDelete => 'Excluir conta';

  @override
  String get emptyTitle => 'Nada por aqui ainda';

  @override
  String get loadingLabel => 'Carregando…';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get pomodoroTitle => 'Pomodoro';

  @override
  String get pomodoroHint => '25 minutos de atenção, 5 de pausa. Sem pressão.';

  @override
  String get pomodoroFocus => 'Foco';

  @override
  String get pomodoroBreak => 'Pausa';

  @override
  String get pomodoroStart => 'Começar';

  @override
  String get pomodoroPause => 'Pausar';

  @override
  String get pomodoroReset => 'Recomeçar';

  @override
  String get pomodoroPresetClassic => '25 + 5';

  @override
  String get pomodoroPresetShort => '15 + 5';

  @override
  String get pomodoroPresetLong => '50 + 10';

  @override
  String pomodoroRounds(int count) {
    return '$count blocos feitos';
  }

  @override
  String get checkinTitle => 'Check-in';

  @override
  String get checkinHint =>
      'Como está agora? Um toque em cada eixo. Dez segundos.';

  @override
  String get checkinMoodTitle => 'Humor';

  @override
  String get checkinEnergyTitle => 'Energia';

  @override
  String checkinMood(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Muito pesado',
      '2': 'Pesado',
      '3': 'Neutro',
      '4': 'Leve',
      '5': 'Bom',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinEnergy(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Sem força',
      '2': 'Baixa',
      '3': 'Média',
      '4': 'Boa',
      '5': 'Alta',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String checkinWeight(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      '1': 'Dia pesado',
      '2': 'Dia mais calmo',
      '3': 'Dia em equilíbrio',
      '4': 'Dia em movimento',
      '5': 'Dia leve',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get checkinSaved =>
      'Registrado. Isso vira o clima de hoje no progresso.';

  @override
  String get checkinSaving => 'Guardando…';

  @override
  String get checkinSeeProgress => 'Ver no progresso';

  @override
  String get checkinUpdateHint => 'Pode tocar de novo se o dia mudou.';

  @override
  String get checkinPromptLater => 'Agora não';

  @override
  String get progressCheckinTitle => 'Clima do dia';

  @override
  String get progressCheckinEmpty => 'Como está o dia? Dez segundos, um toque.';

  @override
  String get progressCheckinCta => 'Fazer check-in';

  @override
  String progressCheckinBody(String mood, String energy) {
    return 'Humor $mood · Energia $energy';
  }

  @override
  String get progressStreakCheckinHint =>
      'A sequência é aparecer. O clima explica o peso do dia melhor do que só os minutos.';

  @override
  String get clearMindTitle => 'Mente cheia';

  @override
  String get clearMindIntro =>
      'Não é hora de mais informação. É hora de desacelerar e recuperar espaço.';

  @override
  String get clearMindStart => 'Começar';

  @override
  String get clearMindPauseBody =>
      'Afastar. Respirar. Sem tentar resolver nada.';

  @override
  String get clearMindSkipPause => 'Já respirei';

  @override
  String get clearMindDumpBody =>
      'Escreve o que está passando pela cabeça. Sem organizar.';

  @override
  String get clearMindDumpHint => 'O que não larga agora';

  @override
  String get clearMindAdd => 'Mais uma';

  @override
  String get clearMindDumpNext => 'Continuar';

  @override
  String get clearMindQuestion =>
      'Dessas coisas todas que estão na sua cabeça agora, qual é a única que realmente precisa da sua atenção hoje?';

  @override
  String get clearMindPickHint => 'Toque em uma. O resto pode esperar.';

  @override
  String get clearMindKeepOne => 'Ficar com esta';

  @override
  String get clearMindDoneEyebrow => 'Hoje, só isto';

  @override
  String clearMindParked(int count) {
    return 'O resto foi estacionado ($count). Não precisa ser resolvido hoje.';
  }

  @override
  String get clearMindParkedNone => 'Só isto. Nada mais para estacionar.';

  @override
  String get clearMindDone => 'Pronto';

  @override
  String get clearMindSeeLot => 'Ver o pátio';

  @override
  String get clearMindOneThing => 'Uma coisa por vez';

  @override
  String get clearMindHomeCard => 'Hoje, só isto';

  @override
  String get clearMindHomeCta =>
      'Cabeça cheia? Descarrega e fica com uma coisa só.';

  @override
  String get clearMindFromCheckin => 'Está com a mente cheia?';

  @override
  String get journalTitle => 'Caderno';

  @override
  String get journalHint =>
      'Três linhas. Intenção da manhã, descarregar a cabeça, ou 3 gratidões. Curto, privado, volta amanhã.';

  @override
  String journalPrompt(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'Intenção da manhã',
      'unload': 'Descarregar a cabeça',
      'gratitude': '3 gratidões',
      'other': 'Caderno',
    });
    return '$_temp0';
  }

  @override
  String journalPromptHint(String prompt) {
    String _temp0 = intl.Intl.selectLogic(prompt, {
      'intention': 'O que você leva para o dia.',
      'unload': 'Tira da mente o que está ocupando espaço.',
      'gratitude': 'Três coisas pequenas que ainda estão aqui.',
      'other': '',
    });
    return '$_temp0';
  }

  @override
  String get journalIntention1 => 'O que importa hoje?';

  @override
  String get journalIntention2 => 'Um passo pequeno';

  @override
  String get journalIntention3 => 'Como quero chegar à noite';

  @override
  String get journalUnload1 => 'O que está ocupando a cabeça?';

  @override
  String get journalUnload2 => 'O que pode esperar';

  @override
  String get journalUnload3 => 'O que eu solto agora';

  @override
  String get journalGratitude1 => 'Uma coisa boa';

  @override
  String get journalGratitude2 => 'Outra';

  @override
  String get journalGratitude3 => 'Mais uma';

  @override
  String get journalSave => 'Guardar';

  @override
  String get journalUpdate => 'Atualizar hoje';

  @override
  String get journalSaved =>
      'Guardado. Só você lê. Amanhã o caderno volta em branco.';

  @override
  String get journalPrivate => 'Ninguém mais vê. Nem no ranking.';

  @override
  String get journalWeek => 'Dias em que você escreveu';

  @override
  String get silentRoomTitle => 'Sala silenciosa';

  @override
  String get silentRoomHint =>
      'Um bloco de presença. Sem ciclo, sem pausa. Para quem acha o Pomodoro pesado.';

  @override
  String get silentRoomPresence => 'Presença';

  @override
  String get silentRoomDone => 'Bloco concluído';

  @override
  String silentRoomMinutes(int count) {
    return '$count min';
  }

  @override
  String get thoughtTitle => 'Estacionar o pensamento';

  @override
  String get thoughtHint =>
      'Escreve o que está ocupando a mente. Guarda e segue — para o treino, o áudio ou o sono.';

  @override
  String get thoughtPlaceholder => 'O que não larga agora';

  @override
  String get thoughtSave => 'Guardar e seguir';

  @override
  String get thoughtSaved => 'Está guardado. A mente pode seguir.';

  @override
  String get thoughtPrivate => 'Só você lê. Não vai para o ranking.';

  @override
  String get thoughtContinue => 'Seguir para';

  @override
  String get thoughtContinueTraining => 'Treino';

  @override
  String get thoughtContinueAudio => 'Áudio';

  @override
  String get thoughtContinueSleep => 'Sono';

  @override
  String get thoughtLot => 'No pátio';

  @override
  String get thoughtLotEmpty => 'Nada estacionado.';

  @override
  String get thoughtLotFull =>
      'O pátio está cheio. Solte um pensamento para estacionar outro.';

  @override
  String get thoughtRelease => 'Soltar';

  @override
  String get dayCloseTitle => 'Encerramento do dia';

  @override
  String get dayCloseHint =>
      'Dois minutos. O que ficou, o que solta, um áudio curto. Fecha a academia como o treino fecha o dia no corpo.';

  @override
  String get dayCloseKept => 'O que ficou';

  @override
  String get dayCloseReleased => 'O que solta';

  @override
  String get dayCloseSave => 'Fechar o dia';

  @override
  String get dayCloseUpdate => 'Atualizar hoje';

  @override
  String get dayCloseSaved =>
      'O dia está fechado. Só você lê. Agora o áudio curto.';

  @override
  String get dayClosePrivate => 'Só você lê. Não vai para o ranking.';

  @override
  String get dayCloseAudio => 'Áudio curto';

  @override
  String get dayClosePlay => 'Ouvir';

  @override
  String get dayCloseWeek => 'Noites em que você fechou';

  @override
  String get xpInfoTitle => 'Sobre o XP';

  @override
  String get xpInfoLead =>
      'XP cresce quando você conclui um treino. As ferramentas e os áudios acompanham o dia, sem somar pontos.';

  @override
  String get xpInfoGivesTitle => 'O que dá XP';

  @override
  String get xpInfoGivesBody =>
      'Concluir a sessão do programa. Terminar um ciclo. Conquistas ligadas ao treino.';

  @override
  String get xpInfoSkipsTitle => 'O que não dá';

  @override
  String get xpInfoSkipsBody =>
      'Check-in, mente cheia, caderno, estacionar o pensamento, encerramento, Pomodoro, sala silenciosa e ouvir áudios. Eles ficam no histórico e no clima. Sem XP.';

  @override
  String get xpInfoWhereTitle => 'Onde aparece';

  @override
  String get xpInfoWhereBody =>
      'Em Progresso, na home e no fim do treino. No ranking, só se você quiser aparecer.';

  @override
  String get xpInfoStreakTitle => 'Sequência';

  @override
  String get xpInfoStreakBody =>
      'A sequência conta dias com treino concluído. O check-in é o clima do dia, não a sequência.';
}
