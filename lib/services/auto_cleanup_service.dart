import 'dart:async';
import 'dart:developer';
import 'package:flutter_todo_web/services/firestore_service.dart';

class AutoCleanupService {
  static final AutoCleanupService _instance = AutoCleanupService._internal();
  factory AutoCleanupService() => _instance;
  AutoCleanupService._internal();

  Timer? _cleanupTimer;
  final FirestoreService _firestoreService = FirestoreService();

  void startAutoCleanup() {
    stopAutoCleanup();
    _performCleanup();
    
    _cleanupTimer = Timer.periodic(
      const Duration(hours: 24),
      (_) => _performCleanup(),
    );
  }

  void stopAutoCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
  }

  Future<void> _performCleanup() async {
    try {
      await _firestoreService.performAutoCleanup();
    } catch (e) {
     log('Auto-cleanup service error: $e');
    }
  }
  
  Future<void> triggerCleanup() async {
    await _performCleanup();
  }
}
