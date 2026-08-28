import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/app/widgets/app_loading.dart';

export 'app_loading.dart';
export 'app_motion.dart';

class ScaleOnTap extends StatefulWidget {
  const ScaleOnTap({super.key, required this.child});

  final Widget child;

  @override
  State<ScaleOnTap> createState() => _ScaleOnTapState();
}

class _ScaleOnTapState extends State<ScaleOnTap> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.body,
    this.title,
    this.actions,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.padding,
    this.showBack = false,
    this.backgroundColor,
    this.useSafeArea = true,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final EdgeInsetsGeometry? padding;
  final bool showBack;
  final Color? backgroundColor;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final padded = Padding(
      padding: padding ?? const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: body,
    );
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar:
          title == null && !showBack && (actions == null || actions!.isEmpty)
          ? null
          : AppBar(
              title: title == null ? null : Text(title!),
              automaticallyImplyLeading: showBack,
              actions: actions,
            ),
      body: useSafeArea ? SafeArea(child: padded) : padded,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.expand = true,
    this.variant = AppButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final bool expand;
  final AppButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final child = loading
        ? AppLoading.compact(
            color: variant == AppButtonVariant.primary
                ? AppColors.onPrimary
                : AppColors.primary,
          )
        : Text(label);

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: child,
      ),
      AppButtonVariant.secondary => OutlinedButton(
        onPressed: loading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        child: child,
      ),
      AppButtonVariant.ghost => TextButton(
        onPressed: loading ? null : onPressed,
        child: child,
      ),
    };

    return expand
        ? SizedBox(
            width: double.infinity,
            child: ScaleOnTap(child: button),
          )
        : ScaleOnTap(child: button);
  }
}

enum AppButtonVariant { primary, secondary, ghost }

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(20),
      child: child,
    );

    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radius),
        side: BorderSide(color: scheme.outline),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
  }
}

class AppText extends StatelessWidget {
  const AppText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.align,
    this.maxLines,
  });

  final String text;
  final TextStyle? style;
  final Color? color;
  final TextAlign? align;
  final int? maxLines;

  factory AppText.title(String text, {Key? key, TextAlign? align}) {
    return AppText(
      text,
      key: key,
      align: align,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        letterSpacing: -0.4,
      ),
    );
  }

  factory AppText.subtitle(String text, {Key? key, TextAlign? align}) {
    return AppText(
      text,
      key: key,
      align: align,
      style: const TextStyle(
        fontSize: 16,
        height: 1.45,
        color: AppColors.muted,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      maxLines: maxLines,
      overflow: maxLines == null ? null : TextOverflow.ellipsis,
      style: (style ?? Theme.of(context).textTheme.bodyLarge)?.copyWith(
        color: color,
      ),
    );
  }
}

class AppProgressBar extends StatelessWidget {
  const AppProgressBar({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.clamp(0, 1)),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, animated, _) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: animated,
            minHeight: 8,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.outline.withValues(alpha: 0.22),
            color: AppColors.primary,
          ),
        );
      },
    );
  }
}

class AppError extends StatelessWidget {
  const AppError({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? retryLabel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            AppButton(
              label: retryLabel ?? 'OK',
              onPressed: onRetry,
              expand: false,
            ),
          ],
        ],
      ),
    );
  }
}

class AppEmpty extends StatelessWidget {
  const AppEmpty({super.key, required this.title, this.body});

  final String title;
  final String? body;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.title(title),
          if (body != null) ...[
            const SizedBox(height: 8),
            AppText.subtitle(body!),
          ],
        ],
      ),
    );
  }
}

class AppBottomNavigation extends StatelessWidget {
  const AppBottomNavigation({
    super.key,
    required this.index,
    required this.onChanged,
    required this.homeLabel,
    required this.progressLabel,
    required this.profileLabel,
  });

  final int index;
  final ValueChanged<int> onChanged;
  final String homeLabel;
  final String progressLabel;
  final String profileLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return NavigationBar(
      selectedIndex: index,
      onDestinationSelected: onChanged,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      indicatorColor: scheme.primary.withValues(
        alpha: scheme.brightness == Brightness.dark ? 0.28 : 0.18,
      ),
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.spa_outlined),
          selectedIcon: const Icon(Icons.spa),
          label: homeLabel,
        ),
        NavigationDestination(
          icon: const Icon(Icons.insights_outlined),
          selectedIcon: const Icon(Icons.insights),
          label: progressLabel,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: profileLabel,
        ),
      ],
    );
  }
}

Future<bool> showAppDialog({
  required BuildContext context,
  required String title,
  required String confirmLabel,
  String? body,
  String? cancelLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title),
        content: body == null ? null : Text(body),
        actions: [
          if (cancelLabel != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(cancelLabel),
            ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirmLabel),
          ),
        ],
      );
    },
  );
  return result ?? false;
}
