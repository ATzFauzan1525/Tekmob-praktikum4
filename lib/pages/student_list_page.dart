import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'student_detail_page.dart';

class StudentListPage extends StatefulWidget {
  const StudentListPage({super.key});

  @override
  State<StudentListPage> createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  late Future<List<Student>> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchStudents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refresh() {
    setState(() => _future = ApiService.fetchStudents());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 8),
            Text('Memuat ulang data...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.blueDark,
        surfaceTintColor: Colors.transparent,
        title: const Text(
          'DAFTAR MAHASISWA',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              size: 18, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded,
                size: 20, color: Colors.white),
            onPressed: _refresh,
            tooltip: 'Muat ulang',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.blueBorder),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.blueDark,
                          strokeWidth: 2,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Memuat data...',
                          style: TextStyle(
                              color: AppColors.textMuted, fontSize: 13,
                              letterSpacing: 0.5),
                        ),
                      ],
                    ),
                  );
                }

                if (snap.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72, height: 72,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.border),
                            ),
                            child: const Icon(Icons.wifi_off_rounded,
                                color: AppColors.textMuted, size: 32),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Gagal Memuat Data',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${snap.error}',
                            style: const TextStyle(
                                color: AppColors.textMuted, fontSize: 12),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 46,
                            child: ElevatedButton.icon(
                              onPressed: _refresh,
                              icon: const Icon(Icons.refresh_rounded,
                                  size: 16, color: AppColors.background),
                              label: const Text('COBA LAGI'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (!snap.hasData) {
                  return const Center(
                    child: Text('Tidak ada data',
                        style: TextStyle(color: AppColors.textMuted)),
                  );
                }

                final students = snap.data!;

                if (students.isEmpty) {
                  return const Center(
                    child: Text('Tidak ada data mahasiswa',
                        style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  itemCount: students.length,
                  itemBuilder: (ctx, i) => _buildCard(ctx, students[i], i),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, Student student, int index) {
    final nimForColor = (student.nim - 1);
    final colorIndex = nimForColor % AppColors.userColors.length;
    final color = AppColors.userColors[(colorIndex < 0 ? -colorIndex : colorIndex) % AppColors.userColors.length];

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => StudentDetailPage(student: student)),
      ),
      onLongPress: () {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.school_outlined,
                    color: AppColors.blueDark, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${student.nama} · ${student.jurusan}',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
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
        child: Row(
          children: [
            // Avatar
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.25)),
              ),
              child: Center(
                child: Text(
                  _initials(student.nama),
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    student.nama,
                    style: const TextStyle(
                      color: AppColors.blueDark,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      const Icon(Icons.confirmation_number_outlined,
                          size: 11, color: AppColors.blueDark),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          'NIM ${student.nim}',
                          style: const TextStyle(
                              color: AppColors.blueDark, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.school_outlined,
                          size: 11, color: AppColors.blueDark),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          student.jurusan,
                          style: const TextStyle(
                              color: AppColors.blueDark, fontSize: 11),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Arrow button
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: AppColors.blueDark,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.blueBorder),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blueDark.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.arrow_forward_rounded,
                  size: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String nama) {
    final parts = nama.split(' ').where((e) => e.trim().isNotEmpty).toList();
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}