import 'package:flutter/material.dart';

class WikiInfoTemplate extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String description;

  const WikiInfoTemplate({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.description,
  });

  @override
  State<WikiInfoTemplate> createState() => _WikiInfoTemplateState();
}

class _WikiInfoTemplateState extends State<WikiInfoTemplate> {
  int selectedSegment = 0;

  final List<String> segments = [
    "Attractions",
    "Culture & Phrases",
    "Emergency"
  ];

  @override
  Widget build(BuildContext context) {
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
                child: Image.network(
                  widget.imageUrl,
                  height: 220,
                  width: 320,
                  fit: BoxFit.cover,
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
                        "About ${widget.title}",
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
                  children: List.generate(segments.length, (index) {
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
                            color: isSelected ? Colors.white : Colors.transparent,
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
                              segments[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.black87 : Colors.black54,
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
                      ? attractionsContent()
                      : selectedSegment == 1
                      ? cultureContent()
                      : emergencyContent(),
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

  Widget attractionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top Locations Row
        Row(
          children: const [
            Icon(Icons.star, color: Colors.yellow),
            SizedBox(width: 8),
            Text(
              "Top Locations",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Place example
        infoCard("Pantai Kuta", [
          "Sunset spot ideal for photography",
          "Popular for surfing beginners",
          "Close to cafes and restaurants",
          "Easy access by scooter or car"
        ]),
        const SizedBox(height: 12),
        infoCard("Uluwatu Temple", [
          "Famous cliffside temple with ocean view",
          "Cultural Kecak dance performances",
          "Scenic photography at sunset",
          "Watch out for monkeys!"
        ]),
        const SizedBox(height: 12),
        infoCard("Seminyak Beach", [
          "Trendy beach with cafes and bars",
          "Sunset watching spot",
          "Water sports available",
          "Busy but lively atmosphere"
        ]),
      ],
    );
  }

  Widget cultureContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cultural Highlights",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        infoCard("Balinese Dance", [
          "Traditional Kecak dance performance",
          "Performed in temples during ceremonies",
          "Storytelling through music and movement",
          "Cultural experience for tourists"
        ]),
        const SizedBox(height: 12),
        infoCard("Local Cuisine", [
          "Try Babi Guling and Lawar",
          "Street food experience",
          "Fresh ingredients from local markets",
          "Spicy and flavorful dishes"
        ]),
      ],
    );
  }

  Widget emergencyContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Emergency Numbers",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        infoCard("Police", ["110"]),
        const SizedBox(height: 8),
        infoCard("Medical Emergency", ["118"]),
        const SizedBox(height: 8),
        infoCard("Fire Department", ["113"]),
      ],
    );
  }

  Widget infoCard(String title, List<String> items) {
    return Card(
      color: Colors.blue.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "Info: $title",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...items.map((e) => Text("• $e")).toList(),
          ],
        ),
      ),
    );
  }
}