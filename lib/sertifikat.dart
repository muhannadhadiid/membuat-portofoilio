import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Sertifikat extends StatefulWidget {
  const Sertifikat({super.key});

  @override
  State<Sertifikat> createState() => _SertifikatState();
}

class _SertifikatState extends State<Sertifikat> {
  List<Map<String, dynamic>> sertifikatList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSertifikat();
  }

  Future<void> fetchSertifikat() async {
    try {
      final response = await Supabase.instance.client
          .from('sertifikat')
          .select();
      setState(() {
        sertifikatList = List<Map<String, dynamic>>.from(response);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        sertifikatList = [];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (sertifikatList.isEmpty) {
      return const Center(child: Text("Tidak ada sertifikat"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Sertifikat Saya",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              for (var item in sertifikatList)
                _buildCertificate(item['image'], item['desc']),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificate(String path, String title) {
    return Card(
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                path,
                height: 200,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text("Gagal memuat gambar")),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
