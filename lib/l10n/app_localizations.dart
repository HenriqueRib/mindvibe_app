import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('en', 'US'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appName.
  ///
  /// In pt_BR, this message translates to:
  /// **'MindVibe'**
  String get appName;

  /// No description provided for @appTagline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Academia Mental'**
  String get appTagline;

  /// No description provided for @brandLine.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um lugar tranquilo para treinar sua mente.'**
  String get brandLine;

  /// No description provided for @tabHome.
  ///
  /// In pt_BR, this message translates to:
  /// **'Início'**
  String get tabHome;

  /// No description provided for @tabProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Progresso'**
  String get tabProgress;

  /// No description provided for @tabProfile.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get tabProfile;

  /// No description provided for @actionContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar'**
  String get actionContinue;

  /// No description provided for @actionBack.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar'**
  String get actionBack;

  /// No description provided for @actionStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar treino'**
  String get actionStart;

  /// No description provided for @actionLogin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get actionLogin;

  /// No description provided for @actionRegister.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get actionRegister;

  /// No description provided for @actionForgotPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperar senha'**
  String get actionForgotPassword;

  /// No description provided for @actionSend.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar'**
  String get actionSend;

  /// No description provided for @actionSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get actionSave;

  /// No description provided for @actionLogout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get actionLogout;

  /// No description provided for @actionRetry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar de novo'**
  String get actionRetry;

  /// No description provided for @actionSkip.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pular'**
  String get actionSkip;

  /// No description provided for @actionSubscribe.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinar'**
  String get actionSubscribe;

  /// No description provided for @actionTransferDevice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar associação'**
  String get actionTransferDevice;

  /// No description provided for @actionComingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em breve'**
  String get actionComingSoon;

  /// No description provided for @fieldName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get fieldName;

  /// No description provided for @fieldEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get fieldPassword;

  /// No description provided for @fieldPasswordConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar senha'**
  String get fieldPasswordConfirm;

  /// No description provided for @passwordShow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mostrar senha'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ocultar senha'**
  String get passwordHide;

  /// No description provided for @fieldResetToken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código de redefinição'**
  String get fieldResetToken;

  /// No description provided for @validationRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preencha este campo.'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digite um e-mail válido.'**
  String get validationEmail;

  /// No description provided for @validationPasswordMin.
  ///
  /// In pt_BR, this message translates to:
  /// **'A senha precisa ter pelo menos 8 caracteres.'**
  String get validationPasswordMin;

  /// No description provided for @validationPasswordMatch.
  ///
  /// In pt_BR, this message translates to:
  /// **'As senhas não coincidem.'**
  String get validationPasswordMatch;

  /// No description provided for @splashLoading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preparando seu espaço…'**
  String get splashLoading;

  /// No description provided for @welcomeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bem-vindo à MindVibe'**
  String get welcomeTitle;

  /// No description provided for @welcomeBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assim como você treina seu corpo em uma academia, você pode criar uma rotina para treinar sua mente.'**
  String get welcomeBody;

  /// No description provided for @welcomeLogin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tenho conta'**
  String get welcomeLogin;

  /// No description provided for @welcomeRegister.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar agora'**
  String get welcomeRegister;

  /// No description provided for @loginTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continue seu treino de onde parou.'**
  String get loginSubtitle;

  /// No description provided for @registerTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar conta'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só e-mail e senha. Sem redes sociais.'**
  String get registerSubtitle;

  /// No description provided for @forgotTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recuperar senha'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviaremos um código para o seu e-mail.'**
  String get forgotSubtitle;

  /// No description provided for @forgotSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Se este e-mail estiver cadastrado, você receberá as instruções em instantes.'**
  String get forgotSent;

  /// No description provided for @resetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redefinir senha'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Use o código recebido por e-mail.'**
  String get resetSubtitle;

  /// No description provided for @resetSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha atualizada. Entre com a nova senha.'**
  String get resetSuccess;

  /// No description provided for @deviceAssociatedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este aparelho já tem uma conta'**
  String get deviceAssociatedTitle;

  /// No description provided for @deviceAssociatedBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este aparelho já possui uma conta cadastrada com o e-mail {email}.'**
  String deviceAssociatedBody(String email);

  /// No description provided for @deviceAssociatedHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entre nessa conta, recupere a senha ou troque a associação depois de autenticar. Não criamos uma conta nova em silêncio.'**
  String get deviceAssociatedHint;

  /// No description provided for @errorGeneric.
  ///
  /// In pt_BR, this message translates to:
  /// **'Algo não saiu como esperado. Tente de novo.'**
  String get errorGeneric;

  /// No description provided for @errorOffline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem conexão. Verifique a internet e tente novamente.'**
  String get errorOffline;

  /// No description provided for @errorUnauthorized.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua sessão expirou. Entre novamente.'**
  String get errorUnauthorized;

  /// No description provided for @errorNotFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não encontramos o que você procura.'**
  String get errorNotFound;

  /// No description provided for @errorServer.
  ///
  /// In pt_BR, this message translates to:
  /// **'O servidor está indisponível no momento.'**
  String get errorServer;

  /// No description provided for @errorUpdateApp.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize o aplicativo para continuar.'**
  String get errorUpdateApp;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vamos começar com calma'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em poucos passos você escolhe o que quer fortalecer e entra no seu plano.'**
  String get onboardingWelcomeBody;

  /// No description provided for @onboardingNameTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como podemos te chamar?'**
  String get onboardingNameTitle;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você quer melhorar?'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingGoalHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um plano. Você segue um por vez — pode trocar depois.'**
  String get onboardingGoalHint;

  /// No description provided for @onboardingGoalFocusBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fortalecer a atenção no trabalho, no estudo e no dia a dia. Plano de 7 dias.'**
  String get onboardingGoalFocusBody;

  /// No description provided for @onboardingGoalMindfulnessBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinar presença e notar o que acontece agora, com mais calma. Plano de 5 dias.'**
  String get onboardingGoalMindfulnessBody;

  /// No description provided for @onboardingGoalMemoryBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembrar com mais clareza, no seu ritmo. Plano de 5 dias.'**
  String get onboardingGoalMemoryBody;

  /// No description provided for @onboardingGoalOthers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outros caminhos'**
  String get onboardingGoalOthers;

  /// No description provided for @onboardingExperienceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está sua prática?'**
  String get onboardingExperienceTitle;

  /// No description provided for @onboardingReminderTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quer um lembrete diário?'**
  String get onboardingReminderTitle;

  /// No description provided for @onboardingReminderBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só uma notificação local, no horário que você escolher.'**
  String get onboardingReminderBody;

  /// No description provided for @goalFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco'**
  String get goalFocus;

  /// No description provided for @goalMemory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória'**
  String get goalMemory;

  /// No description provided for @goalRelaxation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxamento'**
  String get goalRelaxation;

  /// No description provided for @goalSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sono'**
  String get goalSleep;

  /// No description provided for @goalHabit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar o hábito'**
  String get goalHabit;

  /// No description provided for @goalBreathing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get goalBreathing;

  /// No description provided for @goalMindfulness.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção plena'**
  String get goalMindfulness;

  /// No description provided for @experienceBeginner.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estou começando'**
  String get experienceBeginner;

  /// No description provided for @experienceIntermediate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já pratiquei um pouco'**
  String get experienceIntermediate;

  /// No description provided for @experienceExperienced.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tenho rotina'**
  String get experienceExperienced;

  /// No description provided for @reminderEnable.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lembrar-me de treinar'**
  String get reminderEnable;

  /// No description provided for @reminderTime.
  ///
  /// In pt_BR, this message translates to:
  /// **'Horário'**
  String get reminderTime;

  /// No description provided for @homeGreeting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olá, {name}'**
  String homeGreeting(String name);

  /// No description provided for @homeTodayTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu treino de hoje'**
  String get homeTodayTitle;

  /// No description provided for @homeQuestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que eu devo fazer agora?'**
  String get homeQuestion;

  /// No description provided for @homeStreak.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência'**
  String get homeStreak;

  /// No description provided for @homeMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'minutos'**
  String get homeMinutes;

  /// No description provided for @homeDayProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'dia {current}/{total}'**
  String homeDayProgress(int current, int total);

  /// No description provided for @homeCompleted.
  ///
  /// In pt_BR, this message translates to:
  /// **'O próximo treino libera amanhã.'**
  String get homeCompleted;

  /// No description provided for @homeStartFirst.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inicie seu primeiro treino'**
  String get homeStartFirst;

  /// No description provided for @homeStartToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fazer o treino de hoje'**
  String get homeStartToday;

  /// No description provided for @homeResumeTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar ao treino'**
  String get homeResumeTraining;

  /// No description provided for @homeSeePlan.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver meu plano'**
  String get homeSeePlan;

  /// No description provided for @homeCompletedEyebrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feito por hoje'**
  String get homeCompletedEyebrow;

  /// No description provided for @homeTomorrowTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amanhã libera: dia {day} — {title}'**
  String homeTomorrowTraining(int day, String title);

  /// No description provided for @homeNextUnlocksOn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libera em {date}: dia {day} — {title}'**
  String homeNextUnlocksOn(String date, int day, String title);

  /// No description provided for @homeNoProgram.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você ainda não está em um plano de treino.'**
  String get homeNoProgram;

  /// No description provided for @homeNoProgramBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha o que você quer melhorar e entre no seu plano.'**
  String get homeNoProgramBody;

  /// No description provided for @homeSessionSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'A sessão completa chega na próxima etapa. Por enquanto, este é o seu treino do dia.'**
  String get homeSessionSoon;

  /// No description provided for @homeNowTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios'**
  String get homeNowTitle;

  /// No description provided for @homeNowBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessões livres para ouvir quando quiser.'**
  String get homeNowBody;

  /// No description provided for @homeNowSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dormir'**
  String get homeNowSleep;

  /// No description provided for @homeNowRelax.
  ///
  /// In pt_BR, this message translates to:
  /// **'Relaxar'**
  String get homeNowRelax;

  /// No description provided for @homeNowBreathe.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respirar'**
  String get homeNowBreathe;

  /// No description provided for @homeNowStudy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estudar'**
  String get homeNowStudy;

  /// No description provided for @homeNowWork.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trabalhar'**
  String get homeNowWork;

  /// No description provided for @homeNowAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos'**
  String get homeNowAll;

  /// No description provided for @homeSeeAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver todos'**
  String get homeSeeAll;

  /// No description provided for @libraryAudiosTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos os áudios'**
  String get libraryAudiosTitle;

  /// No description provided for @libraryAudiosEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum áudio por aqui agora.'**
  String get libraryAudiosEmpty;

  /// No description provided for @librarySearch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar'**
  String get librarySearch;

  /// No description provided for @librarySearchHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Buscar áudios'**
  String get librarySearchHint;

  /// No description provided for @libraryExercisesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos os exercícios'**
  String get libraryExercisesTitle;

  /// No description provided for @libraryExercisesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um treino curto e comece quando quiser.'**
  String get libraryExercisesBody;

  /// No description provided for @libraryExercisesEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum exercício publicado agora.'**
  String get libraryExercisesEmpty;

  /// No description provided for @libraryMemoryMeta.
  ///
  /// In pt_BR, this message translates to:
  /// **'{words} palavras · {seconds}s para olhar'**
  String libraryMemoryMeta(int words, int seconds);

  /// No description provided for @libraryMemoryKindWords.
  ///
  /// In pt_BR, this message translates to:
  /// **'Palavras · curto prazo'**
  String get libraryMemoryKindWords;

  /// No description provided for @libraryMemoryKindIcons.
  ///
  /// In pt_BR, this message translates to:
  /// **'Figuras · visual'**
  String get libraryMemoryKindIcons;

  /// No description provided for @libraryMemoryKindOrder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência'**
  String get libraryMemoryKindOrder;

  /// No description provided for @libraryMemoryKindDelayed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segurar na mente'**
  String get libraryMemoryKindDelayed;

  /// No description provided for @libraryAttentionKindTarget.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque só no alvo'**
  String get libraryAttentionKindTarget;

  /// No description provided for @libraryAttentionKindNogo.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque em tudo, menos nisto'**
  String get libraryAttentionKindNogo;

  /// No description provided for @libraryAttentionKindChange.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque quando mudar'**
  String get libraryAttentionKindChange;

  /// No description provided for @libraryAttentionKindGrid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ache a figura diferente'**
  String get libraryAttentionKindGrid;

  /// No description provided for @libraryBreathingKindWave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Círculo guiado'**
  String get libraryBreathingKindWave;

  /// No description provided for @libraryBreathingKindBox.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caixa 4-4-4-4'**
  String get libraryBreathingKindBox;

  /// No description provided for @libraryBreathingKindLadder.
  ///
  /// In pt_BR, this message translates to:
  /// **'4-7-8'**
  String get libraryBreathingKindLadder;

  /// No description provided for @libraryBreathingKindTide.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maré · expirar longo'**
  String get libraryBreathingKindTide;

  /// No description provided for @libraryBreathingRoom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sala de respiração'**
  String get libraryBreathingRoom;

  /// No description provided for @libraryBreathingRoomBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios e áudios numa tela só.'**
  String get libraryBreathingRoomBody;

  /// No description provided for @breathingHubTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get breathingHubTitle;

  /// No description provided for @breathingHubBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios guiados e áudios para respirar no seu ritmo.'**
  String get breathingHubBody;

  /// No description provided for @breathingHubExercises.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios'**
  String get breathingHubExercises;

  /// No description provided for @breathingHubAudios.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios'**
  String get breathingHubAudios;

  /// No description provided for @breathingHubEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nada de respiração por aqui agora.'**
  String get breathingHubEmpty;

  /// No description provided for @homeExercisesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios'**
  String get homeExercisesTitle;

  /// No description provided for @homeExercisesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prática diária, atenção, memória e respiração.'**
  String get homeExercisesBody;

  /// No description provided for @homeExerciseBreathing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração'**
  String get homeExerciseBreathing;

  /// No description provided for @homeExerciseAttention.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção'**
  String get homeExerciseAttention;

  /// No description provided for @homeExerciseMemory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória'**
  String get homeExerciseMemory;

  /// No description provided for @dailyHubTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prática diária'**
  String get dailyHubTitle;

  /// No description provided for @dailyHubBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dez treinos curtos. A rotina de 15 minutos monta o dia por você.'**
  String get dailyHubBody;

  /// No description provided for @dailyHubList.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um treino'**
  String get dailyHubList;

  /// No description provided for @dailyStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar'**
  String get dailyStart;

  /// No description provided for @dailyFinish.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluir'**
  String get dailyFinish;

  /// No description provided for @dailyNeedWrite.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva pelo menos algumas respostas. Sem isso, o treino não conta.'**
  String get dailyNeedWrite;

  /// No description provided for @dailyNeedCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Faça algumas contas antes de concluir.'**
  String get dailyNeedCount;

  /// No description provided for @dailyAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar'**
  String get dailyAdd;

  /// No description provided for @dailyMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{minutes} min'**
  String dailyMinutes(int minutes);

  /// No description provided for @dailyTimerLeft.
  ///
  /// In pt_BR, this message translates to:
  /// **'{seconds} s'**
  String dailyTimerLeft(int seconds);

  /// No description provided for @dailyCircuitTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rotina de 15 minutos'**
  String get dailyCircuitTitle;

  /// No description provided for @dailyCircuitBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cinco minutos de concentração, cinco de memória, cinco de criatividade. Se a mente estiver saturada, inverte: sentidos, organização e silêncio.'**
  String get dailyCircuitBody;

  /// No description provided for @dailyCircuitFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje: treinar a mente.'**
  String get dailyCircuitFocus;

  /// No description provided for @dailyCircuitSaturated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje: recuperar espaço.'**
  String get dailyCircuitSaturated;

  /// No description provided for @dailyCircuitCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar os 15 minutos'**
  String get dailyCircuitCta;

  /// No description provided for @dailyRestToggle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente saturada hoje'**
  String get dailyRestToggle;

  /// No description provided for @dailyModeTrain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinar'**
  String get dailyModeTrain;

  /// No description provided for @dailyModeRest.
  ///
  /// In pt_BR, this message translates to:
  /// **'Descansar'**
  String get dailyModeRest;

  /// No description provided for @dailyReady.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já olhei'**
  String get dailyReady;

  /// No description provided for @dailySkipThis.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pular esta'**
  String get dailySkipThis;

  /// No description provided for @dailyLeaveTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da rotina?'**
  String get dailyLeaveTitle;

  /// No description provided for @dailyLeaveBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'O passo atual não será guardado.'**
  String get dailyLeaveBody;

  /// No description provided for @dailyLeaveConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get dailyLeaveConfirm;

  /// No description provided for @dailyDoneToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feito hoje'**
  String get dailyDoneToday;

  /// No description provided for @dailyHomeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'15 minutos'**
  String get dailyHomeTitle;

  /// No description provided for @dailyHomeCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rotina de hoje'**
  String get dailyHomeCta;

  /// No description provided for @dailyFamilyFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concentração'**
  String get dailyFamilyFocus;

  /// No description provided for @dailyFamilyMemory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória'**
  String get dailyFamilyMemory;

  /// No description provided for @dailyFamilyPresence.
  ///
  /// In pt_BR, this message translates to:
  /// **'Presença'**
  String get dailyFamilyPresence;

  /// No description provided for @dailyFamilyCreate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criatividade'**
  String get dailyFamilyCreate;

  /// No description provided for @dailyCircuitStep.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} de {total}'**
  String dailyCircuitStep(int current, int total);

  /// No description provided for @dailyCircuitDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Rotina concluída. Isso já é o treino.'**
  String get dailyCircuitDone;

  /// No description provided for @dailyMetaObserve.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 min · atenção'**
  String get dailyMetaObserve;

  /// No description provided for @dailyMetaReverse.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória de trabalho'**
  String get dailyMetaReverse;

  /// No description provided for @dailyMetaCategories.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 min · raciocínio'**
  String get dailyMetaCategories;

  /// No description provided for @dailyMetaRetell.
  ///
  /// In pt_BR, this message translates to:
  /// **'Compreensão'**
  String get dailyMetaRetell;

  /// No description provided for @dailyMetaCountdown.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco'**
  String get dailyMetaCountdown;

  /// No description provided for @dailyMetaSenses.
  ///
  /// In pt_BR, this message translates to:
  /// **'Presente'**
  String get dailyMetaSenses;

  /// No description provided for @dailyMetaTask.
  ///
  /// In pt_BR, this message translates to:
  /// **'10 min · uma coisa'**
  String get dailyMetaTask;

  /// No description provided for @dailyMetaUses.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criatividade'**
  String get dailyMetaUses;

  /// No description provided for @dailyMetaSort.
  ///
  /// In pt_BR, this message translates to:
  /// **'Organizar a cabeça'**
  String get dailyMetaSort;

  /// No description provided for @dailyMetaSilence.
  ///
  /// In pt_BR, this message translates to:
  /// **'5 min · descanso'**
  String get dailyMetaSilence;

  /// No description provided for @dailyObserveTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observação consciente'**
  String get dailyObserveTitle;

  /// No description provided for @dailyObserveBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um objeto e observe. Cor, formato, textura, detalhes. Só isso.'**
  String get dailyObserveBody;

  /// No description provided for @dailyObservePick.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você vai observar?'**
  String get dailyObservePick;

  /// No description provided for @dailyObserveLook.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olhe para {object}.'**
  String dailyObserveLook(String object);

  /// No description provided for @dailyReverseTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória reversa'**
  String get dailyReverseTitle;

  /// No description provided for @dailyReverseBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cinco palavras, números ou objetos. Depois, de trás para frente.'**
  String get dailyReverseBody;

  /// No description provided for @dailyReverseLook.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olhe. Depois some.'**
  String get dailyReverseLook;

  /// No description provided for @dailyReverseAsk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque de trás para frente.'**
  String get dailyReverseAsk;

  /// No description provided for @dailyReverseStep.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} de {total}'**
  String dailyReverseStep(int current, int total);

  /// No description provided for @dailyReverseHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo número'**
  String get dailyReverseHint;

  /// No description provided for @dailyReverseWrong.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não era esse. Tente o último que lembra.'**
  String get dailyReverseWrong;

  /// No description provided for @dailyCategoriesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Desafio das categorias'**
  String get dailyCategoriesTitle;

  /// No description provided for @dailyCategoriesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma letra. Cinco animais, comidas, profissões e lugares.'**
  String get dailyCategoriesBody;

  /// No description provided for @dailyCategoriesLetter.
  ///
  /// In pt_BR, this message translates to:
  /// **'Letra {letter}'**
  String dailyCategoriesLetter(String letter);

  /// No description provided for @dailyRetellTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recontar de memória'**
  String get dailyRetellTitle;

  /// No description provided for @dailyRetellBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leia um texto curto. Depois explique com suas palavras.'**
  String get dailyRetellBody;

  /// No description provided for @dailyRetellRead.
  ///
  /// In pt_BR, this message translates to:
  /// **'Leia com calma. Depois some o texto.'**
  String get dailyRetellRead;

  /// No description provided for @dailyRetellHide.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já li'**
  String get dailyRetellHide;

  /// No description provided for @dailyRetellWrite.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agora conte com suas palavras.'**
  String get dailyRetellWrite;

  /// No description provided for @dailyRetellHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que ficou'**
  String get dailyRetellHint;

  /// No description provided for @dailyCountdownTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Contagem consciente'**
  String get dailyCountdownTitle;

  /// No description provided for @dailyCountdownBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'De 100 a 0, de 3 em 3. Se perder, volte ao último que lembra.'**
  String get dailyCountdownBody;

  /// No description provided for @dailyCountdownAsk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qual é o próximo, menos 3?'**
  String get dailyCountdownAsk;

  /// No description provided for @dailyCountdownMinus.
  ///
  /// In pt_BR, this message translates to:
  /// **'menos 3'**
  String get dailyCountdownMinus;

  /// No description provided for @dailyCountdownHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo'**
  String get dailyCountdownHint;

  /// No description provided for @dailyCountdownWrong.
  ///
  /// In pt_BR, this message translates to:
  /// **'Volte ao último que lembra.'**
  String get dailyCountdownWrong;

  /// No description provided for @dailySensesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercício dos sentidos'**
  String get dailySensesTitle;

  /// No description provided for @dailySensesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cinco coisas que vê, quatro que toca, três sons, dois cheiros, uma no corpo.'**
  String get dailySensesBody;

  /// No description provided for @dailySensesHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Olhe em volta. Não precisa ser especial.'**
  String get dailySensesHint;

  /// No description provided for @dailySensesSee.
  ///
  /// In pt_BR, this message translates to:
  /// **'5 coisas que você vê'**
  String get dailySensesSee;

  /// No description provided for @dailySensesTouch.
  ///
  /// In pt_BR, this message translates to:
  /// **'4 que consegue tocar'**
  String get dailySensesTouch;

  /// No description provided for @dailySensesHear.
  ///
  /// In pt_BR, this message translates to:
  /// **'3 sons'**
  String get dailySensesHear;

  /// No description provided for @dailySensesSmell.
  ///
  /// In pt_BR, this message translates to:
  /// **'2 cheiros'**
  String get dailySensesSmell;

  /// No description provided for @dailySensesFeel.
  ///
  /// In pt_BR, this message translates to:
  /// **'1 coisa no corpo'**
  String get dailySensesFeel;

  /// No description provided for @dailyTaskTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma tarefa por vez'**
  String get dailyTaskTitle;

  /// No description provided for @dailyTaskBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dez minutos. Uma atividade. Sem celular e sem trocar.'**
  String get dailyTaskBody;

  /// No description provided for @dailyTaskPick.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que você vai fazer agora?'**
  String get dailyTaskPick;

  /// No description provided for @dailyTaskDoing.
  ///
  /// In pt_BR, this message translates to:
  /// **'{task}. Só isto.'**
  String dailyTaskDoing(String task);

  /// No description provided for @dailyTaskPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Deixe o celular de lado. O timer continua aqui.'**
  String get dailyTaskPhone;

  /// No description provided for @dailyUsesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usos de um objeto'**
  String get dailyUsesTitle;

  /// No description provided for @dailyUsesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um objeto comum. Dez usos diferentes.'**
  String get dailyUsesBody;

  /// No description provided for @dailyUsesObject.
  ///
  /// In pt_BR, this message translates to:
  /// **'10 usos para {object}'**
  String dailyUsesObject(String object);

  /// No description provided for @dailySortTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Diário mental'**
  String get dailySortTitle;

  /// No description provided for @dailySortBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva o que está na cabeça. Depois separe: resolver, depois, ou não depende de mim.'**
  String get dailySortBody;

  /// No description provided for @dailySortDump.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tudo que está passando. Sem organizar.'**
  String get dailySortDump;

  /// No description provided for @dailySortHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma coisa por linha'**
  String get dailySortHint;

  /// No description provided for @dailySortClassify.
  ///
  /// In pt_BR, this message translates to:
  /// **'Classificar'**
  String get dailySortClassify;

  /// No description provided for @dailySortPick.
  ///
  /// In pt_BR, this message translates to:
  /// **'Onde cada uma fica?'**
  String get dailySortPick;

  /// No description provided for @dailySortResolve.
  ///
  /// In pt_BR, this message translates to:
  /// **'Resolver'**
  String get dailySortResolve;

  /// No description provided for @dailySortLater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Depois'**
  String get dailySortLater;

  /// No description provided for @dailySortNotMine.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não depende de mim'**
  String get dailySortNotMine;

  /// No description provided for @dailySilenceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Silêncio intencional'**
  String get dailySilenceTitle;

  /// No description provided for @dailySilenceBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cinco minutos sem aprender, assistir ou consumir. Só a respiração e os pensamentos passando.'**
  String get dailySilenceBody;

  /// No description provided for @dailySilenceHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não tente resolver nada. Observe o ar.'**
  String get dailySilenceHint;

  /// No description provided for @homeExploreTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'As seis salas'**
  String get homeExploreTitle;

  /// No description provided for @homeExploreBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cada ponto tem o próprio programa. O treino de hoje continua no card de cima.'**
  String get homeExploreBody;

  /// No description provided for @homeExploreAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver planos'**
  String get homeExploreAll;

  /// No description provided for @homeChoosePlan.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher meu plano'**
  String get homeChoosePlan;

  /// No description provided for @homeToolsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ferramentas'**
  String get homeToolsTitle;

  /// No description provided for @homeToolsBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in, mente cheia, caderno e o encerramento da noite.'**
  String get homeToolsBody;

  /// No description provided for @homeToolPomodoro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pomodoro'**
  String get homeToolPomodoro;

  /// No description provided for @homeToolCheckin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in'**
  String get homeToolCheckin;

  /// No description provided for @homeToolClearMind.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente cheia'**
  String get homeToolClearMind;

  /// No description provided for @homeToolJournal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caderno'**
  String get homeToolJournal;

  /// No description provided for @homeToolThought.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estacionar'**
  String get homeToolThought;

  /// No description provided for @homeToolSilentRoom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sala'**
  String get homeToolSilentRoom;

  /// No description provided for @homeToolDayClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Noite'**
  String get homeToolDayClose;

  /// No description provided for @homeTagline.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respire. Foque. Evolua.'**
  String get homeTagline;

  /// No description provided for @homeTodayEyebrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de hoje'**
  String get homeTodayEyebrow;

  /// No description provided for @homeProgressSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu progresso'**
  String get homeProgressSection;

  /// No description provided for @homeKeepExploring.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continue explorando'**
  String get homeKeepExploring;

  /// No description provided for @homeAreaProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu progresso por área'**
  String get homeAreaProgress;

  /// No description provided for @homeNextTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo treino'**
  String get homeNextTraining;

  /// No description provided for @homeMyTools.
  ///
  /// In pt_BR, this message translates to:
  /// **'Minhas ferramentas'**
  String get homeMyTools;

  /// No description provided for @homeNumbersTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu momento em números'**
  String get homeNumbersTitle;

  /// No description provided for @homeQuote.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pequenas escolhas diárias constroem uma mente mais forte e tranquila.'**
  String get homeQuote;

  /// No description provided for @homeStatDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dias'**
  String get homeStatDays;

  /// No description provided for @homeStatTrained.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinados'**
  String get homeStatTrained;

  /// No description provided for @homeNowFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco'**
  String get homeNowFocus;

  /// No description provided for @homeNowMemory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória'**
  String get homeNowMemory;

  /// No description provided for @homeNowMindfulness.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção plena'**
  String get homeNowMindfulness;

  /// No description provided for @homeCurrentStreak.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência atual'**
  String get homeCurrentStreak;

  /// No description provided for @menuOpen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Menu da academia'**
  String get menuOpen;

  /// No description provided for @menuClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar menu'**
  String get menuClose;

  /// No description provided for @menuTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Academia Mental'**
  String get menuTitle;

  /// No description provided for @menuSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todas as salas, num só lugar.'**
  String get menuSubtitle;

  /// No description provided for @menuSectionTrain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino'**
  String get menuSectionTrain;

  /// No description provided for @menuSectionAudio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios'**
  String get menuSectionAudio;

  /// No description provided for @menuSectionExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercícios'**
  String get menuSectionExercise;

  /// No description provided for @menuSectionTools.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ferramentas'**
  String get menuSectionTools;

  /// No description provided for @menuSectionJourney.
  ///
  /// In pt_BR, this message translates to:
  /// **'Jornada'**
  String get menuSectionJourney;

  /// No description provided for @menuToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de hoje'**
  String get menuToday;

  /// No description provided for @menuTodayHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua sessão do dia'**
  String get menuTodayHint;

  /// No description provided for @menuPlans.
  ///
  /// In pt_BR, this message translates to:
  /// **'Planos'**
  String get menuPlans;

  /// No description provided for @menuPlansHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar ou conhecer outro plano'**
  String get menuPlansHint;

  /// No description provided for @menuMyPlan.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meu plano'**
  String get menuMyPlan;

  /// No description provided for @menuMyPlanHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessão de hoje, dias e ritmo'**
  String get menuMyPlanHint;

  /// No description provided for @menuExercisesHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção, memória e respiração'**
  String get menuExercisesHint;

  /// No description provided for @menuRoomHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um programa completo'**
  String get menuRoomHint;

  /// No description provided for @menuAudios.
  ///
  /// In pt_BR, this message translates to:
  /// **'Biblioteca'**
  String get menuAudios;

  /// No description provided for @menuAudiosHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouça no seu ritmo'**
  String get menuAudiosHint;

  /// No description provided for @menuSleepHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sons para a noite'**
  String get menuSleepHint;

  /// No description provided for @menuRelaxHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Soltar o corpo e a mente'**
  String get menuRelaxHint;

  /// No description provided for @menuFocusAudio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios de foco'**
  String get menuFocusAudio;

  /// No description provided for @menuFocusAudioHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trilha para concentração'**
  String get menuFocusAudioHint;

  /// No description provided for @menuAttentionHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de alvo'**
  String get menuAttentionHint;

  /// No description provided for @menuMemoryHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Palavras e presença'**
  String get menuMemoryHint;

  /// No description provided for @menuBreathingHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ritmo guiado'**
  String get menuBreathingHint;

  /// No description provided for @menuDailyHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dez treinos curtos e 15 minutos'**
  String get menuDailyHint;

  /// No description provided for @menuPomodoroHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Blocos de atenção'**
  String get menuPomodoroHint;

  /// No description provided for @menuCheckinHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor e energia'**
  String get menuCheckinHint;

  /// No description provided for @menuClearMindHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma coisa só para hoje'**
  String get menuClearMindHint;

  /// No description provided for @menuJournalHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Três linhas, só suas'**
  String get menuJournalHint;

  /// No description provided for @menuThoughtHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreve, guarda, segue'**
  String get menuThoughtHint;

  /// No description provided for @menuSilentRoomHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um bloco de presença'**
  String get menuSilentRoomHint;

  /// No description provided for @menuDayCloseHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dois minutos para fechar'**
  String get menuDayCloseHint;

  /// No description provided for @menuProgressHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência, clima e tempo'**
  String get menuProgressHint;

  /// No description provided for @menuHistoryHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tudo que você fez'**
  String get menuHistoryHint;

  /// No description provided for @menuRankingHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quem está treinando'**
  String get menuRankingHint;

  /// No description provided for @menuProfileHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta e preferências'**
  String get menuProfileHint;

  /// No description provided for @catalogTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Catálogo'**
  String get catalogTitle;

  /// No description provided for @catalogEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum programa publicado agora.'**
  String get catalogEmpty;

  /// No description provided for @catalogDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} dias'**
  String catalogDays(int count);

  /// No description provided for @catalogDayItem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia {day} · {title}'**
  String catalogDayItem(int day, String title);

  /// No description provided for @catalogBrowseHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um plano por vez. Se você trocar, o progresso e o relatório do plano atual são zerados.'**
  String get catalogBrowseHint;

  /// No description provided for @catalogFreeDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} dias livres'**
  String catalogFreeDays(int count);

  /// No description provided for @catalogPlanDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os dias do plano'**
  String get catalogPlanDays;

  /// No description provided for @catalogEnroll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar este plano'**
  String get catalogEnroll;

  /// No description provided for @catalogEnrollCurrent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este é o seu plano'**
  String get catalogEnrollCurrent;

  /// No description provided for @catalogSwitch.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar para este plano'**
  String get catalogSwitch;

  /// No description provided for @catalogSwitchTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar de plano?'**
  String get catalogSwitchTitle;

  /// No description provided for @catalogSwitchBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você só pode seguir um plano por vez. O progresso e o relatório do plano atual serão zerados.'**
  String get catalogSwitchBody;

  /// No description provided for @catalogSwitchConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Trocar mesmo assim'**
  String get catalogSwitchConfirm;

  /// No description provided for @momentListen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir'**
  String get momentListen;

  /// No description provided for @prepareStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estou pronto'**
  String get prepareStart;

  /// No description provided for @sessionElapsed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo {time}'**
  String sessionElapsed(String time);

  /// No description provided for @themeSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema'**
  String get themeSection;

  /// No description provided for @themeSectionHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O tema da noite deixa a respiração e a sessão com fundo escuro.'**
  String get themeSectionHint;

  /// No description provided for @themeDark.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tema da noite'**
  String get themeDark;

  /// No description provided for @themeDarkHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fundo preto na sessão e na respiração.'**
  String get themeDarkHint;

  /// No description provided for @languageSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Idioma'**
  String get languageSection;

  /// No description provided for @languageSectionHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha o idioma do aplicativo.'**
  String get languageSectionHint;

  /// No description provided for @languagePortuguese.
  ///
  /// In pt_BR, this message translates to:
  /// **'Português'**
  String get languagePortuguese;

  /// No description provided for @languageEnglish.
  ///
  /// In pt_BR, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @homeLayoutSection.
  ///
  /// In pt_BR, this message translates to:
  /// **'Layout da home'**
  String get homeLayoutSection;

  /// No description provided for @homeLayoutSectionHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha como a tela inicial aparece.'**
  String get homeLayoutSectionHint;

  /// No description provided for @homeLayoutToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino de hoje'**
  String get homeLayoutToday;

  /// No description provided for @homeLayoutTodayHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Imagem do dia e o treino em destaque.'**
  String get homeLayoutTodayHint;

  /// No description provided for @homeLayoutTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco no treino'**
  String get homeLayoutTraining;

  /// No description provided for @homeLayoutTrainingHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Card grande para começar agora.'**
  String get homeLayoutTrainingHint;

  /// No description provided for @homeLayoutProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco no progresso'**
  String get homeLayoutProgress;

  /// No description provided for @homeLayoutProgressHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência, áreas e o próximo treino.'**
  String get homeLayoutProgressHint;

  /// No description provided for @playerLoadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível tocar o áudio. Verifique a conexão e tente de novo.'**
  String get playerLoadError;

  /// No description provided for @playerReplay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir de novo'**
  String get playerReplay;

  /// No description provided for @paywallTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continue com o Premium'**
  String get paywallTitle;

  /// No description provided for @paywallBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios, exercícios extras e ferramentas avançadas fazem parte do Premium. Check-in, caderno, Mente cheia e os primeiros dias do plano continuam livres.'**
  String get paywallBody;

  /// No description provided for @paywallFreeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Livre agora'**
  String get paywallFreeLabel;

  /// No description provided for @paywallFreeList.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in, caderno, Mente cheia e os primeiros dias do seu plano.'**
  String get paywallFreeList;

  /// No description provided for @paywallPremiumLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'No Premium'**
  String get paywallPremiumLabel;

  /// No description provided for @paywallPremiumList.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudios, prática diária, exercícios, pomodoro, sala silenciosa, pensamentos e o restante do plano.'**
  String get paywallPremiumList;

  /// No description provided for @paywallCtaSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinatura em breve'**
  String get paywallCtaSoon;

  /// No description provided for @paywallCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinar Premium'**
  String get paywallCta;

  /// No description provided for @paywallCtaRenew.
  ///
  /// In pt_BR, this message translates to:
  /// **'Renovar Premium'**
  String get paywallCtaRenew;

  /// No description provided for @paywallCtaPrice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinar Premium · {price}/{period}'**
  String paywallCtaPrice(String price, String period);

  /// No description provided for @paywallPriceHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'{price} a cada {period}, via Mercado Pago.'**
  String paywallPriceHint(String price, String period);

  /// No description provided for @paywallWaiting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento aberto no navegador. Quando voltar, o app confirma o status.'**
  String get paywallWaiting;

  /// No description provided for @paywallOpenError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir o checkout. Tente de novo.'**
  String get paywallOpenError;

  /// No description provided for @billingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinatura'**
  String get billingTitle;

  /// No description provided for @billingHistoryTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico de pagamentos'**
  String get billingHistoryTitle;

  /// No description provided for @billingHistoryEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando houver uma cobrança, ela aparece aqui.'**
  String get billingHistoryEmpty;

  /// No description provided for @billingPeriodMonth.
  ///
  /// In pt_BR, this message translates to:
  /// **'mês'**
  String get billingPeriodMonth;

  /// No description provided for @billingPeriodDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} dias'**
  String billingPeriodDays(int count);

  /// No description provided for @billingValidUntil.
  ///
  /// In pt_BR, this message translates to:
  /// **'Válido até {date}'**
  String billingValidUntil(String date);

  /// No description provided for @billingStatusActive.
  ///
  /// In pt_BR, this message translates to:
  /// **'Premium ativo'**
  String get billingStatusActive;

  /// No description provided for @billingStatusPending.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando confirmação'**
  String get billingStatusPending;

  /// No description provided for @billingStatusFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento não aprovado'**
  String get billingStatusFailed;

  /// No description provided for @billingStatusExpired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Assinatura encerrada'**
  String get billingStatusExpired;

  /// No description provided for @billingStatusNone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem assinatura'**
  String get billingStatusNone;

  /// No description provided for @billingPaymentApproved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprovado'**
  String get billingPaymentApproved;

  /// No description provided for @billingPaymentPending.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pendente'**
  String get billingPaymentPending;

  /// No description provided for @billingPaymentFailed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não aprovado'**
  String get billingPaymentFailed;

  /// No description provided for @billingPaymentRefunded.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estornado'**
  String get billingPaymentRefunded;

  /// No description provided for @profilePlanFree.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano gratuito'**
  String get profilePlanFree;

  /// No description provided for @profilePlanPremium.
  ///
  /// In pt_BR, this message translates to:
  /// **'Premium'**
  String get profilePlanPremium;

  /// No description provided for @profileTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil'**
  String get profileTitle;

  /// No description provided for @profileAccountTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta'**
  String get profileAccountTitle;

  /// No description provided for @profileLogoutConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair da conta neste aparelho?'**
  String get profileLogoutConfirm;

  /// No description provided for @profilePlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajustes de conta, lembretes e exclusão chegam a seguir.'**
  String get profilePlaceholder;

  /// No description provided for @progressTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Progresso'**
  String get progressTitle;

  /// No description provided for @progressPlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu histórico, XP e o relatório do dia 7 aparecem aqui na próxima etapa.'**
  String get progressPlaceholder;

  /// No description provided for @profileDeleteAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir conta'**
  String get profileDeleteAccount;

  /// No description provided for @profileDeleteConfirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir sua conta?'**
  String get profileDeleteConfirm;

  /// No description provided for @profileDeleteConfirmBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua conta deixa de funcionar neste aparelho. Esta ação não pode ser desfeita por aqui.'**
  String get profileDeleteConfirmBody;

  /// No description provided for @profileTerms.
  ///
  /// In pt_BR, this message translates to:
  /// **'Termos de uso'**
  String get profileTerms;

  /// No description provided for @profilePrivacy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Política de privacidade'**
  String get profilePrivacy;

  /// No description provided for @profileLegalPlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'O texto jurídico ainda será publicado. Até lá, este é só um atalho reservado.'**
  String get profileLegalPlaceholder;

  /// No description provided for @profileSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Perfil atualizado.'**
  String get profileSaved;

  /// No description provided for @profileEditName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Alterar nome'**
  String get profileEditName;

  /// No description provided for @profileNameHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como você quer aparecer no ranking.'**
  String get profileNameHint;

  /// No description provided for @profileAvatarHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque na foto para escolher uma imagem da galeria ou um símbolo calmo. Ela aparece no ranking.'**
  String get profileAvatarHint;

  /// No description provided for @profilePhotoGallery.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolher da galeria'**
  String get profilePhotoGallery;

  /// No description provided for @profileEmojiChoose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usar um símbolo'**
  String get profileEmojiChoose;

  /// No description provided for @profileEmojiTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um símbolo para o ranking'**
  String get profileEmojiTitle;

  /// No description provided for @profileEmojiBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem selfie? Escolha um ícone tranquilo da academia mental.'**
  String get profileEmojiBody;

  /// No description provided for @profilePhotoRemove.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover foto'**
  String get profilePhotoRemove;

  /// No description provided for @profileLegalOpenError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível abrir a página agora.'**
  String get profileLegalOpenError;

  /// No description provided for @profileMessageTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Falar com o time'**
  String get profileMessageTitle;

  /// No description provided for @profileMessageTileBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sugestão, ideia nova ou um obrigado.'**
  String get profileMessageTileBody;

  /// No description provided for @profileMessageBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conte o que sentiu falta, uma ideia nova ou um agradecimento. Cada mensagem vira um chamado para a gente ler.'**
  String get profileMessageBody;

  /// No description provided for @profileMessageTypeSuggestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Melhoria'**
  String get profileMessageTypeSuggestion;

  /// No description provided for @profileMessageTypeFeature.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova função'**
  String get profileMessageTypeFeature;

  /// No description provided for @profileMessageTypeThanks.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agradecimento'**
  String get profileMessageTypeThanks;

  /// No description provided for @profileMessageField.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua mensagem'**
  String get profileMessageField;

  /// No description provided for @profileMessageHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pode ser simples. O que ajudaria no seu treino?'**
  String get profileMessageHint;

  /// No description provided for @profileMessageTooShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreva um pouco mais para a gente entender.'**
  String get profileMessageTooShort;

  /// No description provided for @profileMessageSent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mensagem enviada. Obrigado por escrever.'**
  String get profileMessageSent;

  /// No description provided for @progressXp.
  ///
  /// In pt_BR, this message translates to:
  /// **'XP'**
  String get progressXp;

  /// No description provided for @progressLevel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nível'**
  String get progressLevel;

  /// No description provided for @progressSessions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessões'**
  String get progressSessions;

  /// No description provided for @progressJourneyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua jornada'**
  String get progressJourneyTitle;

  /// No description provided for @progressTimeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treinos do plano e áudios livres, somados.'**
  String get progressTimeHint;

  /// No description provided for @progressTimeUnderMinute.
  ///
  /// In pt_BR, this message translates to:
  /// **'Menos de 1 min'**
  String get progressTimeUnderMinute;

  /// No description provided for @progressTimeOnlyMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{minutes} min'**
  String progressTimeOnlyMinutes(int minutes);

  /// No description provided for @progressTimeHours.
  ///
  /// In pt_BR, this message translates to:
  /// **'{hours} h {minutes} min'**
  String progressTimeHours(int hours, int minutes);

  /// No description provided for @progressTimeCompactMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{minutes}min'**
  String progressTimeCompactMinutes(int minutes);

  /// No description provided for @progressTimeCompactHours.
  ///
  /// In pt_BR, this message translates to:
  /// **'{hours}h {minutes}min'**
  String progressTimeCompactHours(int hours, int minutes);

  /// No description provided for @progressEmptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua jornada está começando'**
  String get progressEmptyTitle;

  /// No description provided for @progressEmptyBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Complete seu primeiro treino para dar o primeiro passo. Leva só alguns minutos.'**
  String get progressEmptyBody;

  /// No description provided for @progressEmptyCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar meu primeiro treino'**
  String get progressEmptyCta;

  /// No description provided for @progressStreakTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua sequência atual'**
  String get progressStreakTitle;

  /// No description provided for @progressStreakDays.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, =1{1 dia consecutivo} other{{count} dias consecutivos}}'**
  String progressStreakDays(int count);

  /// No description provided for @progressHeroStats.
  ///
  /// In pt_BR, this message translates to:
  /// **'{time} treinados · {count} sessões'**
  String progressHeroStats(String time, int count);

  /// No description provided for @progressMoreTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais'**
  String get progressMoreTitle;

  /// No description provided for @progressStatTrained.
  ///
  /// In pt_BR, this message translates to:
  /// **'treinados'**
  String get progressStatTrained;

  /// No description provided for @progressProgramTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu programa'**
  String get progressProgramTitle;

  /// No description provided for @progressProgramDay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia {current} de {total}'**
  String progressProgramDay(int current, int total);

  /// No description provided for @progressProgramDaysDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'{done} de {total} dias concluídos'**
  String progressProgramDaysDone(int done, int total);

  /// No description provided for @progressContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar treino'**
  String get progressContinue;

  /// No description provided for @progressWeekRhythmTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu ritmo'**
  String get progressWeekRhythmTitle;

  /// No description provided for @progressWeekDaysTrained.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, =1{Você treinou 1 dia esta semana} other{Você treinou {count} dias esta semana}}'**
  String progressWeekDaysTrained(int count);

  /// No description provided for @progressWeekDeltaUp.
  ///
  /// In pt_BR, this message translates to:
  /// **'+{time} que na semana passada'**
  String progressWeekDeltaUp(String time);

  /// No description provided for @progressWeekDeltaDown.
  ///
  /// In pt_BR, this message translates to:
  /// **'{time} a menos que na semana passada'**
  String progressWeekDeltaDown(String time);

  /// No description provided for @progressMilestoneTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próximo marco'**
  String get progressMilestoneTitle;

  /// No description provided for @progressMilestoneXp.
  ///
  /// In pt_BR, this message translates to:
  /// **'{xp} XP para o próximo nível'**
  String progressMilestoneXp(int xp);

  /// No description provided for @progressMilestoneXpBar.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} / {target} XP'**
  String progressMilestoneXpBar(int current, int target);

  /// No description provided for @progressMilestoneStreak.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, =1{1 dia consecutivo} other{{count} dias consecutivos}}'**
  String progressMilestoneStreak(int count);

  /// No description provided for @progressMilestoneStreakRemain.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, =1{Falta 1 dia} other{Faltam {count} dias}}'**
  String progressMilestoneStreakRemain(int count);

  /// No description provided for @progressMilestoneMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{minutes} minutos treinados'**
  String progressMilestoneMinutes(int minutes);

  /// No description provided for @progressMilestoneMinutesBar.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} / {target} min'**
  String progressMilestoneMinutesBar(int current, int target);

  /// No description provided for @progressRecentTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atividade recente'**
  String get progressRecentTitle;

  /// No description provided for @progressSeeHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver histórico'**
  String get progressSeeHistory;

  /// No description provided for @rankingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ranking mundial'**
  String get rankingTitle;

  /// No description provided for @rankingCardTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ranking mundial'**
  String get rankingCardTitle;

  /// No description provided for @rankingCardBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Veja quem está treinando pelo mundo. A entrada é opcional.'**
  String get rankingCardBody;

  /// No description provided for @rankingPeriodAll.
  ///
  /// In pt_BR, this message translates to:
  /// **'Geral'**
  String get rankingPeriodAll;

  /// No description provided for @rankingPeriodWeekly.
  ///
  /// In pt_BR, this message translates to:
  /// **'Semana'**
  String get rankingPeriodWeekly;

  /// No description provided for @rankingOptInTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aparecer no ranking'**
  String get rankingOptInTitle;

  /// No description provided for @rankingOptInBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu nome, foto ou símbolo e o XP ficam visíveis para outras pessoas do app. Você pode sair quando quiser.'**
  String get rankingOptInBody;

  /// No description provided for @rankingOptInCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar no ranking'**
  String get rankingOptInCta;

  /// No description provided for @rankingOptOut.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair do ranking'**
  String get rankingOptOut;

  /// No description provided for @rankingEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ainda não há pessoas no ranking. Você pode ser a primeira.'**
  String get rankingEmpty;

  /// No description provided for @rankingPlayers.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count, plural, =0{Ninguém no ranking ainda} =1{1 pessoa no ranking} other{{count} pessoas no ranking}}'**
  String rankingPlayers(int count);

  /// No description provided for @rankingYourPlace.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua posição'**
  String get rankingYourPlace;

  /// No description provided for @rankingUnranked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fora do ranking'**
  String get rankingUnranked;

  /// No description provided for @rankingXp.
  ///
  /// In pt_BR, this message translates to:
  /// **'{xp} XP'**
  String rankingXp(int xp);

  /// No description provided for @rankingRank.
  ///
  /// In pt_BR, this message translates to:
  /// **'#{rank}'**
  String rankingRank(int rank);

  /// No description provided for @rankingYou.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você'**
  String get rankingYou;

  /// No description provided for @profileRanking.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aparecer no ranking'**
  String get profileRanking;

  /// No description provided for @profileRankingHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome, foto ou símbolo e XP visíveis para outras pessoas.'**
  String get profileRankingHint;

  /// No description provided for @progressLevelName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nível atual: {name}'**
  String progressLevelName(String name);

  /// No description provided for @progressXpCardBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vem dos treinos. Toque para entender.'**
  String get progressXpCardBody;

  /// No description provided for @progressChapterTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Capítulo atual'**
  String get progressChapterTitle;

  /// No description provided for @progressPathTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O caminho'**
  String get progressPathTitle;

  /// No description provided for @progressJourneyStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começo'**
  String get progressJourneyStart;

  /// No description provided for @progressJourneyWarm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Passos'**
  String get progressJourneyWarm;

  /// No description provided for @progressJourneyRhythm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ritmo'**
  String get progressJourneyRhythm;

  /// No description provided for @progressJourneyWalk.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caminho'**
  String get progressJourneyWalk;

  /// No description provided for @progressJourneyDeep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Presença'**
  String get progressJourneyDeep;

  /// No description provided for @progressJourneyConstancy.
  ///
  /// In pt_BR, this message translates to:
  /// **'Constância'**
  String get progressJourneyConstancy;

  /// No description provided for @progressJourneyCopy0.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você está no começo. Um minuto já é presença.'**
  String get progressJourneyCopy0;

  /// No description provided for @progressJourneyCopy1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Os primeiros minutos já abrem o caminho.'**
  String get progressJourneyCopy1;

  /// No description provided for @progressJourneyCopy2.
  ///
  /// In pt_BR, this message translates to:
  /// **'O ritmo começa a aparecer. Continue sem pressa.'**
  String get progressJourneyCopy2;

  /// No description provided for @progressJourneyCopy3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sua jornada já tem corpo. Isso é treino de verdade.'**
  String get progressJourneyCopy3;

  /// No description provided for @progressStreakHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'dias em movimento'**
  String get progressStreakHint;

  /// No description provided for @progressWeekChartTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta semana'**
  String get progressWeekChartTitle;

  /// No description provided for @progressWeekChartEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ainda não há tempo nesta semana. Um áudio ou um treino já aparece aqui.'**
  String get progressWeekChartEmpty;

  /// No description provided for @progressWeekChartTotal.
  ///
  /// In pt_BR, this message translates to:
  /// **'{time} nesta semana'**
  String progressWeekChartTotal(String time);

  /// No description provided for @historyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico'**
  String get historyTitle;

  /// No description provided for @historyCardTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico'**
  String get historyCardTitle;

  /// No description provided for @historyCardBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tudo que você fez no app.'**
  String get historyCardBody;

  /// No description provided for @historyEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um treino, um áudio, um exercício, um pomodoro, um check-in ou o caderno já aparece aqui.'**
  String get historyEmpty;

  /// No description provided for @historyToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get historyToday;

  /// No description provided for @historyYesterday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ontem'**
  String get historyYesterday;

  /// No description provided for @historyWhen.
  ///
  /// In pt_BR, this message translates to:
  /// **'{weekday} às {time}'**
  String historyWhen(String weekday, String time);

  /// No description provided for @historyTypeExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Exercício'**
  String get historyTypeExercise;

  /// No description provided for @historyTypeSession.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino'**
  String get historyTypeSession;

  /// No description provided for @historyTypeListen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudio'**
  String get historyTypeListen;

  /// No description provided for @historyTypePomodoro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pomodoro'**
  String get historyTypePomodoro;

  /// No description provided for @historyTypeCheckin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in'**
  String get historyTypeCheckin;

  /// No description provided for @historyTypeJournal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caderno'**
  String get historyTypeJournal;

  /// No description provided for @historyTypeThought.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pensamento'**
  String get historyTypeThought;

  /// No description provided for @historyTypeClearMind.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente cheia'**
  String get historyTypeClearMind;

  /// No description provided for @historyTypeDayClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encerramento'**
  String get historyTypeDayClose;

  /// No description provided for @historyTypeSilentRoom.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sala silenciosa'**
  String get historyTypeSilentRoom;

  /// No description provided for @sessionPrepareTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prepare-se'**
  String get sessionPrepareTitle;

  /// No description provided for @sessionPrepareBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encontre um lugar calmo. O treino leva cerca de {minutes} minutos. Pode haver áudio: o som não começa sozinho. Se estiver em uma sala de aula ou com outras pessoas, use fone e toque em play só quando estiver pronto.'**
  String sessionPrepareBody(int minutes);

  /// No description provided for @sessionAudioWait.
  ///
  /// In pt_BR, this message translates to:
  /// **'O áudio não começa sozinho. Toque em play quando estiver em um lugar calmo. Se estiver em uma sala de aula ou com outras pessoas, use fone.'**
  String get sessionAudioWait;

  /// No description provided for @sessionAudioObjectiveTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Neste áudio'**
  String get sessionAudioObjectiveTitle;

  /// No description provided for @sessionAudioObjectiveFallback.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ao ouvir, acompanhe o áudio no seu ritmo. Se a mente sair, note e volte.'**
  String get sessionAudioObjectiveFallback;

  /// No description provided for @sessionCompleteTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino concluído'**
  String get sessionCompleteTitle;

  /// No description provided for @sessionSeeYouTomorrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Até amanhã'**
  String get sessionSeeYouTomorrow;

  /// No description provided for @sessionCompletingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardando seu treino'**
  String get sessionCompletingTitle;

  /// No description provided for @sessionCompletingBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só mais um instante na Academia Mental.'**
  String get sessionCompletingBody;

  /// No description provided for @sessionLoadingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preparando seu treino'**
  String get sessionLoadingTitle;

  /// No description provided for @sessionLoadingBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encontre um lugar calmo. A Academia Mental já vai começar.'**
  String get sessionLoadingBody;

  /// No description provided for @planTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Meu plano'**
  String get planTitle;

  /// No description provided for @planUniqueHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Plano único'**
  String get planUniqueHint;

  /// No description provided for @planCadenceTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ritmo do treino'**
  String get planCadenceTitle;

  /// No description provided for @planCadenceBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você segue um plano por vez. O próximo dia libera no próximo dia de treino, no seu fuso. Os mesmos exercícios podem aparecer em outros planos, mas o seu currículo agora é este.'**
  String get planCadenceBody;

  /// No description provided for @planCadenceDaily.
  ///
  /// In pt_BR, this message translates to:
  /// **'Todos os dias'**
  String get planCadenceDaily;

  /// No description provided for @planCadenceWeekdays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dias úteis'**
  String get planCadenceWeekdays;

  /// No description provided for @planCadenceHintDaily.
  ///
  /// In pt_BR, this message translates to:
  /// **'O próximo treino libera no dia seguinte, no seu fuso.'**
  String get planCadenceHintDaily;

  /// No description provided for @planCadenceHintWeekdays.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segunda a sexta. Se você concluir na sexta, o próximo libera na segunda.'**
  String get planCadenceHintWeekdays;

  /// No description provided for @planReminderHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O aviso chega no horário escolhido.'**
  String get planReminderHint;

  /// No description provided for @planEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Você ainda não está em um plano.'**
  String get planEmpty;

  /// No description provided for @planDaysDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'{done} de {total} dias'**
  String planDaysDone(int done, int total);

  /// No description provided for @planSettings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ritmo e lembrete'**
  String get planSettings;

  /// No description provided for @planDoneForToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Feito por hoje.'**
  String get planDoneForToday;

  /// No description provided for @planNextUnlocksTomorrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amanhã libera: {title}'**
  String planNextUnlocksTomorrow(String title);

  /// No description provided for @planNextTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libera em {date}: {title}'**
  String planNextTraining(String title, String date);

  /// No description provided for @planDayDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluído'**
  String get planDayDone;

  /// No description provided for @planDayToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje'**
  String get planDayToday;

  /// No description provided for @planDayTomorrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Amanhã'**
  String get planDayTomorrow;

  /// No description provided for @planDayLocked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Libera em {date}'**
  String planDayLocked(String date);

  /// No description provided for @planDayLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dia {day} — {title}'**
  String planDayLabel(int day, String title);

  /// No description provided for @sessionXpAwarded.
  ///
  /// In pt_BR, this message translates to:
  /// **'+{xp} XP'**
  String sessionXpAwarded(int xp);

  /// No description provided for @sessionBlockOf.
  ///
  /// In pt_BR, this message translates to:
  /// **'{current} de {total}'**
  String sessionBlockOf(int current, int total);

  /// No description provided for @breathingInhale.
  ///
  /// In pt_BR, this message translates to:
  /// **'INSPIRAR'**
  String get breathingInhale;

  /// No description provided for @breathingHold.
  ///
  /// In pt_BR, this message translates to:
  /// **'SEGURAR'**
  String get breathingHold;

  /// No description provided for @breathingExhale.
  ///
  /// In pt_BR, this message translates to:
  /// **'EXPIRAR'**
  String get breathingExhale;

  /// No description provided for @breathingRest.
  ///
  /// In pt_BR, this message translates to:
  /// **'PAUSA'**
  String get breathingRest;

  /// No description provided for @breathingCycle.
  ///
  /// In pt_BR, this message translates to:
  /// **'ciclo {current}/{total}'**
  String breathingCycle(int current, int total);

  /// No description provided for @playerPlay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tocar'**
  String get playerPlay;

  /// No description provided for @playerPause.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausar'**
  String get playerPause;

  /// No description provided for @playerNext.
  ///
  /// In pt_BR, this message translates to:
  /// **'Próxima'**
  String get playerNext;

  /// No description provided for @playerNowPlaying.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tocando agora'**
  String get playerNowPlaying;

  /// No description provided for @playerVolume.
  ///
  /// In pt_BR, this message translates to:
  /// **'Volume'**
  String get playerVolume;

  /// No description provided for @playerCoverExpand.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ampliar capa'**
  String get playerCoverExpand;

  /// No description provided for @playerPrevious.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anterior'**
  String get playerPrevious;

  /// No description provided for @playerRepeat.
  ///
  /// In pt_BR, this message translates to:
  /// **'Repetir'**
  String get playerRepeat;

  /// No description provided for @playerFavorite.
  ///
  /// In pt_BR, this message translates to:
  /// **'Favoritar'**
  String get playerFavorite;

  /// No description provided for @playerFavorited.
  ///
  /// In pt_BR, this message translates to:
  /// **'Na sua lista'**
  String get playerFavorited;

  /// No description provided for @playerTimer.
  ///
  /// In pt_BR, this message translates to:
  /// **'Timer'**
  String get playerTimer;

  /// No description provided for @playerTimerOff.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sem timer'**
  String get playerTimerOff;

  /// No description provided for @playerAboutTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre esta sessão'**
  String get playerAboutTitle;

  /// No description provided for @playerAboutBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouça no seu ritmo. Pause quando quiser e volte quando fizer sentido.'**
  String get playerAboutBody;

  /// No description provided for @attentionPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque só quando aparecer o alvo.'**
  String get attentionPrompt;

  /// No description provided for @attentionBriefingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atenção ao alvo'**
  String get attentionBriefingTitle;

  /// No description provided for @attentionBriefingBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Figuras vão aparecer. Toque somente na figura abaixo. Se vier outra, não toque. O ritmo acelera aos poucos.'**
  String get attentionBriefingBody;

  /// No description provided for @attentionBriefingNogoTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Controle o toque'**
  String get attentionBriefingNogoTitle;

  /// No description provided for @attentionBriefingNogoBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque em todas as figuras, menos na que aparece abaixo. O treino é segurar o impulso.'**
  String get attentionBriefingNogoBody;

  /// No description provided for @attentionBriefingChangeTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quando muda'**
  String get attentionBriefingChangeTitle;

  /// No description provided for @attentionBriefingChangeBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque só quando a figura for diferente da anterior. Se for a mesma, espere.'**
  String get attentionBriefingChangeBody;

  /// No description provided for @attentionBriefingGridTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ache o diferente'**
  String get attentionBriefingGridTitle;

  /// No description provided for @attentionBriefingGridBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nove figuras aparecem juntas. Toque só na que não combina com as outras.'**
  String get attentionBriefingGridBody;

  /// No description provided for @attentionTargetLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque só nesta figura'**
  String get attentionTargetLabel;

  /// No description provided for @attentionNogoLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não toque nesta figura'**
  String get attentionNogoLabel;

  /// No description provided for @attentionChangeLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque quando a figura mudar'**
  String get attentionChangeLabel;

  /// No description provided for @attentionGridLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque a que é diferente'**
  String get attentionGridLabel;

  /// No description provided for @attentionPreviousLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Anterior'**
  String get attentionPreviousLabel;

  /// No description provided for @breathingBriefingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração guiada'**
  String get breathingBriefingTitle;

  /// No description provided for @breathingBriefingBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acompanhe o círculo. Inspire, segure e expire no ritmo. Sem pressa e sem perfeição.'**
  String get breathingBriefingBody;

  /// No description provided for @breathingBriefingBoxTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Respiração em caixa'**
  String get breathingBriefingBoxTitle;

  /// No description provided for @breathingBriefingBoxBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um quadrado, quatro lados. Inspire, segure, expire e pause. O ponto anda com você.'**
  String get breathingBriefingBoxBody;

  /// No description provided for @breathingBriefingLadderTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'4-7-8'**
  String get breathingBriefingLadderTitle;

  /// No description provided for @breathingBriefingLadderBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Inspire em 4, segure em 7, expire em 8. A coluna sobe e desce com o ar.'**
  String get breathingBriefingLadderBody;

  /// No description provided for @breathingBriefingTideTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Maré longa'**
  String get breathingBriefingTideTitle;

  /// No description provided for @breathingBriefingTideBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'A expiração é mais longa que a inspiração. Acompanhe a maré indo e voltando. Sem forçar.'**
  String get breathingBriefingTideBody;

  /// No description provided for @memoryBriefingTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória de palavras'**
  String get memoryBriefingTitle;

  /// No description provided for @memoryBriefingBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Primeiro observe as palavras. Depois marque só as que você lembra.'**
  String get memoryBriefingBody;

  /// No description provided for @memoryBriefingIconsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória visual'**
  String get memoryBriefingIconsTitle;

  /// No description provided for @memoryBriefingIconsBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observe as figuras. Depois marque só as que você viu.'**
  String get memoryBriefingIconsBody;

  /// No description provided for @memoryBriefingOrderTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Memória de sequência'**
  String get memoryBriefingOrderTitle;

  /// No description provided for @memoryBriefingOrderBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'As palavras aparecem uma a uma. Depois toque na mesma ordem.'**
  String get memoryBriefingOrderBody;

  /// No description provided for @memoryBriefingDelayedTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segurar na mente'**
  String get memoryBriefingDelayedTitle;

  /// No description provided for @memoryBriefingDelayedBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observe, espere um pouco com o que ficou, depois marque o que lembra.'**
  String get memoryBriefingDelayedBody;

  /// No description provided for @exerciseBriefingStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar'**
  String get exerciseBriefingStart;

  /// No description provided for @exerciseDurationLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quanto tempo você quer treinar?'**
  String get exerciseDurationLabel;

  /// No description provided for @exerciseDurationMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{minutes} min'**
  String exerciseDurationMinutes(int minutes);

  /// No description provided for @attentionHits.
  ///
  /// In pt_BR, this message translates to:
  /// **'Acertos: {count}'**
  String attentionHits(int count);

  /// No description provided for @attentionMisses.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erros: {count}'**
  String attentionMisses(int count);

  /// No description provided for @memoryStudyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observe as palavras'**
  String get memoryStudyTitle;

  /// No description provided for @memorySelectTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quais palavras você lembra?'**
  String get memorySelectTitle;

  /// No description provided for @memoryStudyIconsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observe as figuras'**
  String get memoryStudyIconsTitle;

  /// No description provided for @memorySelectIconsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quais figuras você viu?'**
  String get memorySelectIconsTitle;

  /// No description provided for @memoryHoldTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Segure na mente'**
  String get memoryHoldTitle;

  /// No description provided for @memoryHoldBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Elas saíram da tela. Fique com o que ficou, sem ensaiar.'**
  String get memoryHoldBody;

  /// No description provided for @memoryOrderStudyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Veja a ordem'**
  String get memoryOrderStudyTitle;

  /// No description provided for @memoryOrderSelectTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque na mesma ordem'**
  String get memoryOrderSelectTitle;

  /// No description provided for @memoryOrderReset.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar de novo'**
  String get memoryOrderReset;

  /// No description provided for @memoryWordsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Minhas palavras'**
  String get memoryWordsTitle;

  /// No description provided for @memoryWordsHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicione palavras suas. Elas entram no exercício, misturadas e em ordem nova a cada vez.'**
  String get memoryWordsHint;

  /// No description provided for @memoryWordsAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar minhas palavras'**
  String get memoryWordsAdd;

  /// No description provided for @memoryWordsEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ainda não há palavras suas. O treino usa um conjunto aleatório.'**
  String get memoryWordsEmpty;

  /// No description provided for @memoryWordsField.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova palavra'**
  String get memoryWordsField;

  /// No description provided for @memoryWordsCount.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} palavras suas'**
  String memoryWordsCount(int count);

  /// No description provided for @ratingSelect.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escolha um valor'**
  String get ratingSelect;

  /// No description provided for @unknownExercise.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualize o aplicativo para este exercício.'**
  String get unknownExercise;

  /// No description provided for @exerciseRoomDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessão concluída.'**
  String get exerciseRoomDone;

  /// No description provided for @notificationTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'MindVibe'**
  String get notificationTitle;

  /// No description provided for @notificationBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seu treino de hoje está esperando por você. 🧠'**
  String get notificationBody;

  /// No description provided for @actionDelete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Excluir conta'**
  String get actionDelete;

  /// No description provided for @emptyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nada por aqui ainda'**
  String get emptyTitle;

  /// No description provided for @loadingLabel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Carregando…'**
  String get loadingLabel;

  /// No description provided for @cancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @pomodoroTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pomodoro'**
  String get pomodoroTitle;

  /// No description provided for @pomodoroHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'25 minutos de atenção, 5 de pausa. Sem pressão.'**
  String get pomodoroHint;

  /// No description provided for @pomodoroFocus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foco'**
  String get pomodoroFocus;

  /// No description provided for @pomodoroBreak.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausa'**
  String get pomodoroBreak;

  /// No description provided for @pomodoroStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar'**
  String get pomodoroStart;

  /// No description provided for @pomodoroPause.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pausar'**
  String get pomodoroPause;

  /// No description provided for @pomodoroReset.
  ///
  /// In pt_BR, this message translates to:
  /// **'Recomeçar'**
  String get pomodoroReset;

  /// No description provided for @pomodoroPresetClassic.
  ///
  /// In pt_BR, this message translates to:
  /// **'25 + 5'**
  String get pomodoroPresetClassic;

  /// No description provided for @pomodoroPresetShort.
  ///
  /// In pt_BR, this message translates to:
  /// **'15 + 5'**
  String get pomodoroPresetShort;

  /// No description provided for @pomodoroPresetLong.
  ///
  /// In pt_BR, this message translates to:
  /// **'50 + 10'**
  String get pomodoroPresetLong;

  /// No description provided for @pomodoroRounds.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} blocos feitos'**
  String pomodoroRounds(int count);

  /// No description provided for @checkinTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in'**
  String get checkinTitle;

  /// No description provided for @checkinHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está agora? Um toque em cada eixo. Dez segundos.'**
  String get checkinHint;

  /// No description provided for @checkinMoodTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor'**
  String get checkinMoodTitle;

  /// No description provided for @checkinEnergyTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Energia'**
  String get checkinEnergyTitle;

  /// No description provided for @checkinMood.
  ///
  /// In pt_BR, this message translates to:
  /// **'{level, select, 1{Muito pesado} 2{Pesado} 3{Neutro} 4{Leve} 5{Bom} other{}}'**
  String checkinMood(String level);

  /// No description provided for @checkinEnergy.
  ///
  /// In pt_BR, this message translates to:
  /// **'{level, select, 1{Sem força} 2{Baixa} 3{Média} 4{Boa} 5{Alta} other{}}'**
  String checkinEnergy(String level);

  /// No description provided for @checkinWeight.
  ///
  /// In pt_BR, this message translates to:
  /// **'{level, select, 1{Dia pesado} 2{Dia mais calmo} 3{Dia em equilíbrio} 4{Dia em movimento} 5{Dia leve} other{}}'**
  String checkinWeight(String level);

  /// No description provided for @checkinSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrado. Isso vira o clima de hoje no progresso.'**
  String get checkinSaved;

  /// No description provided for @checkinSaving.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardando…'**
  String get checkinSaving;

  /// No description provided for @checkinSeeProgress.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver no progresso'**
  String get checkinSeeProgress;

  /// No description provided for @checkinUpdateHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pode tocar de novo se o dia mudou.'**
  String get checkinUpdateHint;

  /// No description provided for @checkinPromptLater.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agora não'**
  String get checkinPromptLater;

  /// No description provided for @progressCheckinTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Clima do dia'**
  String get progressCheckinTitle;

  /// No description provided for @progressCheckinEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como está o dia? Dez segundos, um toque.'**
  String get progressCheckinEmpty;

  /// No description provided for @progressCheckinCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fazer check-in'**
  String get progressCheckinCta;

  /// No description provided for @progressCheckinBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Humor {mood} · Energia {energy}'**
  String progressCheckinBody(String mood, String energy);

  /// No description provided for @progressStreakCheckinHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'A sequência é aparecer. O clima explica o peso do dia melhor do que só os minutos.'**
  String get progressStreakCheckinHint;

  /// No description provided for @clearMindTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mente cheia'**
  String get clearMindTitle;

  /// No description provided for @clearMindIntro.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não é hora de mais informação. É hora de desacelerar e recuperar espaço.'**
  String get clearMindIntro;

  /// No description provided for @clearMindStart.
  ///
  /// In pt_BR, this message translates to:
  /// **'Começar'**
  String get clearMindStart;

  /// No description provided for @clearMindPauseBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Afastar. Respirar. Sem tentar resolver nada.'**
  String get clearMindPauseBody;

  /// No description provided for @clearMindSkipPause.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já respirei'**
  String get clearMindSkipPause;

  /// No description provided for @clearMindDumpBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreve o que está passando pela cabeça. Sem organizar.'**
  String get clearMindDumpBody;

  /// No description provided for @clearMindDumpHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que não larga agora'**
  String get clearMindDumpHint;

  /// No description provided for @clearMindAdd.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais uma'**
  String get clearMindAdd;

  /// No description provided for @clearMindDumpNext.
  ///
  /// In pt_BR, this message translates to:
  /// **'Continuar'**
  String get clearMindDumpNext;

  /// No description provided for @clearMindQuestion.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dessas coisas todas que estão na sua cabeça agora, qual é a única que realmente precisa da sua atenção hoje?'**
  String get clearMindQuestion;

  /// No description provided for @clearMindPickHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque em uma. O resto pode esperar.'**
  String get clearMindPickHint;

  /// No description provided for @clearMindKeepOne.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ficar com esta'**
  String get clearMindKeepOne;

  /// No description provided for @clearMindDoneEyebrow.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje, só isto'**
  String get clearMindDoneEyebrow;

  /// No description provided for @clearMindParked.
  ///
  /// In pt_BR, this message translates to:
  /// **'O resto foi estacionado ({count}). Não precisa ser resolvido hoje.'**
  String clearMindParked(int count);

  /// No description provided for @clearMindParkedNone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só isto. Nada mais para estacionar.'**
  String get clearMindParkedNone;

  /// No description provided for @clearMindDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pronto'**
  String get clearMindDone;

  /// No description provided for @clearMindSeeLot.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ver o pátio'**
  String get clearMindSeeLot;

  /// No description provided for @clearMindOneThing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma coisa por vez'**
  String get clearMindOneThing;

  /// No description provided for @clearMindHomeCard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Hoje, só isto'**
  String get clearMindHomeCard;

  /// No description provided for @clearMindHomeCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cabeça cheia? Descarrega e fica com uma coisa só.'**
  String get clearMindHomeCta;

  /// No description provided for @clearMindFromCheckin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está com a mente cheia?'**
  String get clearMindFromCheckin;

  /// No description provided for @journalTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caderno'**
  String get journalTitle;

  /// No description provided for @journalHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Três linhas. Intenção da manhã, descarregar a cabeça, ou 3 gratidões. Curto, privado, volta amanhã.'**
  String get journalHint;

  /// No description provided for @journalPrompt.
  ///
  /// In pt_BR, this message translates to:
  /// **'{prompt, select, intention{Intenção da manhã} unload{Descarregar a cabeça} gratitude{3 gratidões} other{Caderno}}'**
  String journalPrompt(String prompt);

  /// No description provided for @journalPromptHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'{prompt, select, intention{O que você leva para o dia.} unload{Tira da mente o que está ocupando espaço.} gratitude{Três coisas pequenas que ainda estão aqui.} other{}}'**
  String journalPromptHint(String prompt);

  /// No description provided for @journalIntention1.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que importa hoje?'**
  String get journalIntention1;

  /// No description provided for @journalIntention2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um passo pequeno'**
  String get journalIntention2;

  /// No description provided for @journalIntention3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Como quero chegar à noite'**
  String get journalIntention3;

  /// No description provided for @journalUnload1.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que está ocupando a cabeça?'**
  String get journalUnload1;

  /// No description provided for @journalUnload2.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que pode esperar'**
  String get journalUnload2;

  /// No description provided for @journalUnload3.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que eu solto agora'**
  String get journalUnload3;

  /// No description provided for @journalGratitude1.
  ///
  /// In pt_BR, this message translates to:
  /// **'Uma coisa boa'**
  String get journalGratitude1;

  /// No description provided for @journalGratitude2.
  ///
  /// In pt_BR, this message translates to:
  /// **'Outra'**
  String get journalGratitude2;

  /// No description provided for @journalGratitude3.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais uma'**
  String get journalGratitude3;

  /// No description provided for @journalSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardar'**
  String get journalSave;

  /// No description provided for @journalUpdate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualizar hoje'**
  String get journalUpdate;

  /// No description provided for @journalSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardado. Só você lê. Amanhã o caderno volta em branco.'**
  String get journalSaved;

  /// No description provided for @journalPrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ninguém mais vê. Nem no ranking.'**
  String get journalPrivate;

  /// No description provided for @journalWeek.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dias em que você escreveu'**
  String get journalWeek;

  /// No description provided for @silentRoomTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sala silenciosa'**
  String get silentRoomTitle;

  /// No description provided for @silentRoomHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Um bloco de presença. Sem ciclo, sem pausa. Para quem acha o Pomodoro pesado.'**
  String get silentRoomHint;

  /// No description provided for @silentRoomPresence.
  ///
  /// In pt_BR, this message translates to:
  /// **'Presença'**
  String get silentRoomPresence;

  /// No description provided for @silentRoomDone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Bloco concluído'**
  String get silentRoomDone;

  /// No description provided for @silentRoomMinutes.
  ///
  /// In pt_BR, this message translates to:
  /// **'{count} min'**
  String silentRoomMinutes(int count);

  /// No description provided for @thoughtTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estacionar o pensamento'**
  String get thoughtTitle;

  /// No description provided for @thoughtHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escreve o que está ocupando a mente. Guarda e segue — para o treino, o áudio ou o sono.'**
  String get thoughtHint;

  /// No description provided for @thoughtPlaceholder.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que não larga agora'**
  String get thoughtPlaceholder;

  /// No description provided for @thoughtSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Guardar e seguir'**
  String get thoughtSave;

  /// No description provided for @thoughtSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Está guardado. A mente pode seguir.'**
  String get thoughtSaved;

  /// No description provided for @thoughtPrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só você lê. Não vai para o ranking.'**
  String get thoughtPrivate;

  /// No description provided for @thoughtContinue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Seguir para'**
  String get thoughtContinue;

  /// No description provided for @thoughtContinueTraining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Treino'**
  String get thoughtContinueTraining;

  /// No description provided for @thoughtContinueAudio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudio'**
  String get thoughtContinueAudio;

  /// No description provided for @thoughtContinueSleep.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sono'**
  String get thoughtContinueSleep;

  /// No description provided for @thoughtLot.
  ///
  /// In pt_BR, this message translates to:
  /// **'No pátio'**
  String get thoughtLot;

  /// No description provided for @thoughtLotEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nada estacionado.'**
  String get thoughtLotEmpty;

  /// No description provided for @thoughtLotFull.
  ///
  /// In pt_BR, this message translates to:
  /// **'O pátio está cheio. Solte um pensamento para estacionar outro.'**
  String get thoughtLotFull;

  /// No description provided for @thoughtRelease.
  ///
  /// In pt_BR, this message translates to:
  /// **'Soltar'**
  String get thoughtRelease;

  /// No description provided for @dayCloseTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Encerramento do dia'**
  String get dayCloseTitle;

  /// No description provided for @dayCloseHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dois minutos. O que ficou, o que solta, um áudio curto. Fecha a academia como o treino fecha o dia no corpo.'**
  String get dayCloseHint;

  /// No description provided for @dayCloseKept.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que ficou'**
  String get dayCloseKept;

  /// No description provided for @dayCloseReleased.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que solta'**
  String get dayCloseReleased;

  /// No description provided for @dayCloseSave.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar o dia'**
  String get dayCloseSave;

  /// No description provided for @dayCloseUpdate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Atualizar hoje'**
  String get dayCloseUpdate;

  /// No description provided for @dayCloseSaved.
  ///
  /// In pt_BR, this message translates to:
  /// **'O dia está fechado. Só você lê. Agora o áudio curto.'**
  String get dayCloseSaved;

  /// No description provided for @dayClosePrivate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Só você lê. Não vai para o ranking.'**
  String get dayClosePrivate;

  /// No description provided for @dayCloseAudio.
  ///
  /// In pt_BR, this message translates to:
  /// **'Áudio curto'**
  String get dayCloseAudio;

  /// No description provided for @dayClosePlay.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ouvir'**
  String get dayClosePlay;

  /// No description provided for @dayCloseWeek.
  ///
  /// In pt_BR, this message translates to:
  /// **'Noites em que você fechou'**
  String get dayCloseWeek;

  /// No description provided for @xpInfoTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sobre o XP'**
  String get xpInfoTitle;

  /// No description provided for @xpInfoLead.
  ///
  /// In pt_BR, this message translates to:
  /// **'XP cresce quando você conclui um treino. As ferramentas e os áudios acompanham o dia, sem somar pontos.'**
  String get xpInfoLead;

  /// No description provided for @xpInfoGivesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que dá XP'**
  String get xpInfoGivesTitle;

  /// No description provided for @xpInfoGivesBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Concluir a sessão do programa. Terminar um ciclo. Conquistas ligadas ao treino.'**
  String get xpInfoGivesBody;

  /// No description provided for @xpInfoSkipsTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'O que não dá'**
  String get xpInfoSkipsTitle;

  /// No description provided for @xpInfoSkipsBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Check-in, mente cheia, caderno, estacionar o pensamento, encerramento, Pomodoro, sala silenciosa e ouvir áudios. Eles ficam no histórico e no clima. Sem XP.'**
  String get xpInfoSkipsBody;

  /// No description provided for @xpInfoWhereTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Onde aparece'**
  String get xpInfoWhereTitle;

  /// No description provided for @xpInfoWhereBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em Progresso, na home e no fim do treino. No ranking, só se você quiser aparecer.'**
  String get xpInfoWhereBody;

  /// No description provided for @xpInfoStreakTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sequência'**
  String get xpInfoStreakTitle;

  /// No description provided for @xpInfoStreakBody.
  ///
  /// In pt_BR, this message translates to:
  /// **'A sequência conta dias com treino concluído. O check-in é o clima do dia, não a sequência.'**
  String get xpInfoStreakBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'en':
      {
        switch (locale.countryCode) {
          case 'US':
            return AppLocalizationsEnUs();
        }
        break;
      }
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
