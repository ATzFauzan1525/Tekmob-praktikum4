import 'package:flutter/material.dart';
import '../main.dart';
import 'form_page.dart';
import 'student_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero header
            SliverToBoxAdapter(
              child: _buildHero(context),
            ),
            // Stats
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildStats()),
            ),
            // Section label
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              sliver: SliverToBoxAdapter(
                child: _buildSectionLabel('Menu Navigasi'),
              ),
            ),
            // Menu cards
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildMenuButton(
                    context,
                    icon: Icons.edit_note_rounded,
                    title: 'Form Input Data',
                    subtitle: 'Isi dan validasi data pengguna',
                    onPressed: () => _push(context, const FormPage()),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuButton(
                    context,
                    icon: Icons.school_outlined,
                    title: 'Daftar Mahasiswa',
                    subtitle: 'Data mahasiswa dari MockAPI',
                    onPressed: () => _push(context, const StudentListPage()),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _push(BuildContext ctx, Widget page) {
    Navigator.push(ctx, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.blueDark,
            AppColors.blue,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.cyanLight, AppColors.blueLight],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.cyanBorder),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.16),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 6, height: 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.cyan,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cyan.withValues(alpha: 0.5),
                          blurRadius: 8,
                          spreadRadius: 0.5,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 7),
                Text(
                  'LIVE · MOCKAPI',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Student Management\nApp',
            style: TextStyle(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w800,
              height: 1.0,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Kelola Data · Input Form · Lihat Daftar',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 28),
          // Divider line with blue gradient
          Container(
            width: 60,
            height: 3,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.cyan, AppColors.blueLight],
              ),
              borderRadius: BorderRadius.circular(2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Row(
        children: [
          _statCard('2', 'Halaman', Icons.pages_rounded),
          const SizedBox(width: 12),
          _statCard('API', 'Live', Icons.wifi_rounded),
          const SizedBox(width: 12),
          _statCard('Form', 'Validasi', Icons.check_circle_rounded),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: AppColors.blueDark,
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.blueDark,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
                fontFamily: 'monospace',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3,
          height: 14,
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.surface.withValues(alpha: 0.98),
            AppColors.surfaceAlt.withValues(alpha: 0.92),
          ],
        ),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.9)),
        boxShadow: [
          BoxShadow(
            color: AppColors.surfaceAlt.withValues(alpha: 0.26),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.surface.withValues(alpha: 0.10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: onPressed,
          splashColor: AppColors.blue.withValues(alpha: 0.12),
          highlightColor: AppColors.blue.withValues(alpha: 0.06),
          child: SizedBox(
            width: double.infinity,
            height: 92,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.blueDark,
                          AppColors.blue,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.blueBorder, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.blue.withValues(alpha: 0.22),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(icon, color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textMuted),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}