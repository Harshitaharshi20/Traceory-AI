import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('About Traceory AI', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Project Overview', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    Text(
                      'Traceory AI is an AI-powered digital asset protection platform designed to detect and trace pirated content using dynamic trajectory-based watermarking. Built for the Google Solution Challenge, our mission is to empower content owners—from independent creators to large broadcasters—with accessible, real-time protection without relying on massive infrastructure.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 32),
                    Text('Core Technology', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    _buildTechItem(context, Icons.analytics, 'Dynamic Watermarking', 'Invisible Lissajous curve trajectories tied to unique user session IDs.'),
                    _buildTechItem(context, Icons.visibility, 'Scene-Aware Embedding', 'Simulated Gemini Vision AI integration to intelligently place watermarks in undetectable zones like crowds or grass.'),
                    _buildTechItem(context, Icons.radar, 'Real-Time Detection', 'Simulated cross-platform piracy tracking fed directly into a live Firebase stream.'),
                    const SizedBox(height: 32),
                    Text('The Stack', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildChip(context, 'Flutter Web'),
                        _buildChip(context, 'Google Cloud Run'),
                        _buildChip(context, 'Python / FastAPI'),
                        _buildChip(context, 'Firebase Firestore'),
                        _buildChip(context, 'Gemini AI (Simulated)'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text('System Architecture', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(8)),
                      child: const Text(
                        '1. Upload Video -> FastAPI Backend\n'
                        '2. Gemini Vision API -> Analyzes frame for safe zones\n'
                        '3. Trajectory Engine -> Generates Lissajous math path\n'
                        '4. Flutter Web Client -> Renders Canvas Watermark\n'
                        '5. Detection Service -> Web Search + ML Extraction\n'
                        '6. Firebase -> Real-time alert push to Dashboard',
                        style: TextStyle(fontFamily: 'monospace', height: 1.5, color: Colors.greenAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(BuildContext context, IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.secondary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text(desc, style: TextStyle(color: Colors.grey.shade400, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.3)),
    );
  }
}
