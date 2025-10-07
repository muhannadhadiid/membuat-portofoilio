import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_application_1/bahsasa.dart';
import 'package:flutter_application_1/colors/sky_painter.dart';
import 'package:flutter_application_1/section.dart';
import 'project.dart';
import 'sertifikat.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage>
    with SingleTickerProviderStateMixin {
  String selected = "Tentang Saya";
  late AnimationController _controller;
  final supabase = Supabase.instance.client;

  final List<Map<String, dynamic>> menu = [
    {"icon": Icons.person, "label": "Tentang Saya"},
    {"icon": Icons.work, "label": "Proyek"},
    {"icon": Icons.language, "label": "Bahasa"},
    {"icon": Icons.school, "label": "Sertifikat"},
    {"icon": Icons.school, "label": "Api"},
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get selectedIndex => menu.indexWhere((item) => item["label"] == selected);

  Future<String?> getLogoUrl() async {
    final response = await supabase
        .from('mee')
        .select('image')
        .eq('id', 1)
        .single();
    return response['image'] as String?;
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight = MediaQuery.of(context).size.height * 0.08;

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, __) {
              return CustomPaint(
                size: MediaQuery.of(context).size,
                painter: SkyPainter(_controller.value),
              );
            },
          ),
          Column(
            children: [
              Container(
                height: appBarHeight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C).withOpacity(0.8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    FutureBuilder<String?>(
                      future: getLogoUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          );
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return const Icon(Icons.error, color: Colors.red);
                        }
                        return Image.network(snapshot.data!, height: 28);
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "Portofolio",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const Spacer(),
                    for (var i = 0; i < menu.length; i++)
                      _buildMenuItem(menu[i], i),
                  ],
                ),
              ),
              Expanded(
                child: IndexedStack(
                  index: selectedIndex,
                  children: const [
                    Section(),
                    Project(),
                    Bahasa(),
                    Sertifikat(),
                    ApiExample(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(Map<String, dynamic> item, int index) {
    bool isSelected = selected == item["label"];
    return InkWell(
      onTap: () => setState(() => selected = item["label"]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(
                color: isSelected ? Colors.amber : Colors.white,
                fontWeight: FontWeight.w600,
              ),
              child: Text(item["label"]),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 3,
              width: isSelected ? 20 : 0,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
