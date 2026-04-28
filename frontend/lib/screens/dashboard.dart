import 'package:flutter/material.dart';
import 'dart:async';
import 'overview.dart';
import 'streams.dart';
import 'detection.dart';
import 'analytics.dart';
import 'about.dart';
import '../services/firestore_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _isLiveMode = firestoreService.isLiveMode;
  late StreamSubscription _modeSub;

  @override
  void initState() {
    super.initState();
    firestoreService.startMocking();
    _modeSub = firestoreService.modeStream.listen((isLive) {
      if (mounted) {
        setState(() {
          _isLiveMode = isLive;
        });
        if (!isLive) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('⚠️ Using fallback data (API unavailable)'),
              backgroundColor: Colors.orange,
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Connected to live APIs!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _modeSub.cancel();
    firestoreService.stopMocking();
    super.dispose();
  }

  final List<Widget> _pages = [
    const OverviewScreen(),
    const StreamsScreen(),
    const DetectionScreen(),
    const AnalyticsScreen(),
    const AboutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Traceory AI Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 24, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _isLiveMode ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _isLiveMode ? Colors.green : Colors.orange),
            ),
            child: Row(
              children: [
                Icon(_isLiveMode ? Icons.circle : Icons.warning_amber_rounded, 
                     color: _isLiveMode ? Colors.green : Colors.orange, size: 16),
                const SizedBox(width: 8),
                Text(
                  _isLiveMode ? '🟢 Live AI Mode (Gemini Connected)' : '🟡 Demo Mode (Simulated AI)',
                  style: TextStyle(
                    color: _isLiveMode ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  labelType: NavigationRailLabelType.all,
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  destinations: const [
                    NavigationRailDestination(icon: Icon(Icons.dashboard_outlined), selectedIcon: Icon(Icons.dashboard), label: Text('Overview')),
                    NavigationRailDestination(icon: Icon(Icons.video_library_outlined), selectedIcon: Icon(Icons.video_library), label: Text('Streams')),
                    NavigationRailDestination(icon: Icon(Icons.security_outlined), selectedIcon: Icon(Icons.security), label: Text('Detection')),
                    NavigationRailDestination(icon: Icon(Icons.analytics_outlined), selectedIcon: Icon(Icons.analytics), label: Text('Analytics')),
                    NavigationRailDestination(icon: Icon(Icons.info_outline), selectedIcon: Icon(Icons.info), label: Text('About')),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8),
            color: Theme.of(context).colorScheme.surface,
            child: const Text(
              "“This system uses real AI APIs with fallback simulation to ensure reliability during live demonstrations.”",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
