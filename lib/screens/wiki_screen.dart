import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'settings_screen.dart';
import '../templates/wiki_info_template.dart';
import 'language_service.dart';
import 'package:provider/provider.dart';

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
  final Map<String, List<Map<String, dynamic>>> attractionsData = {
    "BALI": [
      {
        "name": "bali_att_1",
        "tips": [
          "bali_att_1_tip1",
          "bali_att_1_tip2",
        ]
      },
      {
        "name": "bali_att_2",
        "tips": [
          "bali_att_2_tip1",
          "bali_att_2_tip2",
        ]
      },
      {
        "name": "Seminyak Beach",
        "tips": [
          "Trendy beach with cafes and bars",
          "Great sunset watching spot",
          "Water sports available",
          "Busy but lively atmosphere"
        ]
      },
    ],
    "YOGYAKARTA": [
      {
        "name": "yogy_att_1",
        "tips": [
          "yogy_att_1_tip1",
        ]
      },
      {
        "name": "yogy_att_2",
        "tips": [
          "yogy_att_2_tip1",
        ]
      },
      {
        "name": "Keraton Yogyakarta",
        "tips": [
          "Royal palace of the Sultan",
          "Cultural performances on weekends",
          "Guided tours available",
          "Rich history of Javanese royalty"
        ]
      },
    ],
    "JAKARTA": [
      {
        "name": "jak_att_1",
        "tips": [
          "jak_att_1_tip1",
        ]
      },
      {
        "name": "jak_att_2",
        "tips": [
          "jak_att_2_tip1",
        ]
      },
      {
        "name": "Taman Mini Indonesia Indah",
        "tips": [
          "Cultural park showcasing all provinces",
          "Family friendly destination",
          "Wide area — best explored by vehicle",
          "Traditional houses from every region"
        ]
      },
    ],
    "RAJA_AMPAT": [
      {
        "name": "ra_att_1",
        "tips": [
          "ra_att_1_tip1",
        ]
      },
      {
        "name": "ra_att_2",
        "tips": [
          "ra_att_2_tip1",
        ]
      },
      {
        "name": "Arborek Village",
        "tips": [
          "Traditional Papuan fishing village",
          "Snorkeling right from the jetty",
          "Support local handicrafts",
          "Warm and welcoming community"
        ]
      },
    ],
  };

  // ===== DATA CULTURES =====
  final Map<String, List<Map<String, dynamic>>> culturesData = {
    "BALI": [
      {
        "name": "bali_cul_1",
        "details": [
          "bali_cul_1_det",
        ]
      },
      {
        "name": "Local Cuisine",
        "details": [
          "Try Babi Guling (roast pig) and Lawar",
          "Vibrant street food scene",
          "Fresh ingredients from local markets",
          "Spicy and flavorful dishes"
        ]
      },
      {
        "name": "Useful Phrases",
        "details": [
          "Om Swastiastu — Balinese greeting",
          "Suksma — Thank you",
          "Rahajeng semeng — Good morning",
          "Ampura — Sorry / Excuse me"
        ]
      },
    ],
    "YOGYAKARTA": [
      {
        "name": "yogy_cul_1",
        "details": [
          "yogy_cul_1_det",
        ]
      },
      {
        "name": "Batik Craft",
        "details": [
          "UNESCO-recognized art form",
          "Try making your own batik in workshops",
          "Malioboro is the best place to buy",
          "Motifs carry cultural meanings"
        ]
      },
      {
        "name": "Useful Phrases",
        "details": [
          "Sugeng rawuh — Welcome (Javanese)",
          "Matur nuwun — Thank you (Javanese)",
          "Mangga — Please / After you",
          "Nuwun sewu — Excuse me"
        ]
      },
    ],
    "JAKARTA": [
      {
        "name": "jak_cul_1",
        "details": [
          "jak_cul_1_det",
        ]
      },
      {
        "name": "Modern Food Scene",
        "details": [
          "Street food at Glodok (Chinatown)",
          "Gado-gado and Soto Betawi are must-tries",
          "Many international cuisines available",
          "Food courts in malls are affordable"
        ]
      },
      {
        "name": "Useful Phrases",
        "details": [
          "Halo / Hai — Hello",
          "Terima kasih — Thank you",
          "Maaf — Sorry / Excuse me",
          "Berapa harganya? — How much is it?"
        ]
      },
    ],
    "RAJA_AMPAT": [
      {
        "name": "ra_cul_1",
        "details": [
          "ra_cul_1_det",
        ]
      },
      {
        "name": "Local Food",
        "details": [
          "Fresh seafood caught daily",
          "Papeda (sago porridge) with fish soup",
          "Unique flavors from eastern Indonesia",
          "Pinang (betel nut) is commonly chewed locally"
        ]
      },
      {
        "name": "Useful Phrases",
        "details": [
          "Selamat datang — Welcome",
          "Terima kasih — Thank you",
          "Permisi — Excuse me",
          "Tolong — Please / Help"
        ]
      },
    ],
  };

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
    return Scaffold(

      // APPBAR
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        titleSpacing: 0,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(width: 16),
            Icon(Icons.school, color: Colors.blue),
            SizedBox(width: 8),
            Text(
              'ID Learning',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        actions: [

          // HOME
          IconButton(
            icon: const Icon(Icons.home, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),

          // MAP
          IconButton(
            icon: const Icon(Icons.location_on, color: Colors.black),
            onPressed: () {},
          ),

          // PROFILE
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      // BODY
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              // BACK BUTTON
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                   },
                  icon: const Icon(Icons.arrow_back),
                  label: Text(lang.t('wiki_back')),
                ),
              ),

              const SizedBox(height: 10),

              // ICON MAP
              const Icon(
                Icons.map,
                size: 70,
                color: Colors.green,
              ),

              const SizedBox(height: 12),

              // TITLE
              Text(
                lang.t('wiki_info1'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // DESCRIPTION
              Text(
                lang.t('wiki_info2'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              // INFO CARD
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lang.t('wiki_info3'),
                        style: const TextStyle(fontWeight: FontWeight.w500),
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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                   borderRadius: BorderRadius.circular(10),
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

                    // ===== DESTINATION CARDS =====
              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "BALI") ...[
                destinationCard(
                  lang.t('bali'),
                  lang.t('wiki_des1'),
                  "https://images.unsplash.com/photo-1537996194471-e657df975ab4",
                  attractionsData["BALI"]!,
                  culturesData["BALI"]!,
                  emergenciesData["BALI"]!,
                  lang: lang,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "YOGYAKARTA") ...[
                destinationCard(
                  lang.t('yogyakarta'),
                  lang.t('wiki_des2'),
                  "https://images.unsplash.com/photo-1583394293214-28ded15ee548",
                  attractionsData["YOGYAKARTA"]!,
                  culturesData["YOGYAKARTA"]!,
                  emergenciesData["YOGYAKARTA"]!,
                  lang: lang,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "JAKARTA") ...[
                destinationCard(
                  lang.t('jakarta'),
                  lang.t('wiki_des3'),
                  "https://images.unsplash.com/photo-1601597111158-2fceff292cdc",
                  attractionsData["JAKARTA"]!,
                  culturesData["JAKARTA"]!,
                  emergenciesData["JAKARTA"]!,
                  lang: lang,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestinationKey == "ALL" ||
                  selectedDestinationKey == "RAJA_AMPAT") ...[
                destinationCard(
                  lang.t('raja_ampat'),
                  lang.t('wiki_des4'),
                  "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
                  attractionsData["RAJA_AMPAT"]!,
                  culturesData["RAJA_AMPAT"]!,
                  emergenciesData["RAJA_AMPAT"]!,
                  lang: lang,
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
                          Text(
                            lang.t('wiki_info7'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
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
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
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
                            const Icon(Icons.medical_services,
                                color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('wiki_em2'),
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
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
                            const Icon(Icons.local_fire_department,
                                color: Colors.red),
                            const SizedBox(width: 12),
                            Text(
                              lang.t('wiki_em3'),
                              style:
                              const TextStyle(fontWeight: FontWeight.bold),
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
      {required LanguageService lang}
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
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
              child: SizedBox(
                height: 160,
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
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