import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';

Future<void> showAudioBriefingModal({
  required BuildContext context,
  required String title,
  required String objective,
  required String waitHint,
  required String confirmLabel,
  String? coverUrl,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierLabel: confirmLabel,
    barrierColor: Colors.black.withValues(alpha: 0.62),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      final scheme = Theme.of(context).colorScheme;
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Material(
              color: scheme.surface,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.82,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CoverImage(url: coverUrl, size: 88, radius: 20),
                        const SizedBox(height: 18),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: scheme.primary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          objective,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                            letterSpacing: -0.2,
                            color: scheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                          decoration: BoxDecoration(
                            color: scheme.surfaceContainerHighest.withValues(
                              alpha: 0.55,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: scheme.outline),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.headphones_outlined,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  waitHint,
                                  style: TextStyle(
                                    fontSize: 15,
                                    height: 1.45,
                                    fontWeight: FontWeight.w500,
                                    color: scheme.onSurface.withValues(
                                      alpha: 0.88,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        AppButton(
                          label: confirmLabel,
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.92, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}
