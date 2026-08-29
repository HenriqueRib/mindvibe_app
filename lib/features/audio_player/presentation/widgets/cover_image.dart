import 'package:flutter/material.dart';
import 'package:mindvibe_app/app/theme/app_theme.dart';
import 'package:mindvibe_app/core/network/media_url.dart';
import 'package:mindvibe_app/l10n/app_localizations.dart';

class CoverImage extends StatelessWidget {
  const CoverImage({
    super.key,
    this.url,
    this.size = 56,
    this.width,
    this.height,
    this.radius = 14,
    this.icon = Icons.graphic_eq_rounded,
    this.fit = BoxFit.cover,
    this.circular = false,
  });

  final String? url;
  final double size;
  final double? width;
  final double? height;
  final double radius;
  final IconData icon;
  final BoxFit fit;
  final bool circular;

  @override
  Widget build(BuildContext context) {
    final resolved = url == null || url!.isEmpty
        ? null
        : MediaUrl.resolve(url!);
    final iconSize = (height ?? size) * 0.42;
    final clipRadius = circular ? 999 : radius;
    return ClipRRect(
      borderRadius: BorderRadius.circular(clipRadius.toDouble()),
      child: SizedBox(
        width: width ?? size,
        height: height ?? size,
        child: resolved == null
            ? _placeholder(context, iconSize)
            : Image.network(
                resolved,
                fit: fit,
                width: width == double.infinity ? null : (width ?? size),
                height: height ?? size,
                errorBuilder: (context, error, stackTrace) =>
                    _placeholder(context, iconSize),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) {
                    return child;
                  }
                  return _placeholder(context, iconSize);
                },
              ),
      ),
    );
  }

  Widget _placeholder(BuildContext _, double iconSize) {
    return ColoredBox(
      color: AppColors.panel,
      child: Icon(icon, color: AppColors.gold, size: iconSize),
    );
  }
}

Future<void> showCoverLightbox(
  BuildContext context, {
  required String? url,
  required Object heroTag,
}) {
  return Navigator.of(context).push(
    PageRouteBuilder<void>(
      opaque: false,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.94),
      transitionDuration: const Duration(milliseconds: 280),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: _CoverLightbox(url: url, heroTag: heroTag),
        );
      },
    ),
  );
}

class _CoverLightbox extends StatelessWidget {
  const _CoverLightbox({required this.url, required this.heroTag});

  final String? url;
  final Object heroTag;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shortest = MediaQuery.sizeOf(context).shortestSide;

    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Hero(
                  tag: heroTag,
                  child: CoverImage(
                    url: url,
                    width: shortest - 24,
                    height: shortest - 24,
                    radius: 8,
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: IconButton(
                  tooltip: l10n.playerCoverExpand,
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close_rounded),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black.withValues(alpha: 0.35),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
