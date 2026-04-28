import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/decoder_graph.dart';

class DetectionScreen extends StatelessWidget {
  const DetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Real-Time Detection Feed', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Text('Click an alert to view extraction math', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic)),
            ],
          ),
          const SizedBox(height: 24),
          const Expanded(
            child: _DetectionList(),
          ),
        ],
      ),
    );
  }
}

class _DetectionList extends StatefulWidget {
  const _DetectionList();

  @override
  State<_DetectionList> createState() => _DetectionListState();
}

class _DetectionListState extends State<_DetectionList> {
  final List<Map<String, dynamic>> _alerts = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    firestoreService.alertStream.listen((alert) {
      if (mounted) {
        setState(() {
          _alerts.insert(0, alert);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_alerts.isEmpty) {
      return const Center(
        child: Text('Waiting for detections...', style: TextStyle(color: Colors.grey, fontSize: 18)),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        final alert = _alerts[index];
        final bool isReal = alert['isReal'] ?? false;
        
        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 500),
          tween: Tween<double>(begin: 0, end: 1),
          builder: (context, double val, child) {
            return Opacity(
              opacity: val,
              child: Transform.translate(
                offset: Offset(0, 50 * (1 - val)),
                child: child,
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isReal ? Colors.green.withOpacity(0.5) : Colors.transparent),
            ),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16),
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.warning, color: Colors.redAccent),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: isReal ? Colors.green : Colors.orange,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      isReal ? 'REAL' : 'SIMULATED', 
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)
                    ),
                  ),
                  Text('Piracy Detected on ${alert["platform"]}', style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Media: ${alert["media_type"]} | Confidence: ${alert["confidence"]}'),
              ),
              trailing: Chip(
                label: Text(alert["detected_user_id"], style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.redAccent,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AI Decoder Analysis:', 
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Extracting trajectory path from compressed video frames... The red dots represent extracted watermark points. The green line represents the expected mathematical Lissajous curve for the identified user session.',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 16),
                      DecoderGraph(sessionId: alert["detected_user_id"]),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Automated DMCA Takedown Notice generated and sent to platform legal team.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          icon: const Icon(Icons.gavel),
                          label: const Text('One-Click DMCA Takedown'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
