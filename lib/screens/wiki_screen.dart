import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import '../templates/wiki_info_template.dart';
import 'language_service.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class WikiScreen extends StatefulWidget {
  const WikiScreen({super.key});

  @override
  State<WikiScreen> createState() => _WikiScreenState();
}

class _WikiScreenState extends State<WikiScreen> {
  final List<String> dropdownValues = [
    "ALL",
    "BALI",
    "YOGYAKARTA",
    "JAKARTA",
    "RAJA_AMPAT"
  ];

  String selectedDestinationKey = "ALL";

  // ===== DATA ATTRACTIONS =====
  // Keys menggunakan translation key, tips juga menggunakan translation key
  Map<String, List<Map<String, dynamic>>> _buildAttractionsData(LanguageService lang) {
    return {
      "BALI": [
        {
          "name": lang.t('bali_att_1'),
          "mapsUrl": "https://maps.google.com/?q=Pantai+Kuta,Bali",
          "tips": [
            lang.t('bali_att_1_tip1'),
            lang.t('bali_att_1_tip2'),
            lang.t('bali_att_1_tip3'),
            lang.t('bali_att_1_tip4'),
          ]
        },
        {
          "name": lang.t('bali_att_2'),
          "mapsUrl": "https://maps.google.com/?q=Uluwatu+Temple,Bali",
          "tips": [
            lang.t('bali_att_2_tip1'),
            lang.t('bali_att_2_tip2'),
            lang.t('bali_att_2_tip3'),
            lang.t('bali_att_2_tip4'),
          ]
        },
        {
          "name": lang.t('bali_att_3'),
          "mapsUrl": "https://maps.google.com/?q=Seminyak+Beach,Bali",
          "tips": [
            lang.t('bali_att_3_tip1'),
            lang.t('bali_att_3_tip2'),
            lang.t('bali_att_3_tip3'),
            lang.t('bali_att_3_tip4'),
          ]
        },
      ],
      "YOGYAKARTA": [
        {
          "name": lang.t('yogy_att_1'),
          "mapsUrl": "https://maps.google.com/?q=Candi+Borobudur,Magelang",
          "tips": [
            lang.t('yogy_att_1_tip1'),
            lang.t('yogy_att_1_tip2'),
            lang.t('yogy_att_1_tip3'),
            lang.t('yogy_att_1_tip4'),
          ]
        },
        {
          "name": lang.t('yogy_att_2'),
          "mapsUrl": "https://maps.google.com/?q=Candi+Prambanan,Yogyakarta",
          "tips": [
            lang.t('yogy_att_2_tip1'),
            lang.t('yogy_att_2_tip2'),
            lang.t('yogy_att_2_tip3'),
            lang.t('yogy_att_2_tip4'),
          ]
        },
        {
          "name": lang.t('yogy_att_3'),
          "mapsUrl": "https://maps.google.com/?q=Keraton+Yogyakarta",
          "tips": [
            lang.t('yogy_att_3_tip1'),
            lang.t('yogy_att_3_tip2'),
            lang.t('yogy_att_3_tip3'),
            lang.t('yogy_att_3_tip4'),
          ]
        },
      ],
      "JAKARTA": [
        {
          "name": lang.t('jak_att_1'),
          "mapsUrl": "https://maps.google.com/?q=Kota+Tua,Jakarta",
          "tips": [
            lang.t('jak_att_1_tip1'),
            lang.t('jak_att_1_tip2'),
            lang.t('jak_att_1_tip3'),
            lang.t('jak_att_1_tip4'),
          ]
        },
        {
          "name": lang.t('jak_att_2'),
          "mapsUrl": "https://maps.google.com/?q=Kepulauan+Seribu,Jakarta",
          "tips": [
            lang.t('jak_att_2_tip1'),
            lang.t('jak_att_2_tip2'),
            lang.t('jak_att_2_tip3'),
            lang.t('jak_att_2_tip4'),
          ]
        },
        {
          "name": lang.t('jak_att_3'),
          "mapsUrl": "https://maps.google.com/?q=Taman+Mini+Indonesia+Indah,Jakarta",
          "tips": [
            lang.t('jak_att_3_tip1'),
            lang.t('jak_att_3_tip2'),
            lang.t('jak_att_3_tip3'),
            lang.t('jak_att_3_tip4'),
          ]
        },
      ],
      "RAJA_AMPAT": [
        {
          "name": lang.t('ra_att_1'),
          "mapsUrl": "https://maps.google.com/?q=Wayag+Raja+Ampat",
          "tips": [
            lang.t('ra_att_1_tip1'),
            lang.t('ra_att_1_tip2'),
            lang.t('ra_att_1_tip3'),
            lang.t('ra_att_1_tip4'),
          ]
        },
        {
          "name": lang.t('ra_att_2'),
          "mapsUrl": "https://maps.google.com/?q=Pianemo+Raja+Ampat",
          "tips": [
            lang.t('ra_att_2_tip1'),
            lang.t('ra_att_2_tip2'),
            lang.t('ra_att_2_tip3'),
            lang.t('ra_att_2_tip4'),
          ]
        },
        {
          "name": lang.t('ra_att_3'),
          "mapsUrl": "https://maps.google.com/?q=Arborek+Village+Raja+Ampat",
          "tips": [
            lang.t('ra_att_3_tip1'),
            lang.t('ra_att_3_tip2'),
            lang.t('ra_att_3_tip3'),
            lang.t('ra_att_3_tip4'),
          ]
        },
      ],
    };
  }

