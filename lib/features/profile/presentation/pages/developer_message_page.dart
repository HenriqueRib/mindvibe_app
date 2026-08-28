import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/core/device/device_id_store.dart';
import 'package:mindvibe_app/core/error/failure_message.dart';
import 'package:mindvibe_app/core/providers/core_providers.dart';
import 'package:mindvibe_app/features/auth/domain/auth_validators.dart';
import 'package:mindvibe_app/features/profile/data/feedback_remote.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

final feedbackRemoteProvider = Provider<FeedbackRemote>((ref) {
  return FeedbackRemote(ref.watch(apiClientProvider));
});

class DeveloperMessagePage extends ConsumerStatefulWidget {
  const DeveloperMessagePage({super.key});

  @override
  ConsumerState<DeveloperMessagePage> createState() =>
      _DeveloperMessagePageState();
}

class _DeveloperMessagePageState extends ConsumerState<DeveloperMessagePage> {
  final _formKey = GlobalKey<FormState>();
  final _message = TextEditingController();
  String _type = 'suggestion';
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _loading = true);
    final result = await ref
        .read(feedbackRemoteProvider)
        .send(
          type: _type,
          message: _message.text.trim(),
          platform: currentPlatformName(),
        );
    if (!mounted) {
      return;
    }
    setState(() => _loading = false);
    result.when(
      success: (_) => setState(() => _sent = true),
      failure: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failureMessage(error, AppLocalizations.of(context))),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AppScaffold(
      showBack: true,
      title: l10n.profileMessageTitle,
      body: _sent
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Spacer(),
                AppText.title(l10n.profileMessageSent, align: TextAlign.center),
                const Spacer(),
                AppButton(
                  label: l10n.actionBack,
                  onPressed: () => context.pop(),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  AppText.subtitle(l10n.profileMessageBody),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final option in [
                        ('suggestion', l10n.profileMessageTypeSuggestion),
                        ('feature', l10n.profileMessageTypeFeature),
                        ('thanks', l10n.profileMessageTypeThanks),
                      ])
                        ChoiceChip(
                          label: Text(option.$2),
                          selected: _type == option.$1,
                          onSelected: (_) => setState(() => _type = option.$1),
                        ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _message,
                    minLines: 6,
                    maxLines: 10,
                    maxLength: 2000,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: l10n.profileMessageField,
                      hintText: l10n.profileMessageHint,
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (AuthValidators.required(value) != null) {
                        return l10n.validationRequired;
                      }
                      if (value!.trim().length < 8) {
                        return l10n.profileMessageTooShort;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: l10n.actionSend,
                    loading: _loading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
    );
  }
}
