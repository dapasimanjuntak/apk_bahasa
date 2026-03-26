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
                  children:  [

                    Icon(
                      Icons.info,
                      color: Colors.green,
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        lang.t('wiki_info3'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
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

              // DESTINATION CARDS
              destinationCard(
                "Bali",
                lang.t('wiki_des1'),
                "https://images.unsplash.com/photo-1537996194471-e657df975ab4",
              ),
              const SizedBox(height: 16),

              destinationCard(
                "Yogyakarta",
                lang.t('wiki_des2'),
                "https://images.unsplash.com/photo-1583394293214-28ded15ee548",
              ),
              const SizedBox(height: 16),

              destinationCard(
                "Jakarta",
                lang.t('wiki_des3'),
                "https://images.unsplash.com/photo-1601597111158-2fceff292cdc",
              ),
              const SizedBox(height: 16),

              destinationCard(
                "Raja Ampat",
                lang.t('wiki_des4'),
                "https://images.unsplash.com/photo-1507525428034-b723cf961d3e",
              ),

              // SIMPLE CARD/non-click card
              // CARD 1 (Travel Tips)
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
                          const Icon(
                            Icons.lightbulb,
                            color: Colors.amber,
                            size: 28,
                          ),
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
                            style: TextStyle(fontSize: 14),
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
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop2')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop3')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop4')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop5')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop6')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop7')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop8')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop9')),
                                  SizedBox(height: 6),

                                  Text(lang.t('wiki_drop10')),
                                  SizedBox(height: 6),

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

              // CARD 2 masih placeholder dulu
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

                      // icon + title
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
                          children:  [
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
                          children:  [
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
                          children:  [
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
            ],
          ),
        ),
      ),
    );
  }

  // DESTINATION CARD
  Widget destinationCard(
      String title,
      String description,
      String imageUrl,
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

            // ===== BAGIAN BARU (GAMBAR) =====
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

            // ===== TEKS =====
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
            offset: const Offset(0,4),
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