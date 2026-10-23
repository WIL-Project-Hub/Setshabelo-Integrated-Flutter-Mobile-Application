import 'package:flutter/material.dart';
import '../models/application.dart';
import '../services/supabase_service.dart';
import 'application_detail_screen.dart';
import 'parent_home_screen.dart';

class MyApplicationsScreen extends StatefulWidget {
  const MyApplicationsScreen({super.key});

  @override
  State<MyApplicationsScreen> createState() => _MyApplicationsScreenState();
}

class _MyApplicationsScreenState extends State<MyApplicationsScreen> {
  final _supabaseService = SupabaseService();
  List<Application> _applications = [];
  bool _isLoading = true;

  static const Color schoolGreen = Color(0xFF2D873B);
  static const Color schoolDarkGreen = Color(0xFF1B4D3E);
  static const Color schoolLightGreen = Color(0xFFE2F3D2);
  static const Color schoolPaleGreen = Color(0xFFF3F8EF);

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    try {
      final parent = await _supabaseService.getParentProfile();
      if (parent != null) {
        final apps = await _supabaseService.getMyApplications(parent['parent_id']);
        if (!mounted) return;
        setState(() => _applications = apps);
      }
    } catch (e) {
      debugPrint('Error loading apps: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Map<String, Color> _getStatusColors(String status) {
    switch (status) {
      case 'Accepted':
        return {'bg': const Color(0xFFD4EDDA), 'text': const Color(0xFF155724)};
      case 'Rejected':
        return {'bg': const Color(0xFFF8D7DA), 'text': const Color(0xFF721C24)};
      case 'Under Review':
        return {'bg': const Color(0xFFD1ECF1), 'text': const Color(0xFF0C5460)};
      default: // Pending
        return {'bg': const Color(0xFFFFF3CD), 'text': const Color(0xFF856404)};
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
          'My Applications',
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
              onRefresh: _loadApplications,
              child: _applications.isEmpty
                  ? ListView(
                      children: const [
                        SizedBox(height: 100),
                        Center(
                          child: Text(
                            'No applications submitted yet.',
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
                      itemCount: _applications.length,
                      itemBuilder: (context, index) {
                        final app = _applications[index];
                        final colors = _getStatusColors(app.applicationStatus);

                        return Card(
                          color: schoolPaleGreen,
                          margin: const EdgeInsets.only(bottom: 12),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(
                              color: schoolLightGreen,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            title: Text(
                              app.childFullName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: schoolDarkGreen,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(
                                  'Grade: ${app.gradeApplyingFor}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: colors['bg'],
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        app.applicationStatus,
                                        style: TextStyle(
                                          color: colors['text'],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      app.submissionDate != null
                                          ? '${app.submissionDate!.day}/${app.submissionDate!.month}/${app.submissionDate!.year}'
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: const Icon(
                              Icons.chevron_right,
                              color: schoolDarkGreen,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ApplicationDetailScreen(
                                    application: app,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}
