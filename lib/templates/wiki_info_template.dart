import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/language_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WikiInfoTemplate extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;
  final List<Map<String, dynamic>> attractions;
  final List<Map<String, dynamic>> cultures;
  final Map<String, String> emergencies;

  const WikiInfoTemplate({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.attractions,
    required this.cultures,
    required this.emergencies,
  });

  @override
  State<WikiInfoTemplate> createState() => _WikiInfoTemplateState();
}

class _WikiInfoTemplateState extends State<WikiInfoTemplate> {
  int selectedSegment = 0;

  final List<String> segmentKeys = [
    "wiki_tab_attractions",
    "wiki_tab_culture",
    "wiki_tab_emergency"
  ];

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// IMAGE
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  height: 220,
                  width: 320,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 220,
                    width: 320,
                    color: const Color(0xFFF1F5F9),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 220,
                    width: 320,
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey, size: 40),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ABOUT CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lang.t('wiki_about_label', params: {'title': widget.title}),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.description),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// SEGMENTED CONTROL
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: List.generate(segmentKeys.length, (index) {
                    final isSelected = selectedSegment == index;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedSegment = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: isSelected
                                ? [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              )
                            ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              lang.t(segmentKeys[index]),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.black87
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// DYNAMIC SEGMENT CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: selectedSegment == 0
                      ? attractionsContent(lang)
                      : selectedSegment == 1
                      ? cultureContent(lang)
                      : emergencyContent(lang),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ===== CONTENT FUNCTIONS =====

  Widget attractionsContent(LanguageService lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.star, color: Colors.yellow),
            const SizedBox(width: 8),
            Text(
              lang.t('wiki_top_locations'),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...widget.attractions.map((place) {
          return Column(
            children: [
              infoCard(
                lang.t(place['name'] as String),
                List<String>.from(place['tips']).map((tip) => lang.t(tip)).toList(),
                Icons.place,
                Colors.green,
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget cultureContent(LanguageService lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.t('wiki_cultural_highlights'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.cultures.map((item) {
          return Column(
            children: [
              infoCard(
                lang.t(item['name'] as String),
                List<String>.from(item['details']).map((det) => lang.t(det)).toList(),
                Icons.auto_awesome,
                Colors.purple,
              ),
              const SizedBox(height: 12),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget emergencyContent(LanguageService lang) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.t('wiki_emergency_numbers'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...widget.emergencies.entries.map((entry) {
          IconData icon;
          Color color;

          // Tentukan icon & warna sesuai jenis
          if (entry.key.toLowerCase().contains('police')) {
            icon = Icons.local_police;
            color = Colors.blue;
          } else if (entry.key.toLowerCase().contains('medical') ||
              entry.key.toLowerCase().contains('ambulance')) {
            icon = Icons.medical_services;
            color = Colors.red;
          } else if (entry.key.toLowerCase().contains('fire')) {
            icon = Icons.local_fire_department;
            color = Colors.orange;
          } else if (entry.key.toLowerCase().contains('sar') ||
              entry.key.toLowerCase().contains('search')) {
            icon = Icons.saved_search;
            color = Colors.teal;
          } else {
            icon = Icons.phone;
            color = Colors.grey;
          }

          return Column(
            children: [
              emergencyCard(entry.key, entry.value, icon, color),
              const SizedBox(height: 8),
            ],
          );
        }).toList(),
      ],
    );
  }

  // ===== WIDGET HELPERS =====

  Widget infoCard(
      String title, List<String> items, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color.withOpacity(0.85),
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...items
              .map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("• ",
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.bold)),
                  Expanded(
                      child: Text(e,
                          style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          )
              .toList(),
        ],
      ),
    );
  }

  Widget emergencyCard(
      String label, String number, IconData icon, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}