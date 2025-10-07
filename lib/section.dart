import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Section extends StatefulWidget {
  const Section({super.key});

  @override
  State<Section> createState() => _SectionState();
}

class _SectionState extends State<Section> {
  List<Map<String, dynamic>> aboutList = [];
  List<Map<String, dynamic>> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final aboutResponse = await Supabase.instance.client
          .from('names')
          .select('id, name, image');
      final contactResponse = await Supabase.instance.client
          .from('kontak')
          .select('id, image, url')
          .order('id', ascending: true);

      setState(() {
        aboutList = List<Map<String, dynamic>>.from(aboutResponse);
        contacts = List<Map<String, dynamic>>.from(contactResponse);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        aboutList = [];
        contacts = [];
        isLoading = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak bisa membuka $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (aboutList.isEmpty) {
      return const Center(child: Text("Tidak ada data"));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var item in aboutList) ...[
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    item['image'] ?? '',
                    height: 200,
                    width: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const SizedBox(
                        height: 200,
                        child: Center(child: Text("Gagal memuat gambar")),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                item['name'] ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 30),
            ],

            // Bagian Kontak
            const Text(
              "Hubungi Saya",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.amber,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              alignment: WrapAlignment.center,
              children: contacts.map((contact) {
                return InkWell(
                  onTap: () => _launchUrl(contact['url']),
                  child: Image.network(
                    contact['image'],
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.link,
                        color: Colors.amber,
                        size: 50,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
