import 'dart:async';
import 'dart:math';

class FirestoreService {
  final StreamController<Map<String, dynamic>> _alertController = StreamController.broadcast();
  final StreamController<bool> _modeController = StreamController<bool>.broadcast();
  
  Timer? _timer;
  bool isLiveMode = false; // Start in Demo mode

  Stream<Map<String, dynamic>> get alertStream => _alertController.stream;
  Stream<bool> get modeStream => _modeController.stream;

  void startMocking() {
    final platforms = ["YouTube", "Twitch", "Twitter", "Telegram", "PirateStream", "Radio", "Screenshot"];
    final mediaTypes = ["Video", "Video", "Image", "Image", "Video", "Audio", "Image"];
    final random = Random();

    // Toggle live mode every 15 seconds to demonstrate the robust fallback UI
    Timer.periodic(const Duration(seconds: 15), (timer) {
      isLiveMode = !isLiveMode;
      _modeController.add(isLiveMode);
    });

    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      final idx = random.nextInt(platforms.length);
      // Simulate real API hits when in Live Mode
      final isReal = isLiveMode ? random.nextBool() : false; 
      
      final alert = {
        "platform": platforms[idx],
        "media_type": mediaTypes[idx],
        "detected_user_id": "User_${random.nextInt(9000) + 1000}",
        "timestamp": DateTime.now().toIso8601String(),
        "confidence": (0.85 + random.nextDouble() * 0.14).toStringAsFixed(2),
        "isReal": isReal,
      };
      _alertController.add(alert);
    });
  }

  void stopMocking() {
    _timer?.cancel();
  }
}

final firestoreService = FirestoreService();
