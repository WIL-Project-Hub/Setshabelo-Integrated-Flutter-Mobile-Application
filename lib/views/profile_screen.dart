import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import 'login_screen.dart';

const Color schoolGreen = Color(0xFF2D873B);
const Color schoolDarkGreen = Color(0xFF1B4D3E);
const Color schoolPaleGreen = Color(0xFFF3F8EF);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _supabaseService = SupabaseService();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  String _email = '';
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    try {
      final parent = await _supabaseService.getParentProfile();

      if (parent != null) {
        _firstNameController.text = parent['first_name'] ?? '';
        _lastNameController.text = parent['last_name'] ?? '';
        _email = _supabaseService.currentUser?.email ?? '';
        _emailController.text = _email;
      }
    } catch (e) {
      debugPrint('Error loading profile: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveProfile() async {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('First name and last name cannot be empty.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final success = await _supabaseService.updateParentProfile(
        _firstNameController.text.trim(),
        _lastNameController.text.trim(),
      );

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: schoolGreen,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to update profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to update profile. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _logout() async {
    await _supabaseService.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: schoolGreen),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16),

            // Profile avatar
            Center(
              child: Container(
                width: 104,
                height: 104,
                decoration: BoxDecoration(
                  color: schoolPaleGreen,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFD0E4D5),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 58,
                  color: schoolDarkGreen,
                ),
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'My Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: schoolDarkGreen,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              'Manage your account details',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),

            const SizedBox(height: 28),

            // Profile form
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFD0E4D5),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Account Information',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: schoolDarkGreen,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Read-only email
                  TextField(
                    controller: _emailController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email Address',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: schoolDarkGreen,
                      ),
                      helperText: 'Email cannot be changed here.',
                      filled: true,
                      fillColor: schoolPaleGreen,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD0E4D5),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // First name
                  TextField(
                    controller: _firstNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: schoolDarkGreen,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD0E4D5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: schoolGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Last name
                  TextField(
                    controller: _lastNameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: schoolDarkGreen,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFFD0E4D5),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: schoolGreen,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Save changes
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: schoolGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: schoolGreen.withValues(
                          alpha: 0.6,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 21,
                              height: 21,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Divider(color: Color(0xFFE2E8E0)),

            const SizedBox(height: 12),

            // Logout
            OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: schoolDarkGreen,
                side: const BorderSide(
                  color: schoolDarkGreen,
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
