
import 'package:flutter/material.dart';
import '../models/school_content.dart';
import '../services/supabase_service.dart';
import 'parent_home_screen.dart';

class UpdatesScreen extends StatefulWidget {
  const UpdatesScreen({super.key});

  @override
  State<UpdatesScreen> createState() => _UpdatesScreenState();
}

class _UpdatesScreenState extends State<UpdatesScreen> {
  final _supabaseService = SupabaseService();
  List<SchoolUpdate> _updates = [];
  bool _isLoading = true;

  static const Color schoolGreen = Color(0xFF2D873B);
  static const Color schoolDarkGreen = Color(0xFF1B4D3E);
  static const Color schoolLightGreen = Color(0xFFE2F3D2);
  static const Color schoolPaleGreen = Color(0xFFF3F8EF);

  @override
  void initState() {
    super.initState();
    _loadUpdates();
  }

  Future<void> _loadUpdates() async {
    setState(() => _isLoading = true);

    try {
      final updates = await _supabaseService.getSchoolUpdates();

      if (!mounted) return;
      setState(() => _updates = updates);
    } catch (e) {
      debugPrint('Error loading updates: $e');
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
          'School Updates',
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
              onRefresh: _loadUpdates,
              child: _updates.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            'No updates published yet.',
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
                      itemCount: _updates.length,
                      itemBuilder: (context, index) {
                        final update = _updates[index];

                        return Card(
                          color: schoolPaleGreen,
                          margin: const EdgeInsets.only(bottom: 16),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: const BorderSide(
                              color: schoolLightGreen,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  update.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: schoolDarkGreen,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  update.content,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    height: 1.5,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Icon(
                                      Icons.calendar_today,
                                      size: 14,
                                      color: schoolGreen,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${update.publishedAt.day}/${update.publishedAt.month}/${update.publishedAt.year}',
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
                        );
                      },
                    ),
            ),
    );
  }
}