  // ===== DATA CULTURES =====
  Map<String, List<Map<String, dynamic>>> _buildCulturesData(LanguageService lang) {
    return {
      "BALI": [
        {
          "name": lang.t('bali_cul_1'),
          "details": [
            lang.t('bali_cul_1_det1'),
            lang.t('bali_cul_1_det2'),
            lang.t('bali_cul_1_det3'),
            lang.t('bali_cul_1_det4'),
          ]
        },
        {
          "name": lang.t('bali_cul_2'),
          "details": [
            lang.t('bali_cul_2_det1'),
            lang.t('bali_cul_2_det2'),
            lang.t('bali_cul_2_det3'),
            lang.t('bali_cul_2_det4'),
          ]
        },
        {
          "name": lang.t('bali_cul_3'),
          "details": [
            lang.t('bali_cul_3_det1'),
            lang.t('bali_cul_3_det2'),
            lang.t('bali_cul_3_det3'),
            lang.t('bali_cul_3_det4'),
          ]
        },
      ],
      "YOGYAKARTA": [
        {
          "name": lang.t('yogy_cul_1'),
          "details": [
            lang.t('yogy_cul_1_det1'),
            lang.t('yogy_cul_1_det2'),
            lang.t('yogy_cul_1_det3'),
            lang.t('yogy_cul_1_det4'),
          ]
        },
        {
          "name": lang.t('yogy_cul_2'),
          "details": [
            lang.t('yogy_cul_2_det1'),
            lang.t('yogy_cul_2_det2'),
            lang.t('yogy_cul_2_det3'),
            lang.t('yogy_cul_2_det4'),
          ]
        },
        {
          "name": lang.t('yogy_cul_3'),
          "details": [
            lang.t('yogy_cul_3_det1'),
            lang.t('yogy_cul_3_det2'),
            lang.t('yogy_cul_3_det3'),
            lang.t('yogy_cul_3_det4'),
          ]
        },
      ],
      "JAKARTA": [
        {
          "name": lang.t('jak_cul_1'),
          "details": [
            lang.t('jak_cul_1_det1'),
            lang.t('jak_cul_1_det2'),
            lang.t('jak_cul_1_det3'),
            lang.t('jak_cul_1_det4'),
          ]
        },
        {
          "name": lang.t('jak_cul_2'),
          "details": [
            lang.t('jak_cul_2_det1'),
            lang.t('jak_cul_2_det2'),
            lang.t('jak_cul_2_det3'),
            lang.t('jak_cul_2_det4'),
          ]
        },
        {
          "name": lang.t('jak_cul_3'),
          "details": [
            lang.t('jak_cul_3_det1'),
            lang.t('jak_cul_3_det2'),
            lang.t('jak_cul_3_det3'),
            lang.t('jak_cul_3_det4'),
          ]
        },
      ],
      "RAJA_AMPAT": [
        {
          "name": lang.t('ra_cul_1'),
          "details": [
            lang.t('ra_cul_1_det1'),
            lang.t('ra_cul_1_det2'),
            lang.t('ra_cul_1_det3'),
            lang.t('ra_cul_1_det4'),
          ]
        },
        {
          "name": lang.t('ra_cul_2'),
          "details": [
            lang.t('ra_cul_2_det1'),
            lang.t('ra_cul_2_det2'),
            lang.t('ra_cul_2_det3'),
            lang.t('ra_cul_2_det4'),
          ]
        },
        {
          "name": lang.t('ra_cul_3'),
          "details": [
            lang.t('ra_cul_3_det1'),
            lang.t('ra_cul_3_det2'),
            lang.t('ra_cul_3_det3'),
            lang.t('ra_cul_3_det4'),
          ]
        },
      ],
    };
  }

  // ===== DATA EMERGENCIES =====
  final Map<String, Map<String, String>> emergenciesData = {
    "BALI": {
      "Police": "110",
      "Medical Emergency": "118",
      "Fire Department": "113",
    },
    "YOGYAKARTA": {
      "Police": "110",
      "Medical Emergency": "118",
      "Fire Department": "113",
    },
    "JAKARTA": {
      "Police": "110",
      "Medical Emergency": "118 / 119",
      "Fire Department": "113",
      "SAR / Search & Rescue": "115",
    },
    "RAJA_AMPAT": {
      "Police": "110",
      "Medical Emergency": "118",
      "Fire Department": "113",
    },
  };

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<LanguageService>(context);

