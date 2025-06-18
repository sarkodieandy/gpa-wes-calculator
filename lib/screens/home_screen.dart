import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/ad_services.dart';
import '../widgets/animated.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const poppins = GoogleFonts.poppins;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.1),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),

                // ⭐ App Logo
                Icon(
                      IconlyBold.star,
                      size: 100,
                      color: theme.colorScheme.primary,
                    )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(delay: 200.ms, curve: Curves.easeInOut),

                const SizedBox(height: 24),

                // 📘 Title
                Text(
                  'GPA & WES Calculator',
                  style: poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2),

                const Spacer(),

                // 📄 GPA Calculator Button
                AnimatedButton(
                  icon: IconlyLight.paper,
                  text: 'GPA Calculator',
                  onPressed: () => Navigator.pushNamed(context, '/gpa'),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.secondary,
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 🌍 WES Evaluation Button (Rewarded Ad Protected)
                AnimatedButton(
                  icon: IconlyLight.document,
                  text: 'WES Evaluation',
                  onPressed: () {
                    AdService.showRewardedAd(
                      onRewarded: () {
                        Navigator.pushNamed(
                          context,
                          '/wes',
                        ); // Unlocks on reward
                      },
                      onAdUnavailable: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Ad not ready. Please try again shortly.',
                              style: poppins(),
                            ),
                            backgroundColor: theme.colorScheme.error,
                          ),
                        );
                      },
                    );
                  },
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.secondary,
                      theme.colorScheme.primary,
                    ],
                  ),
                ),

                const Spacer(),

                // 🧾 Export PDF Button (Rewarded Ad Protected)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.primaryContainer.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        IconlyBold.download,
                        color: theme.colorScheme.primary,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Export to PDF (ads)',
                          style: poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          AdService.showRewardedAd(
                            onRewarded: () {
                              Navigator.pushNamed(
                                context,
                                '/pdf',
                              ); // Unlocks on reward
                            },
                            onAdUnavailable: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Ad not ready. Please try again shortly.',
                                    style: poppins(),
                                  ),
                                  backgroundColor: theme.colorScheme.error,
                                ),
                              );
                            },
                          );
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: theme.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Watch ads',
                          style: poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 1200.ms).slideY(begin: 0.3),

                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
