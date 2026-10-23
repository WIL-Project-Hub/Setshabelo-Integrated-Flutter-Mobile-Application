import 'package:flutter/material.dart';
import '../models/application.dart';
import '../models/school_content.dart';
import '../services/supabase_service.dart';

class ParentHomeViewModel extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  String _parentName = '';
  String get parentName => _parentName;

  List<Application> _applications = [];
  List<Application> get applications => _applications;

  List<SchoolUpdate> _recentUpdates = [];
  List<SchoolUpdate> get recentUpdates => _recentUpdates;

  List<Achievement> _recentAchievements = [];
  List<Achievement> get recentAchievements => _recentAchievements;

  // Stats
  int get totalApplications => _applications.length;
  int get pendingCount =>
      _applications.where((a) => a.applicationStatus == 'Pending').length;
  int get acceptedCount =>
      _applications.where((a) => a.applicationStatus == 'Accepted').length;
  int get rejectedCount =>
      _applications.where((a) => a.applicationStatus == 'Rejected').length;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Get Parent Profile
      final parentProfile = await _supabaseService.getParentProfile();

      if (parentProfile != null) {
        _parentName = parentProfile['first_name'] ?? 'Parent';

        // 2. Get Applications
        _applications =
            await _supabaseService.getMyApplications(parentProfile['parent_id']);
      }

      // 3. Get Updates & Achievements
      final updates = await _supabaseService.getSchoolUpdates();
      _recentUpdates = updates.take(3).toList();

      final achievements = await _supabaseService.getAchievements();
      _recentAchievements = achievements.take(3).toList();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
