import 'package:flutter/material.dart';

/// A premium, local-only fallback widget to display source-specific branding
/// when an article does not have a valid banner image.
class SourceFallbackImage extends StatelessWidget {
  /// The news source name (e.g. 'NDTV', 'The Hindu', 'Times of India', 'Indian Express', 'Al Jazeera').
  final String source;

  /// The height of the fallback card/area.
  final double height;

  /// The border radius of the fallback container.
  final BorderRadius? borderRadius;

  const SourceFallbackImage({
    super.key,
    required this.source,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final cleanSource = source.trim();
    final lowerSource = cleanSource.toLowerCase();

    List<Color> gradientColors;
    Widget logoWidget;

    // Determine the source-specific fallback presentation
    if (lowerSource.contains('ndtv')) {
      gradientColors = [const Color(0xFF1E0709), const Color(0xFF8B0000)];
      logoWidget = Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'NDTV',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'sans-serif',
              fontSize: 22,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(width: 4),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFFE50914), // NDTV Red Dot
              shape: BoxShape.circle,
            ),
          )
        ],
      );
    } else if (lowerSource.contains('hindu')) {
      gradientColors = [const Color(0xFF070F1E), const Color(0xFF0F2B5C)];
      logoWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'THE HINDU',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
              fontSize: 20,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 70,
            height: 2.0,
            color: const Color(0xFFD4AF37), // Gold accent bar
          ),
        ],
      );
    } else if (lowerSource.contains('times of india') || lowerSource == 'toi') {
      gradientColors = [const Color(0xFF1E293B), const Color(0xFF0B0F19)];
      logoWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'THE TIMES OF INDIA',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFF1C40F), // Premium gold text
              fontWeight: FontWeight.bold,
              fontFamily: 'serif',
              fontSize: 16,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'ESTD 1838',
            style: TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.w500,
              fontSize: 9,
              letterSpacing: 1.2,
            ),
          ),
        ],
      );
    } else if (lowerSource.contains('indian express')) {
      gradientColors = [const Color(0xFF051329), const Color(0xFF1A365D)];
      logoWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'The Indian EXPRESS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontFamily: 'sans-serif',
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'JOURNALISM OF COURAGE',
            style: TextStyle(
              color: Colors.redAccent.shade100,
              fontWeight: FontWeight.bold,
              fontSize: 8,
              letterSpacing: 1.5,
            ),
          ),
        ],
      );
    } else if (lowerSource.contains('al jazeera') || lowerSource.contains('jazeera')) {
      gradientColors = [const Color(0xFF2D1606), const Color(0xFF6B2D08)];
      logoWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'AL JAZEERA',
            style: TextStyle(
              color: Color(0xFFFDBA74), // Warm gold/orange text
              fontWeight: FontWeight.w900,
              fontSize: 20,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'ENGLISH',
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 10,
              letterSpacing: 3.0,
            ),
          ),
        ],
      );
    } else {
      // Unknown source / news / SatyaPress fallback
      gradientColors = [const Color(0xFF1E1145), const Color(0xFF4C1D95)];
      final fallbackTitle = cleanSource.isNotEmpty ? cleanSource : 'SatyaPress';
      logoWidget = Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.explore_outlined,
            size: 28,
            color: Color(0xFFC084FC), // Light purple
          ),
          const SizedBox(height: 8),
          Text(
            fallbackTitle.toUpperCase(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 18,
              letterSpacing: 2.0,
            ),
          ),
        ],
      );
    }

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Background soft watermark icon for luxury newspaper aesthetic
          Positioned(
            right: -15,
            bottom: -15,
            child: Icon(
              Icons.newspaper_rounded,
              size: height * 0.7,
              color: Colors.white.withValues(alpha: 0.04),
            ),
          ),
          Positioned(
            left: -10,
            top: -10,
            child: Container(
              width: height * 0.4,
              height: height * 0.4,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.015),
              ),
            ),
          ),
          // Centered branding logo/text content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: logoWidget,
            ),
          ),
        ],
      ),
    );
  }
}
