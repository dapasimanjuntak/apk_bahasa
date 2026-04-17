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
  String selectedDestination = "All Destinations";

  final List<String> destinations = [
    "All Destinations",
    "Bali",
    "Yogyakarta",
    "Jakarta",
    "Raja Ampat"
  ];

  // ===== DATA ATTRACTIONS =====
  final Map<String, List<Map<String, dynamic>>> attractionsData = {
    "Bali": [
      {
        "name": "Pantai Kuta",
        "tips": [
          "Sunset spot ideal for photography",
          "Popular for surfing beginners",
          "Close to cafes and restaurants",
          "Easy access by scooter or car"
        ]
      },
      {
        "name": "Uluwatu Temple",
        "tips": [
          "Famous cliffside temple with ocean view",
          "Cultural Kecak dance performances at sunset",
          "Scenic photography spot",
          "Watch out for monkeys!"
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
    "Yogyakarta": [
      {
        "name": "Candi Borobudur",
        "tips": [
          "Largest Buddhist temple in the world",
          "Best visited at sunrise",
          "Wear modest clothing",
          "UNESCO World Heritage Site"
        ]
      },
      {
        "name": "Candi Prambanan",
        "tips": [
          "Stunning Hindu temple compound",
          "Light show at night available",
          "Close to Borobudur — great combo trip",
          "Beautiful at golden hour"
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
    "Jakarta": [
      {
        "name": "Kota Tua",
        "tips": [
          "Dutch colonial architecture",
          "Museum Fatahillah nearby",
          "Street food around the square",
          "Great for history enthusiasts"
        ]
      },
      {
        "name": "Kepulauan Seribu",
        "tips": [
          "Island getaway from the city",
          "Snorkeling and diving spots",
          "1–2 hour boat ride from Muara Angke",
          "Best visited on weekdays"
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
    "Raja Ampat": [
      {
        "name": "Wayag Islands",
        "tips": [
          "Iconic karst island view",
          "Best reached by speedboat",
          "Photography hotspot at sunrise",
          "One of the most beautiful views in Indonesia"
        ]
      },
      {
        "name": "Pianemo",
        "tips": [
          "Lookout point over turquoise lagoon",
          "Requires a short hike",
          "Worth every step for the view",
          "Great snorkeling below the viewpoint"
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
    "Bali": [
      {
        "name": "Balinese Dance",
        "details": [
          "Traditional Kecak dance performance",
          "Performed in temples during ceremonies",
          "Storytelling through music and movement",
          "Popular cultural experience for tourists"
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
    "Yogyakarta": [
      {
        "name": "Wayang Kulit",
        "details": [
          "Traditional shadow puppet show",
          "Performed overnight in ceremonies",
          "Stories taken from Hindu epics (Ramayana, Mahabharata)",
          "A UNESCO Intangible Cultural Heritage"
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
    "Jakarta": [
      {
        "name": "Betawi Culture",
        "details": [
          "Indigenous culture of Jakarta",
          "Ondel-ondel giant puppet dance",
          "Kerak Telor: traditional sticky rice snack",
          "Lenong: comedic folk theatre"
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
    "Raja Ampat": [
      {
        "name": "Papuan Traditions",
        "details": [
          "Traditional dances with feather and shell costumes",
          "Rich oral history and tribal culture",
          "Respect local customs when visiting villages",
          "Ask permission before taking photos of locals"
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
    "Bali": {
      "Police": "110",
      "Medical Emergency": "118",
      "Fire Department": "113",
    },
    "Yogyakarta": {
      "Police": "110",
      "Medical Emergency": "118",
      "Fire Department": "113",
    },
    "Jakarta": {
      "Police": "110",
      "Medical Emergency": "118 / 119",
      "Fire Department": "113",
      "SAR / Search & Rescue": "115",
    },
    "Raja Ampat": {
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
                  label: const Text("Back"),
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
                  value: selectedDestination,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: destinations.map((String value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedDestination = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ===== DESTINATION CARDS =====
              if (selectedDestination == "All Destinations" ||
                  selectedDestination == "Bali") ...[
                destinationCard(
                  "Bali",
                  lang.t('wiki_des1'),
                  "https://images.unsplash.com/photo-1537996194471-e657df975ab4",
                  attractionsData["Bali"]!,
                  culturesData["Bali"]!,
                  emergenciesData["Bali"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestination == "All Destinations" ||
                  selectedDestination == "Yogyakarta") ...[
                destinationCard(
                  "Yogyakarta",
                  lang.t('wiki_des2'),
                  "https://images.unsplash.com/photo-1583394293214-28ded15ee548",
                  attractionsData["Yogyakarta"]!,
                  culturesData["Yogyakarta"]!,
                  emergenciesData["Yogyakarta"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestination == "All Destinations" ||
                  selectedDestination == "Jakarta") ...[
                destinationCard(
                  "Jakarta",
                  lang.t('wiki_des3'),
                  "https://images.unsplash.com/photo-1601597111158-2fceff292cdc",
                  attractionsData["Jakarta"]!,
                  culturesData["Jakarta"]!,
                  emergenciesData["Jakarta"]!,
                ),
                const SizedBox(height: 16),
              ],

              if (selectedDestination == "All Destinations" ||
                  selectedDestination == "Raja Ampat") ...[
                destinationCard(
                  "Raja Ampat",
                  lang.t('wiki_des4'),
                  "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
                  attractionsData["Raja Ampat"]!,
                  culturesData["Raja Ampat"]!,
                  emergenciesData["Raja Ampat"]!,
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