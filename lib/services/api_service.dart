import 'dart:convert';
import 'package:http/http.dart' as http;

class Student {
  final String id;
  final String nama;
  final int nim;
  final String jurusan;
  final String? email;
  final String? phone;
  final DateTime? createdAt;

  const Student({
    required this.id,
    required this.nama,
    required this.nim,
    required this.jurusan,
    this.email,
    this.phone,
    this.createdAt,
  });

  factory Student.fromJson(Map<String, dynamic> j) {
    DateTime? createdAt;
    if (j['createdAt'] != null) {
      if (j['createdAt'] is String) {
        createdAt = DateTime.tryParse(j['createdAt']);
      } else if (j['createdAt'] is int) {
        createdAt = DateTime.fromMillisecondsSinceEpoch(j['createdAt'] * 1000);
      }
    }

    return Student(
      id: j['id'].toString(),
      nama: j['nama'] as String,
      nim: j['nim'] as int,
      jurusan: j['jurusan'] as String,
      email: j['email'] as String?,
      phone: j['phone'] as String?,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nim': nim,
    'jurusan': jurusan,
    'createdAt': createdAt?.toIso8601String(),
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
  };
}

class ApiService {
  static const _mockApi = 'https://69ff436e2b7ab349602f6c88.mockapi.io';

  static Future<Map<String, dynamic>> saveFormData({
    required String nama,
    required int nim,
    required String jurusan,
    required String createdAt,
  }) async {
    final payload = {
      'nama': nama,
      'nim': nim,
      'jurusan': jurusan,
      'createdAt': createdAt,
    };

    final res = await http.post(
      Uri.parse('$_mockApi/students'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (res.statusCode == 201 || res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw Exception('Gagal menyimpan data: HTTP ${res.statusCode}');
  }

  static Future<List<Student>> fetchStudents() async {
    final res = await http.get(Uri.parse('$_mockApi/students'));
    if (res.statusCode == 200) {
      final list = jsonDecode(res.body) as List<dynamic>;
      return list.map((e) => Student.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('HTTP ${res.statusCode}');
  }
}