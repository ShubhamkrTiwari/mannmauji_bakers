import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BakeryImagePlaceholder extends StatelessWidget {
  final String heroTag;
  final String title;
  final String? imageUrl;
  final String emoji;
  final double? height;
  final double? width;
  final BorderRadius? borderRadius;

  const BakeryImagePlaceholder({
    super.key,
    required this.heroTag,
    required this.title,
    this.imageUrl,
    this.emoji = '🍰',
    this.height,
    this.width,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    Widget content = Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [AppColors.darkSurface, AppColors.darkCard]
              : [const Color(0xFFF7F0EA), const Color(0xFFEFE5DC)],
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: -10,
            bottom: -10,
            child: Text(
              emoji,
              style: TextStyle(
                fontSize: 70,
                color: (isDark ? Colors.white : AppColors.zeptoPurple).withValues(alpha: 0.12),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppColors.zeptoTextPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (heroTag.isNotEmpty) {
      return Hero(
        tag: heroTag,
        child: Material(
          color: Colors.transparent,
          child: content,
        ),
      );
    }
    return content;
  }
}
