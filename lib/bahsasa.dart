import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bahasa extends StatefulWidget {
  const Bahasa({super.key});

  @override
  State<Bahasa> createState() => _BahasaState();
}

class _BahasaState extends State<Bahasa> {
  List<Map<String, dynamic>> bahasaList = [];
  bool isLoading = true;

  Future<void> fetchBahasa() async {
    final response = await Supabase.instance.client
        .from('bahasa')
        .select('id, image, desc')
        .order('id', ascending: true);

    setState(() {
      bahasaList = List<Map<String, dynamic>>.from(response);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBahasa();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? const CircularProgressIndicator()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  spacing: 30,
                  runSpacing: 20,
                  alignment: WrapAlignment.center,
                  children: bahasaList.map((bahasa) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (bahasa['image'] != null && bahasa['image'] != "")
                          Image.network(
                            bahasa['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        const SizedBox(height: 6),
                        Text(
                          bahasa['desc'] ?? "",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bahasa yang dikuasai",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }
}
