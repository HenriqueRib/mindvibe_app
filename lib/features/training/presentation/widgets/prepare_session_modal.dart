import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/widgets/app_widgets.dart';
import 'package:mindvibe_app/features/audio_player/presentation/widgets/cover_image.dart';

Future<bool> showPrepareSessionModal({
  required BuildContext context,
  required String title,
  required String body,
  required String confirmLabel,
  required String cancelLabel,
  String? coverUrl,
}) async {
  final result = await showGeneralDialog<bool>(
    context: context,
    barrierDismissible: true,
    barrierLabel: cancelLabel,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) {
      return SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Material(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(28),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(28, 36, 28, 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.sizeOf(context).height * 0.78,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CoverImage(url: coverUrl, size: 96, radius: 20),
                        const SizedBox(height: 20),
                        AppText.title(title, align: TextAlign.center),
                        const SizedBox(height: 16),
                        AppText.subtitle(body, align: TextAlign.center),
                        const SizedBox(height: 32),
                        AppButton(
                          label: confirmLabel,
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                        const SizedBox(height: 8),
                        AppButton(
                          label: cancelLabel,
                          variant: AppButtonVariant.ghost,
                          onPressed: () => Navigator.of(context).pop(false),
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
  return result ?? false;
}
