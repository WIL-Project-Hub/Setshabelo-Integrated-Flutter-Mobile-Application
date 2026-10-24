import 'package:flutter/material.dart';
import '../models/school_content.dart';
import '../services/supabase_service.dart';
import 'parent_home_screen.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen> {
  final _supabaseService = SupabaseService();
  List<Achievement> _achievements = [];
  bool _isLoading = true;

  static const Color schoolGreen = Color(0xFF2D873B);
  static const Color schoolDarkGreen = Color(0xFF1B4D3E);
  static const Color schoolLightGreen = Color(0xFFE2F3D2);
  static const Color schoolPaleGreen = Color(0xFFF3F8EF);

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    setState(() => _isLoading = true);

    try {
      final achievements = await _supabaseService.getAchievements();

      if (!mounted) return;
      setState(() => _achievements = achievements);
    } catch (e) {
      debugPrint('Error loading achievements: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back to Parent Home',
          onPressed: () => parentTabNotifier.value = 0,
        ),
        title: const Text(
          'Achievements',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: schoolDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: schoolGreen,
              ),
            )
          : RefreshIndicator(
              color: schoolGreen,
              onRefresh: _loadAchievements,
              child: _achievements.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            'No achievements posted yet.',
                            style: TextStyle(
                              fontSize: 15,
                              color: schoolDarkGreen,
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _achievements.length,
                      itemBuilder: (context, index) {
                        final achievement = _achievements[index];

                        return Card(
                          color: schoolPaleGreen,
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 1,
                          clipBehavior: Clip.antiAlias,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                              color: schoolLightGreen,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Optional image
                              if (achievement.imageUrl != null &&
                                  achievement.imageUrl!.isNotEmpty)
                                Image.network(
                                  achievement.imageUrl!,
                                  width: double.infinity,
                                  height: 220,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 180,
                                    color: schoolLightGreen,
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 40,
                                      color: schoolGreen,
                                    ),
                                  ),
                                ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      achievement.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: schoolDarkGreen,
                                      ),
                                    ),
                                    if (achievement.description != null &&
                                        achievement.description!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        achievement.description!,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          height: 1.5,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.end,
                                      children: [
                                        const Icon(
                                          Icons.calendar_today,
                                          size: 14,
                                          color: schoolGreen,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${achievement.publishedAt.day}/${achievement.publishedAt.month}/${achievement.publishedAt.year}',
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: schoolDarkGreen,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
