import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/parent_home_viewmodel.dart';
import 'my_applications_screen.dart';
import 'updates_screen.dart';
import 'achievements_screen.dart';
import 'application_wizard_screen.dart';
import 'profile_screen.dart';

const Color schoolGreen = Color(0xFF2D873B);
const Color schoolDarkGreen = Color(0xFF1B4D3E);
const Color schoolLightGreen = Color(0xFFE2F3D2);
const Color schoolPaleGreen = Color(0xFFF3F8EF);

// ValueNotifier for tab switching across the app
final ValueNotifier<int> parentTabNotifier = ValueNotifier<int>(0);

class ParentHomeScreen extends StatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  State<ParentHomeScreen> createState() => ParentHomeScreenState();
}

class ParentHomeScreenState extends State<ParentHomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const _DashboardContent(),
    const MyApplicationsScreen(),
    const UpdatesScreen(),
    const AchievementsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    parentTabNotifier.addListener(_onTabChange);
    _currentIndex = parentTabNotifier.value;
  }

  @override
  void dispose() {
    parentTabNotifier.removeListener(_onTabChange);
    super.dispose();
  }

  void _onTabChange() {
    if (!mounted) return;
    setState(() => _currentIndex = parentTabNotifier.value);
  }

  void switchTab(int index) {
    parentTabNotifier.value = index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: schoolLightGreen,
      appBar: AppBar(
        title: const Text(
          'Setshabelo',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: schoolDarkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          parentTabNotifier.value = index;
        },
        backgroundColor: Colors.white,
        selectedItemColor: schoolGreen,
        unselectedItemColor: Colors.grey.shade600,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Apps'),
          BottomNavigationBarItem(icon: Icon(Icons.campaign), label: 'Updates'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Awards'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _DashboardContent extends StatefulWidget {
  const _DashboardContent();

  @override
  State<_DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<_DashboardContent> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ParentHomeViewModel>(
        context,
        listen: false,
      ).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ParentHomeViewModel>(context);

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: schoolGreen),
      );
    }

    return Container(
      color: schoolLightGreen,
      child: RefreshIndicator(
        color: schoolGreen,
        onRefresh: () => vm.loadData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: schoolGreen,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vm.parentName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Here is a summary of your applications and school news.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Clickable Action Cards
              Row(
                children: [
                  _buildActionCard(
                    title: 'Apply',
                    icon: Icons.add_circle_outline,
                    color: Colors.blue.shade700,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ApplicationWizardScreen(),
                        ),
                      );
                      if (!mounted) return;
                      vm.loadData();
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildActionCard(
                    title: 'My Apps',
                    icon: Icons.list_alt,
                    color: Colors.orange.shade800,
                    onTap: () => parentTabNotifier.value = 1,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildActionCard(
                    title: 'Updates',
                    icon: Icons.campaign_outlined,
                    color: schoolDarkGreen,
                    onTap: () => parentTabNotifier.value = 2,
                  ),
                  const SizedBox(width: 12),
                  _buildActionCard(
                    title: 'Awards',
                    icon: Icons.emoji_events_outlined,
                    color: Colors.amber.shade800,
                    onTap: () => parentTabNotifier.value = 3,
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _buildSectionHeader('Recent School Updates'),
              const SizedBox(height: 12),

              if (vm.recentUpdates.isEmpty)
                _buildEmptyState('No updates yet.')
              else
                ...vm.recentUpdates.map(
                  (u) => Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Color(0xFFD0E4C5),
                      ),
                    ),
                    child: ListTile(
                      leading: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: schoolLightGreen,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.campaign_outlined,
                          color: schoolDarkGreen,
                        ),
                      ),
                      title: Text(
                        u.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: schoolDarkGreen,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            u.content,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${u.publishedAt.day}/${u.publishedAt.month}/${u.publishedAt.year}',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: schoolDarkGreen,
            width: 1,
          ),
        ),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: schoolDarkGreen,
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      alignment: Alignment.center,
      child: Text(
        message,
        style: TextStyle(
          color: schoolDarkGreen.withValues(alpha: 0.55),
          fontSize: 14,
        ),
      ),
    );
  }
}
