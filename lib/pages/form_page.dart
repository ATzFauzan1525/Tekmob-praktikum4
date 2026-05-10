import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../main.dart';
import '../services/api_service.dart';
import 'student_list_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl     = TextEditingController();
  final _nimCtrl      = TextEditingController();
  final _jurusanCtrl  = TextEditingController();
  final _createdAtCtrl = TextEditingController();

  DateTime? _selectedDate;
  DateTime? _createdAt;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nimCtrl.dispose();
    _jurusanCtrl.dispose();
    _createdAtCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Simpan tanpa timezone supaya tanggal tidak bergeser.
        _createdAt = DateTime(picked.year, picked.month, picked.day);
        _createdAtCtrl.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    try {
      final savedName = _nameCtrl.text;
      final savedNim = _nimCtrl.text;

      // Send data to API
      await ApiService.saveFormData(
        nama: savedName,
        nim: int.parse(savedNim),
        jurusan: _jurusanCtrl.text,
        // Jam mengikuti waktu saat tombol SIMPAN DATA ditekan.
        createdAt: (_createdAt ?? DateTime.now()).copyWith(
          hour: DateTime.now().hour,
          minute: DateTime.now().minute,
          second: DateTime.now().second,
        ).toIso8601String(),

      );
      
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      _reset();
      
      // Show success dialog with the saved values
      _showSuccess(savedName, savedNim);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      
      // Show error dialog
      _showError(e.toString());
    }
  }

  void _reset() {
    if (!mounted) return;

    setState(() {
      _formKey.currentState?.reset();
      _nameCtrl.text = '';
      _nimCtrl.text = '';
      _jurusanCtrl.text = '';
      _createdAtCtrl.text = '';
      _selectedDate = null;
      _createdAt = null;
    });

    FocusScope.of(context).unfocus();
  }

  void _showSuccess(String savedName, String savedNim) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppColors.goldSurface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.goldBorder, width: 1.5),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: AppColors.gold,
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Data Mahasiswa Tersimpan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$savedName (NIM: $savedNim) berhasil disimpan ke MockAPI.',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _reset();
                        },
                        child: const Text('INPUT LAGI'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StudentListPage()),
                          );
                        },
                        child: const Text('LIHAT DAFTAR'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showError(String message) {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFF3D1F1F),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF8C3A3A), width: 1.5),
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Color(0xFFE85A5A),
                  size: 36,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gagal Menyimpan',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message.replaceAll('Exception: ', ''),
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('COBA LAGI'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('FORM DATA'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppColors.border),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.blue, AppColors.cyan],
                    ),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.blueBorder),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.blue.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.cyanBorder),
                        ),
                        child: const Icon(Icons.person_add_outlined,
                            color: AppColors.cyan, size: 24),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Isi Data Mahasiswa',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: 3),
                            Text(
                              'Isi form dengan cepat dan mudah.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                _sectionLabel('Data Mahasiswa'),
                const SizedBox(height: 14),

                _fieldLabel('Nama Lengkap'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama lengkap',
                    prefixIcon: Icon(Icons.person_outline_rounded, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Nama tidak boleh kosong';
                    if (v.trim().length < 3) return 'Nama minimal 3 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _fieldLabel('NIM'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nimCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    hintText: '2304411001',
                    prefixIcon: Icon(Icons.confirmation_number_outlined, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'NIM tidak boleh kosong';
                    if (v.length < 9 || v.length > 12) return 'NIM harus 9-12 digit';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _fieldLabel('Jurusan'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _jurusanCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    hintText: 'Sistem Informasi',
                    prefixIcon: Icon(Icons.school_outlined, size: 20),
                  ),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Jurusan tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _fieldLabel('Tanggal Dibuat'),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _createdAtCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  readOnly: true,
                  onTap: _pickDate,
                  decoration: const InputDecoration(
                    hintText: 'Pilih tanggal',
                    prefixIcon: Icon(Icons.calendar_today_outlined, size: 20),
                  ),
                  validator: (v) {
                    if (_createdAt == null) return 'Tanggal dibuat tidak boleh kosong';
                    return null;
                  },
                ),
                const SizedBox(height: 36),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(Icons.refresh_rounded, size: 16),
                          label: const Text('RESET'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _submit,
                          icon: _isSubmitting
                              ? const SizedBox(
                                  width: 16, height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppColors.background,
                                  ),
                                )
                              : const Icon(Icons.check_rounded, size: 18,
                                  color: AppColors.background),
                          label: Text(_isSubmitting ? 'MENYIMPAN...' : 'SIMPAN DATA'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Row(
      children: [
        Container(
          width: 3, height: 14,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.blue, AppColors.cyan],
            ),
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

  Widget _fieldLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecond,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}