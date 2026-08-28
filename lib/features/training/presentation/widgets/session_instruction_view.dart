import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';

class SessionInstructionView extends StatelessWidget {
  const SessionInstructionView({
    super.key,
    required this.body,
    required this.continueLabel,
    required this.onContinue,
  });

  final String body;
  final String continueLabel;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (lead, rest) = _splitLead(body);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 12),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: FadeSlideIn(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 24, 22, 26),
                        decoration: BoxDecoration(
                          color: scheme.surface,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: scheme.outline.withValues(alpha: 0.7),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 4,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(99),
                              ),
                            ),
                            const SizedBox(height: 22),
                            Text(
                              lead,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: rest.isEmpty ? 22 : 24,
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                                letterSpacing: -0.3,
                                color: scheme.onSurface,
                              ),
                            ),
                            if (rest.isNotEmpty) ...[
                              const SizedBox(height: 18),
                              Text(
                                rest,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  height: 1.55,
                                  fontWeight: FontWeight.w500,
                                  color: scheme.onSurface.withValues(
                                    alpha: 0.86,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        AppButton(label: continueLabel, onPressed: onContinue),
      ],
    );
  }

  static (String, String) _splitLead(String raw) {
    final text = raw.trim();
    if (text.isEmpty) {
      return ('', '');
    }
    final match = RegExp(r'^(.*?[.!?])\s+(.+)$', dotAll: true).firstMatch(text);
    if (match == null) {
      return (text, '');
    }
    return (match.group(1)!.trim(), match.group(2)!.trim());
  }
}
