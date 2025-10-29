import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _quoteController;
  late AnimationController _loaderController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _quoteOpacity;
  late Animation<Offset> _quoteSlide;

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Text animation controller
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Quote animation controller
    _quoteController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Loader animation controller (continuous)
    _loaderController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    // Logo animations
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.elasticOut,
      ),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Text animations
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeIn,
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Quote animations
    _quoteOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _quoteController,
        curve: Curves.easeIn,
      ),
    );

    _quoteSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _quoteController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Start animation sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Start logo animation
    _logoController.forward();

    // Wait for logo animation to be halfway done, then start text
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();

    // Wait a bit more, then start quote
    await Future.delayed(const Duration(milliseconds: 400));
    _quoteController.forward();

    // Navigate to home after all animations complete
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _quoteController.dispose();
    _loaderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    Colors.black,
                    const Color(0xFF0D0D0D),
                    const Color(0xFF1A1A1A),
                  ]
                : [
                    colorScheme.primary.withValues(alpha: 0.1),
                    colorScheme.surface,
                    colorScheme.primaryContainer.withValues(alpha: 0.3),
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo/icon
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _logoOpacity.value,
                        child: Transform.scale(
                          scale: _logoScale.value,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(alpha: 0.3),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(20),
                            child: Image.asset(
                              'assets/icons/SpenditLogo.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated app name
                  AnimatedBuilder(
                    animation: _textController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _textSlide,
                        child: Opacity(
                          opacity: _textOpacity.value,
                          child: Column(
                            children: [
                              Text(
                                'SpendIt',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Track Every Penny',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Money loader animation
                  AnimatedBuilder(
                    animation: _loaderController,
                    builder: (context, child) {
                      return SizedBox(
                        height: 40,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            final delay = index * 0.2;
                            final animValue = (_loaderController.value - delay) % 1.0;
                            final offsetY = (animValue < 0.5
                                    ? animValue * 2
                                    : (1 - animValue) * 2) *
                                -20;

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Transform.translate(
                                offset: Offset(0, offsetY),
                                child: Icon(
                                  Icons.monetization_on,
                                  size: 20,
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.3 + (animValue * 0.7),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // Animated quote
                  AnimatedBuilder(
                    animation: _quoteController,
                    builder: (context, child) {
                      return SlideTransition(
                        position: _quoteSlide,
                        child: Opacity(
                          opacity: _quoteOpacity.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : colorScheme.primary.withValues(alpha: 0.05),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.1)
                                    : colorScheme.primary.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.format_quote,
                                  color: colorScheme.primary,
                                  size: 28,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Beware of little expenses;\na small leak will sink a great ship.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontStyle: FontStyle.italic,
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : Colors.black87,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  '— Benjamin Franklin',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