    // Build data with current language
    final attractionsData = _buildAttractionsData(lang);
    final culturesData = _buildCulturesData(lang);

    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        surfaceTintColor: Colors.transparent,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: const Color(0xFFE8EEFF), height: 1),
        ),
        title: Row(
          children: const [
            SizedBox(width: 16),
            AppLogo(),
          ],
        ),
        actions: [
          NavIconButton(
            icon: Icons.home_rounded,
            onPressed: (context) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            },
          ),
          NavIconButton(
            icon: Icons.explore_rounded,
            onPressed: (context) {
              // Sudah di WikiScreen, bisa refresh atau abaikan
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const WikiScreen()),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: Builder(builder: (ctx) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4F80FF), Color(0xFF7B5FFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4F80FF).withOpacity(0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person_rounded, size: 18, color: Colors.white),
                ),
              );
            }),
          ),
        ],
      ),

      // BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // BACK BUTTON
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(lang.t('wiki_back'), style: const TextStyle(fontWeight: FontWeight.w600)),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF64748B),
                  padding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 16),

              // PREMIUM HEADER AREA
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7B5FFF), Color(0xFFA855F7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7B5FFF).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.explore_rounded,
                      size: 48,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lang.t('wiki_info1'),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      lang.t('wiki_info2'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // INFO CARD (Dropdown prefix)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE8EEFF)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFEEEE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.info_outline_rounded, color: Colors.redAccent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        lang.t('wiki_info3'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A5568),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // TITLE DESTINATION
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  lang.t('wiki_info4'),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // DROPDOWN
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: DropdownButton<String>(
                  value: selectedDestinationKey,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: dropdownValues.map((String key) {
                    String label = key == "ALL"
                        ? lang.t('wiki_all_destinations')
                        : lang.t(key.toLowerCase());
                    return DropdownMenuItem(
                      value: key,
                      child: Text(label),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDestinationKey = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ===== DESTINATION CARDS =====
              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "BALI") ...[
                destinationCard(
                  lang.t('bali'),
                  lang.t('wiki_des1'),
                  "https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=600&q=80",
                  attractionsData["BALI"]!,
                  culturesData["BALI"]!,
                  emergenciesData["BALI"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "YOGYAKARTA") ...[
                destinationCard(
                  lang.t('yogyakarta'),
                  lang.t('wiki_des2'),
                  "https://images.unsplash.com/photo-1583394293214-28ded15ee548?w=600&q=80",
                  attractionsData["YOGYAKARTA"]!,
                  culturesData["YOGYAKARTA"]!,
                  emergenciesData["YOGYAKARTA"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "JAKARTA") ...[
                destinationCard(
                  lang.t('jakarta'),
                  lang.t('wiki_des3'),
                  "https://images.unsplash.com/photo-1601597111158-2fceff292cdc?w=600&q=80",
                  attractionsData["JAKARTA"]!,
                  culturesData["JAKARTA"]!,
                  emergenciesData["JAKARTA"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "RAJA_AMPAT") ...[
                destinationCard(
                  lang.t('raja_ampat'),
                  lang.t('wiki_des4'),
                  "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600&q=80",
                  attractionsData["RAJA_AMPAT"]!,
                  culturesData["RAJA_AMPAT"]!,
                  emergenciesData["RAJA_AMPAT"]!,
                ),
                const SizedBox(height: 16),
              ],

              // ===== CARD 1 (Travel Tips) =====
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.lightbulb,
                              color: Colors.amber, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              lang.t('wiki_info5'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.zero,
                          title: Text(
                            lang.t('wiki_info6'),
                            style: const TextStyle(fontSize: 14),
                          ),
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(lang.t('wiki_drop1')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop2')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop3')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop4')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop5')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop6')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop7')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop8')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop9')),
                                  const SizedBox(height: 6),
                                  Text(lang.t('wiki_drop10')),
                                  const SizedBox(height: 6),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ===== CARD 2 (Emergency) =====
              Card(
                color: Colors.white,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          const Icon(Icons.phone, color: Colors.red, size: 28),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              lang.t('wiki_info7'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Text(
                        lang.t('wiki_info8'),
                        style: const TextStyle(color: Colors.black54),
                      ),

                      const SizedBox(height: 16),

                      // POLICE
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_police, color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('wiki_em1'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // AMBULANCE
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.medical_services, color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('wiki_em2'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // FIRE
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department, color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('wiki_em3'),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ===== DESTINATION CARD WIDGET =====
  Widget destinationCard(
      String title,
      String description,
      String imageUrl,
      List<Map<String, dynamic>> attractions,
      List<Map<String, dynamic>> cultures,
      Map<String, String> emergencies,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WikiInfoTemplate(
              title: title,
              imageUrl: imageUrl,
              description: description,
              attractions: attractions,
              cultures: cultures,
              emergencies: emergencies,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7B5FFF).withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: const Color(0xFFF1F5F9),
                    child: const Icon(Icons.broken_image_rounded, color: Colors.grey),
                  ),
                ),
              ),
            ),

            // TEXT
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // SIMPLE CARD
  Widget simpleCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}