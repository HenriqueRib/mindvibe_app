import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mindvibe_app/app/router/app_routes.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/config/app_config.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/error/result.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/core/storage/appearance_store.dart';
import 'package:mindvibe_app/core/storage/home_layout_store.dart';
import 'package:mindvibe_app/core/storage/locale_store.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/auth/domain/entities/auth_entities.dart';
import 'package:mindvibe_app/features/auth/presentation/providers/session_controller.dart';
import 'package:mindvibe_app/features/profile/domain/profile_avatars.dart';
import 'package:mindvibe_app/features/training/presentation/providers/training_providers.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _saving = false;

  TimeOfDay _timeFrom(String? raw) {
    final parts = (raw ?? '08:00').split(':');
    return TimeOfDay(
      hour: int.tryParse(parts.first) ?? 8,
      minute: parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0,
    );
  }

  String _format(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _apply(Future<Result<UserAccount>> Function() action) async {
    setState(() => _saving = true);
    final result = await action();
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final l10n = lookupAppLocalizations(ref.read(localeProvider));
    final user = result.valueOrNull;
    if (user != null) {
      await ref
          .read(notificationSchedulerProvider)
          .sync(
            user,
            title: l10n.notificationTitle,
            body: l10n.notificationBody,
          );
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(failureMessage(result.failureOrNull!, l10n))),
      );
    }
  }

  Future<void> _save({
    required bool notificationEnabled,
    required String? notificationTime,
  }) {
    return _apply(
      () => ref
          .read(sessionControllerProvider.notifier)
          .updateProfile(
            notificationEnabled: notificationEnabled,
            notificationTime: notificationTime,
          ),
    );
  }

  Future<void> _editName(UserAccount user) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: user.name);
    final saved = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(l10n.profileEditName),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            maxLength: 80,
            decoration: InputDecoration(
              labelText: l10n.fieldName,
              hintText: l10n.profileNameHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(controller.text),
              child: Text(l10n.actionSave),
            ),
          ],
        );
      },
    );
    controller.dispose();
    final name = saved?.trim();
    if (name == null || name == user.name) {
      return;
    }
    if (AuthValidators.required(name) != null || name.length < 2) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.validationRequired)));
      return;
    }
    await _apply(
      () => ref
          .read(sessionControllerProvider.notifier)
          .updateProfile(name: name),
    );
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 720,
      maxHeight: 720,
      imageQuality: 85,
    );
    if (picked == null || !mounted) {
      return;
    }
    await _apply(
      () => ref
          .read(sessionControllerProvider.notifier)
          .uploadAvatar(picked.path),
    );
  }

  Future<void> _chooseEmoji() async {
    final l10n = AppLocalizations.of(context);
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profileEmojiTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                AppText.subtitle(l10n.profileEmojiBody),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    for (final emoji in ProfileAvatars.emojis)
                      InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.of(context).pop(emoji),
                        child: Container(
                          width: 52,
                          height: 52,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest
                                .withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 26),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    if (selected == null || !mounted) {
      return;
    }
    await _apply(
      () => ref
          .read(sessionControllerProvider.notifier)
          .updateProfile(avatarEmoji: selected),
    );
  }

  Future<void> _openAvatarSheet(UserAccount user) async {
    final l10n = AppLocalizations.of(context);
    final hasAvatar =
        (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) ||
        (user.avatarEmoji != null && user.avatarEmoji!.isNotEmpty);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_outlined),
                title: Text(l10n.profilePhotoGallery),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickPhoto();
                },
              ),
              ListTile(
                leading: const Icon(Icons.emoji_emotions_outlined),
                title: Text(l10n.profileEmojiChoose),
                onTap: () {
                  Navigator.of(context).pop();
                  _chooseEmoji();
                },
              ),
              if (hasAvatar)
                ListTile(
                  leading: const Icon(Icons.hide_image_outlined),
                  title: Text(l10n.profilePhotoRemove),
                  onTap: () {
                    Navigator.of(context).pop();
                    _apply(
                      () => ref
                          .read(sessionControllerProvider.notifier)
                          .clearAvatar(),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openLanguageSheet() async {
    final l10n = AppLocalizations.of(context);
    final current = ref.read(localeProvider);
    final selected = await showModalBottomSheet<Locale>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    l10n.languageSection,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final option in AppLocale.options)
                  ListTile(
                    leading: Icon(
                      Icons.language_outlined,
                      color: AppLocale.matches(current, option)
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(
                      AppLocale.matches(option, AppLocale.english)
                          ? l10n.languageEnglish
                          : l10n.languagePortuguese,
                    ),
                    trailing: AppLocale.matches(current, option)
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected == null || !mounted) {
      return;
    }
    if (AppLocale.matches(selected, current)) {
      return;
    }
    await ref.read(localeProvider.notifier).setLocale(selected);
    if (!mounted) {
      return;
    }
    await _apply(
      () => ref
          .read(sessionControllerProvider.notifier)
          .updateProfile(locale: AppLocale.encode(selected)),
    );
  }

  Future<void> _openLayoutSheet() async {
    final l10n = AppLocalizations.of(context);
    final current = ref.read(homeLayoutProvider);
    final selected = await showModalBottomSheet<HomeLayoutKind>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: Text(
                    l10n.homeLayoutSection,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                for (final option in HomeLayoutKind.values)
                  ListTile(
                    leading: Icon(
                      switch (option) {
                        HomeLayoutKind.today => Icons.wb_sunny_outlined,
                        HomeLayoutKind.training => Icons.play_circle_outline,
                        HomeLayoutKind.progress => Icons.insights_outlined,
                      },
                      color: option == current
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    title: Text(_layoutLabel(l10n, option)),
                    subtitle: Text(_layoutHint(l10n, option)),
                    trailing: option == current
                        ? Icon(
                            Icons.check,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                    onTap: () => Navigator.of(context).pop(option),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected == null || !mounted || selected == current) {
      return;
    }
    await ref.read(homeLayoutProvider.notifier).setKind(selected);
  }

  String _layoutLabel(AppLocalizations l10n, HomeLayoutKind kind) {
    return switch (kind) {
      HomeLayoutKind.today => l10n.homeLayoutToday,
      HomeLayoutKind.training => l10n.homeLayoutTraining,
      HomeLayoutKind.progress => l10n.homeLayoutProgress,
    };
  }

  String _layoutHint(AppLocalizations l10n, HomeLayoutKind kind) {
    return switch (kind) {
      HomeLayoutKind.today => l10n.homeLayoutTodayHint,
      HomeLayoutKind.training => l10n.homeLayoutTrainingHint,
      HomeLayoutKind.progress => l10n.homeLayoutProgressHint,
    };
  }

  Future<void> _openLegal(String url) async {
    final l10n = AppLocalizations.of(context);
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.profileLegalOpenError)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(sessionControllerProvider).user;
    final reminder = user?.notificationEnabled ?? false;
    final time = _timeFrom(user?.notificationTime);
    final dark = ref.watch(appearanceProvider) == ThemeMode.dark;
    final locale = ref.watch(localeProvider);
    final homeLayout = ref.watch(homeLayoutProvider);
    final outline = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.7);

    Widget divider() => Divider(height: 1, color: outline);

    return AppScaffold(
      title: l10n.profileTitle,
      body: ListView(
        children: [
          Row(
            children: [
              Semantics(
                button: true,
                label: l10n.profileAvatarHint,
                child: ScaleOnTap(
                  child: GestureDetector(
                    onTap: user == null || _saving
                        ? null
                        : () => _openAvatarSheet(user),
                    child: _AvatarMark(user: user),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      button: true,
                      label: l10n.profileEditName,
                      child: GestureDetector(
                        onTap: user == null || _saving
                            ? null
                            : () => _editName(user),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.name ?? '',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Semantics(
                      button: true,
                      label: (user?.isPremium ?? false)
                          ? l10n.profilePlanPremium
                          : l10n.profilePlanFree,
                      child: GestureDetector(
                        onTap: user == null
                            ? null
                            : () => context.push(
                                (user.isPremium)
                                    ? AppRoutes.billing
                                    : AppRoutes.paywall,
                              ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: (user?.isPremium ?? false)
                                ? Theme.of(
                                    context,
                                  ).colorScheme.primary.withValues(alpha: 0.12)
                                : Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            (user?.isPremium ?? false)
                                ? l10n.profilePlanPremium
                                : l10n.profilePlanFree,
                            style: TextStyle(
                              color: (user?.isPremium ?? false)
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                _SwitchRow(
                  label: l10n.themeDark,
                  value: dark,
                  onChanged: (value) =>
                      ref.read(appearanceProvider.notifier).setDark(value),
                ),
                divider(),
                _ValueRow(
                  label: l10n.languageSection,
                  value: AppLocale.matches(locale, AppLocale.english)
                      ? l10n.languageEnglish
                      : l10n.languagePortuguese,
                  onTap: _saving ? null : _openLanguageSheet,
                ),
                divider(),
                _ValueRow(
                  label: l10n.homeLayoutSection,
                  value: _layoutLabel(l10n, homeLayout),
                  onTap: _openLayoutSheet,
                ),
                divider(),
                _SwitchRow(
                  label: l10n.reminderEnable,
                  value: reminder,
                  onChanged: _saving
                      ? null
                      : (value) => _save(
                          notificationEnabled: value,
                          notificationTime: _format(time),
                        ),
                ),
                if (reminder) ...[
                  divider(),
                  _ValueRow(
                    label: l10n.reminderTime,
                    value: time.format(context),
                    onTap: _saving
                        ? null
                        : () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: time,
                            );
                            if (picked != null) {
                              await _save(
                                notificationEnabled: true,
                                notificationTime: _format(picked),
                              );
                            }
                          },
                  ),
                ],
                divider(),
                _SwitchRow(
                  label: l10n.profileRanking,
                  value: user?.showInRanking ?? false,
                  onChanged: user == null || _saving
                      ? null
                      : (value) async {
                          await _apply(
                            () => ref
                                .read(sessionControllerProvider.notifier)
                                .updateProfile(showInRanking: value),
                          );
                          ref.invalidate(rankingProvider);
                        },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _AccountFold(
            title: l10n.profileAccountTitle,
            children: [
              _ValueRow(
                label: l10n.billingTitle,
                onTap: () => context.push(AppRoutes.billing),
              ),
              _ValueRow(
                label: l10n.profileMessageTitle,
                onTap: () => context.push(AppRoutes.profileMessage),
              ),
              _ValueRow(
                label: l10n.profileTerms,
                onTap: () => _openLegal(AppConfig.termsUrl),
              ),
              _ValueRow(
                label: l10n.profilePrivacy,
                onTap: () => _openLegal(AppConfig.privacyUrl),
              ),
              _ValueRow(
                label: l10n.actionLogout,
                onTap: () async {
                  final confirmed = await showAppDialog(
                    context: context,
                    title: l10n.profileLogoutConfirm,
                    confirmLabel: l10n.actionLogout,
                    cancelLabel: l10n.cancel,
                  );
                  if (confirmed) {
                    await ref.read(sessionControllerProvider.notifier).logout();
                  }
                },
              ),
              _ValueRow(
                label: l10n.profileDeleteAccount,
                color: AppColors.error,
                onTap: () async {
                  final confirmed = await showAppDialog(
                    context: context,
                    title: l10n.profileDeleteConfirm,
                    body: l10n.profileDeleteConfirmBody,
                    confirmLabel: l10n.actionDelete,
                    cancelLabel: l10n.cancel,
                  );
                  if (confirmed) {
                    await ref
                        .read(sessionControllerProvider.notifier)
                        .deleteAccount();
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({required this.label, this.value, this.onTap, this.color});

  final String label;
  final String? value;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final resolved = color ?? Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.w600, color: resolved),
              ),
            ),
            if (value != null && value!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  value!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color:
                        color ?? Theme.of(context).colorScheme.onSurfaceVariant,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _AccountFold extends StatefulWidget {
  const _AccountFold({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  State<_AccountFold> createState() => _AccountFoldState();
}

class _AccountFoldState extends State<_AccountFold> {
  var _open = false;

  @override
  Widget build(BuildContext context) {
    final outline = Theme.of(
      context,
    ).colorScheme.outline.withValues(alpha: 0.7);
    return AppCard(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 8),
      child: Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            title: Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            trailing: Icon(
              _open ? Icons.expand_less_rounded : Icons.expand_more_rounded,
            ),
            onTap: () => setState(() => _open = !_open),
          ),
          if (_open)
            Column(
              children: [
                for (var i = 0; i < widget.children.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: outline,
                    ),
                  widget.children[i],
                ],
              ],
            ),
        ],
      ),
    );
  }
}

class _AvatarMark extends StatelessWidget {
  const _AvatarMark({required this.user});

  final UserAccount? user;

  @override
  Widget build(BuildContext context) {
    final url = user?.avatarUrl;
    final emoji = user?.avatarEmoji;
    final letter = (user?.name ?? '?').trim();
    final initial = letter.isEmpty
        ? '?'
        : letter.characters.first.toUpperCase();

    Widget child;
    if (url != null && url.isNotEmpty) {
      child = CoverImage(url: url, size: 72, radius: 36, icon: Icons.person);
    } else if (emoji != null && emoji.isNotEmpty) {
      child = ColoredBox(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 32))),
      );
    } else {
      child = ColoredBox(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        child: Center(
          child: Text(
            initial,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      );
    }

    return ClipOval(child: SizedBox(width: 72, height: 72, child: child));
  }
}
