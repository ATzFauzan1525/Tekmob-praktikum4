import 'package:flutter/material.dart';
import '../main.dart';
import '../services/api_service.dart';

class StudentDetailPage extends StatelessWidget {
  final Student student;
  const StudentDetailPage({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final nimForColor = (student.nim - 1);
    final colorIndex = nimForColor % AppColors.userColors.length;
    final color = AppColors.userColors[(colorIndex < 0 ? -colorIndex : colorIndex) % AppColors.userColors.length];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(Icons.arrow_back_ios_rounded,
                    size: 16, color: AppColors.blueDark),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.blueDark, AppColors.blue],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(28),
                    bottomRight: Radius.circular(28),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.blue.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 50),
                    Container(
                      width: 84,
                      height: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.blueBorder,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.7),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              _initials(student.nama),
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: color,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      student.nama,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'NIM ${student.nim}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student.jurusan,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                        letterSpacing: 0.3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(1),
              child: Container(height: 1, color: AppColors.border),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _section(
                  label: 'Identitas',
                  icon: Icons.badge_outlined,
                  children: [
                    _row(
                      icon: Icons.person_outline_rounded,
                      label: 'Nama',
                      value: student.nama,
                    ),
                    _divider(),
                    _row(
                      icon: Icons.confirmation_number_outlined,
                      label: 'NIM',
                      value: student.nim.toString(),
                    ),
                    _divider(),
                    _row(
                      icon: Icons.school_outlined,
                      label: 'Jurusan',
                      value: student.jurusan,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _section(
                  label: 'Metadata',
                  icon: Icons.info_outline_rounded,
                  children: [
                    _row(
                      icon: Icons.tag_outlined,
                      label: 'ID',
                      value: student.id,
                    ),
                    _divider(),
                    _row(
                      icon: Icons.schedule_outlined,
                      label: 'Dibuat Pada',
                      value: _formatDate(student.createdAt),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ]),
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _initials(String nama) {
    final parts = nama.split(' ').where((e) => e.trim().isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  Widget _section({
    required String label,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.blueSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blueBorder),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 14, color: AppColors.blueDark),
                const SizedBox(width: 8),
                Text(
                  label.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.blueDark,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: AppColors.blueBorder),
          ...children,
        ],
      ),
    );
  }

  Widget _row({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.blueDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.blueDark,
                    fontSize: 11,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppColors.textSecond,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        height: 1,
        margin: const EdgeInsets.only(left: 44),
        color: AppColors.blueBorder,
      );
}

