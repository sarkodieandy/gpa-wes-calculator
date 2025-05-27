import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../widgets/feature_list_tile.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  late BannerAd _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _bannerAd = BannerAd(
      adUnitId:
          'ca-app-pub-5462334042904965/2784557347', // Replace with your real AdMob ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Features')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.star, size: 64, color: Colors.amber),
                    SizedBox(height: 16),
                    Text(
                      'App Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    FeatureListTile(
                      icon: Icons.picture_as_pdf,
                      title: 'Export to PDF',
                      subtitle:
                          'Save your GPA reports as PDF files — now free!',
                    ),
                    FeatureListTile(
                      icon: Icons.history,
                      title: 'Save History',
                      subtitle: 'Keep track of all your calculations',
                    ),
                    FeatureListTile(
                      icon: Icons.ad_units,
                      title: 'Supported by Ads',
                      subtitle: 'Enjoy full access with ads to support us',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_isAdLoaded)
              SizedBox(height: 50, child: AdWidget(ad: _bannerAd)),
          ],
        ),
      ),
    );
  }
}
