// File: lib/screens/upload_data_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UploadDataScreen extends StatefulWidget {
  const UploadDataScreen({Key? key}) : super(key: key);

  @override
  _UploadDataScreenState createState() => _UploadDataScreenState();
}

class _UploadDataScreenState extends State<UploadDataScreen> {
  bool _isLoading = false;
  String _status = "Klik tombol di bawah untuk mengunggah ratusan soal otomatis.";

  // DATA SESUAI PERMINTAAN ANDA
  final List<Map<String, dynamic>> _data = [
    // ---------------- BEGINNER ----------------
    {
      "level": "beginner", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"audioUrl": "", "question": "Say hello to the officer", "Pronunciation": "Halo, selamat pagi, Pak."},
        {"audioUrl": "", "question": "Tell them you are going to Jakarta", "Pronunciation": "Saya mau ke Jakarta."},
        {"audioUrl": "", "question": "Say that this is your passport", "Pronunciation": "Ini paspor saya."},
        {"audioUrl": "", "question": "Ask where gate five is", "Pronunciation": "Di mana gerbang lima?"},
        {"audioUrl": "", "question": "Say thank you very much", "Pronunciation": "Terima kasih banyak."},
      ]
    },
    {
      "level": "beginner", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"audioUrl": "", "question": "Say hello in the afternoon", "Pronunciation": "Halo, selamat sore."},
        {"audioUrl": "", "question": "Say you want to check-in", "Pronunciation": "Saya mau check-in."},
        {"audioUrl": "", "question": "Ask for the room key", "Pronunciation": "Boleh minta kunci kamar?"},
        {"audioUrl": "", "question": "Ask them to clean your room", "Pronunciation": "Tolong bersihkan kamar saya."},
        {"audioUrl": "", "question": "Say you want to check-out", "Pronunciation": "Saya mau check-out."},
      ]
    },
    {
      "level": "beginner", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"audioUrl": "", "question": "Say hello and ask for a table for two", "Pronunciation": "Halo, selamat siang. Meja untuk dua orang."},
        {"audioUrl": "", "question": "Say you want fried rice", "Pronunciation": "Saya mau nasi goreng."},
        {"audioUrl": "", "question": "Ask for iced tea", "Pronunciation": "Minta minum teh es."},
        {"audioUrl": "", "question": "Say you don't want it spicy", "Pronunciation": "Jangan pedas, ya."},
        {"audioUrl": "", "question": "Ask for the total price", "Pronunciation": "Berapa harga semuanya, Pak?"},
      ]
    },
    {
      "level": "beginner", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"audioUrl": "", "question": "Say hello in the morning", "Pronunciation": "Halo, selamat pagi, Bu."},
        {"audioUrl": "", "question": "Ask the price of the apples", "Pronunciation": "Apel ini berapa harganya?"},
        {"audioUrl": "", "question": "Ask for one kilogram", "Pronunciation": "Tolong satu kilo saja."},
        {"audioUrl": "", "question": "Ask for a lower price", "Pronunciation": "Boleh kurang sedikit harganya?"},
        {"audioUrl": "", "question": "Give money and say thank you", "Pronunciation": "Ini uangnya, terima kasih."},
      ]
    },
    {
      "level": "beginner", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"audioUrl": "", "question": "Say hello to the driver", "Pronunciation": "Halo, selamat pagi, Pak."},
        {"audioUrl": "", "question": "Ask the price to the train station", "Pronunciation": "Ke stasiun kereta, berapa?"},
        {"audioUrl": "", "question": "Ask to turn left", "Pronunciation": "Tolong belok kiri di depan."},
        {"audioUrl": "", "question": "Ask to stop here", "Pronunciation": "Berhenti di sini saja, Pak."},
        {"audioUrl": "", "question": "Give money and take change", "Pronunciation": "Ini uangnya, ambil kembaliannya."},
      ]
    },
    {
      "level": "beginner", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"audioUrl": "", "question": "Say hello in the afternoon", "Pronunciation": "Halo, selamat sore, Suster."},
        {"audioUrl": "", "question": "Say your stomach hurts", "Pronunciation": "Perut saya sakit sekali."},
        {"audioUrl": "", "question": "Ask if there is a doctor", "Pronunciation": "Ada dokter yang bisa periksa?"},
        {"audioUrl": "", "question": "Ask how to take the medicine", "Pronunciation": "Bagaimana cara minum obat ini?"},
        {"audioUrl": "", "question": "Say thank you very much", "Pronunciation": "Terima kasih banyak, Suster."},
      ]
    },

    // ---------------- INTERMEDIATE ----------------
    {
      "level": "intermediate", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"audioUrl": "", "question": "Excuse yourself and ask for help", "Pronunciation": "Permisi, selamat siang. Bisa bantu saya?"},
        {"audioUrl": "", "question": "Ask for the flight schedule to Jakarta", "Pronunciation": "Saya ingin tanya jadwal pesawat ke Jakarta."},
        {"audioUrl": "", "question": "Ask where the baggage claim area is", "Pronunciation": "Di mana tempat ambil bagasi pesawat saya?"},
        {"audioUrl": "", "question": "Ask for directions to the taxi stand", "Pronunciation": "Tolong tunjukkan jalan ke pangkalan taksi."},
        {"audioUrl": "", "question": "Thank them for their help", "Pronunciation": "Terima kasih atas bantuannya, Pak."},
      ]
    },
    {
      "level": "intermediate", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"audioUrl": "", "question": "Say you have booked a room", "Pronunciation": "Selamat sore, saya sudah pesan kamar."},
        {"audioUrl": "", "question": "Ask if breakfast is included", "Pronunciation": "Apakah sudah termasuk sarapan besok pagi?"},
        {"audioUrl": "", "question": "Ask for another towel", "Pronunciation": "Tolong antarkan satu handuk lagi ke kamar."},
        {"audioUrl": "", "question": "Ask for help turning on the AC", "Pronunciation": "Bisa bantu nyalakan AC di kamar saya?"},
        {"audioUrl": "", "question": "Say you want to check-out and give the key", "Pronunciation": "Saya mau check-out sekarang, ini kuncinya."},
      ]
    },
    {
      "level": "intermediate", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"audioUrl": "", "question": "Ask to book a table", "Pronunciation": "Permisi, selamat siang. Mau pesan meja."},
        {"audioUrl": "", "question": "Ask the best menu", "Pronunciation": "Apa menu makanan yang paling enak di sini?"},
        {"audioUrl": "", "question": "Order chicken satay", "Pronunciation": "Saya mau pesan satu porsi sate ayam."},
        {"audioUrl": "", "question": "Ask not too spicy", "Pronunciation": "Tolong jangan terlalu pedas ya, Mbak."},
        {"audioUrl": "", "question": "Ask for the bill", "Pronunciation": "Bisa minta bon atau tagihannya sekarang?"},
      ]
    },
    {
      "level": "intermediate", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"audioUrl": "", "question": "Ask if the oranges are fresh", "Pronunciation": "Selamat pagi Bu, jeruknya masih segar?"},
        {"audioUrl": "", "question": "Ask for discount if buying a lot", "Pronunciation": "Harganya bisa kurang kalau saya beli banyak?"},
        {"audioUrl": "", "question": "Buy two kilos of oranges", "Pronunciation": "Saya mau beli dua kilo jeruk manis."},
        {"audioUrl": "", "question": "Ask to pick the best fruits", "Pronunciation": "Bisa tolong pilihkan buah yang paling bagus?"},
        {"audioUrl": "", "question": "Say you will come again", "Pronunciation": "Terima kasih, Bu. Saya akan datang lagi besok."},
      ]
    },
    {
      "level": "intermediate", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"audioUrl": "", "question": "Ask to go to an address", "Pronunciation": "Selamat pagi Pak, tolong ke alamat ini."},
        {"audioUrl": "", "question": "Ask travel time", "Pronunciation": "Kira-kira berapa lama sampai ke stasiun?"},
        {"audioUrl": "", "question": "Ask to use toll road", "Pronunciation": "Lewat jalan tol saja supaya tidak macet."},
        {"audioUrl": "", "question": "Ask to stop in front of the gate", "Pronunciation": "Tolong berhenti tepat di depan gerbang stasiun."},
        {"audioUrl": "", "question": "Thank the driver", "Pronunciation": "Terima kasih Pak, hati-hati di jalan."},
      ]
    },
    {
      "level": "intermediate", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"audioUrl": "", "question": "Say you want to register", "Pronunciation": "Selamat sore, saya mau daftar periksa."},
        {"audioUrl": "", "question": "Explain your symptoms", "Pronunciation": "Kepala saya pusing dan badan saya demam."},
        {"audioUrl": "", "question": "Ask to buy flu medicine", "Pronunciation": "Apakah saya bisa beli obat flu di sini?"},
        {"audioUrl": "", "question": "Ask how often to take medicine", "Pronunciation": "Berapa kali sehari saya harus minum obat?"},
        {"audioUrl": "", "question": "Thank for the information", "Pronunciation": "Baik suster, terima kasih atas informasinya."},
      ]
    },

    // ---------------- ADVANCED ----------------
    {
      "level": "expert", "scenario": "airport", "title": "Bandara", "desc": "Skenario di bandara.",
      "questions": [
        {"audioUrl": "", "question": "Ask for help because you are confused", "Pronunciation": "Permisi, selamat siang. Bisa bantu saya sebentar karena saya bingung?"},
        {"audioUrl": "", "question": "Ask about delayed flight schedule", "Pronunciation": "Saya ingin tanya jadwal pesawat ke Jakarta yang tadi katanya terlambat."},
        {"audioUrl": "", "question": "Ask baggage claim because you can't find it", "Pronunciation": "Di mana tempat ambil bagasi pesawat saya karena saya sudah cari tapi tidak ada?"},
        {"audioUrl": "", "question": "Ask for official taxi stand", "Pronunciation": "Tolong tunjukkan jalan ke pangkalan taksi resmi agar saya tidak salah naik."},
        {"audioUrl": "", "question": "Appreciate the help", "Pronunciation": "Terima kasih atas bantuannya, Pak. Saya sangat menghargai informasi ini."},
      ]
    },
    {
      "level": "expert", "scenario": "hotel", "title": "Hotel", "desc": "Skenario di hotel.",
      "questions": [
        {"audioUrl": "", "question": "Say booking under name Budi for two nights", "Pronunciation": "Selamat sore, saya sudah pesan kamar atas nama Budi untuk dua malam."},
        {"audioUrl": "", "question": "Ask if breakfast included or extra charge", "Pronunciation": "Apakah sudah termasuk sarapan besok pagi atau saya harus bayar lagi?"},
        {"audioUrl": "", "question": "Ask for towel because only one available", "Pronunciation": "Tolong antarkan satu handuk lagi ke kamar karena di sini hanya ada satu."},
        {"audioUrl": "", "question": "Ask help with broken AC remote", "Pronunciation": "Bisa bantu nyalakan AC di kamar saya karena sepertinya remotenya rusak?"},
        {"audioUrl": "", "question": "Check-out and ask for bill", "Pronunciation": "Saya mau check-out sekarang, tolong siapkan tagihannya di meja kasir."},
      ]
    },
    {
      "level": "expert", "scenario": "restaurant", "title": "Restoran", "desc": "Skenario di restoran.",
      "questions": [
        {"audioUrl": "", "question": "Book table for birthday event", "Pronunciation": "Permisi, selamat siang. Saya mau pesan meja untuk acara ulang tahun."},
        {"audioUrl": "", "question": "Ask best menu for foreign guests", "Pronunciation": "Apa menu makanan yang paling enak di sini untuk tamu dari luar negeri?"},
        {"audioUrl": "", "question": "Order satay with sauce separated", "Pronunciation": "Saya mau pesan satu porsi sate ayam tapi tolong kacangnya dipisah."},
        {"audioUrl": "", "question": "Not spicy because friend doesn't like it", "Pronunciation": "Tolong jangan terlalu pedas ya, Mbak, karena teman saya tidak suka pedas."},
        {"audioUrl": "", "question": "Ask bill and pay by card", "Pronunciation": "Bisa minta bon atau tagihannya sekarang? Saya ingin bayar pakai kartu."},
      ]
    },
    {
      "level": "expert", "scenario": "market", "title": "Pasar", "desc": "Skenario belanja.",
      "questions": [
        {"audioUrl": "", "question": "Ask if oranges are fresh or from yesterday", "Pronunciation": "Selamat pagi Bu, jeruknya masih segar atau ini stok dari kemarin?"},
        {"audioUrl": "", "question": "Ask discount for stock purchase", "Pronunciation": "Harganya bisa kurang kalau saya beli banyak untuk stok di rumah?"},
        {"audioUrl": "", "question": "Buy thin-skin oranges", "Pronunciation": "Saya mau beli dua kilo jeruk manis yang kulitnya tipis saja."},
        {"audioUrl": "", "question": "Ask for best fruits so they don't rot quickly", "Pronunciation": "Bisa tolong pilihkan buah yang paling bagus supaya tidak cepat busuk?"},
        {"audioUrl": "", "question": "Say will come again with friend", "Pronunciation": "Terima kasih, Bu. Saya akan datang lagi besok bersama teman saya."},
      ]
    },
    {
      "level": "expert", "scenario": "transportation", "title": "Transportasi", "desc": "Skenario bepergian.",
      "questions": [
        {"audioUrl": "", "question": "Ask driver to follow map", "Pronunciation": "Selamat pagi Pak, tolong ke alamat ini yang ada di peta."},
        {"audioUrl": "", "question": "Ask travel time in traffic", "Pronunciation": "Kira-kira berapa lama sampai ke stasiun kalau macet seperti sekarang?"},
        {"audioUrl": "", "question": "Ask to take toll because in a hurry", "Pronunciation": "Lewat jalan tol saja supaya tidak macet karena saya sedang terburu-buru."},
        {"audioUrl": "", "question": "Ask to stop near gate for easy access", "Pronunciation": "Tolong berhenti tepat di depan gerbang stasiun agar saya dekat berjalan."},
        {"audioUrl": "", "question": "Thank and mention rainy weather", "Pronunciation": "Terima kasih Pak, hati-hati di jalan karena cuaca sedang hujan."},
      ]
    },
    {
      "level": "expert", "scenario": "clinic", "title": "Klinik", "desc": "Skenario berobat.",
      "questions": [
        {"audioUrl": "", "question": "Register for general doctor", "Pronunciation": "Selamat sore, saya mau daftar periksa untuk dokter umum sekarang."},
        {"audioUrl": "", "question": "Explain symptoms since last night", "Pronunciation": "Kepala saya pusing dan badan saya demam sejak tadi malam."},
        {"audioUrl": "", "question": "Ask to buy medicine without prescription", "Pronunciation": "Apakah saya bisa beli obat flu di sini tanpa resep dokter?"},
        {"audioUrl": "", "question": "Ask dosage for faster recovery", "Pronunciation": "Berapa kali sehari saya harus minum obat agar cepat sembuh?"},
        {"audioUrl": "", "question": "Thank and wait", "Pronunciation": "Baik suster, terima kasih atas informasinya. Saya tunggu di ruang tamu."},
      ]
    },
  ];

  Future<void> _uploadAllData() async {
    setState(() {
      _isLoading = true;
      _status = "Memulai proses unggah ratusan soal ke Firestore...";
    });

    try {
      final firestore = FirebaseFirestore.instance;
      
      // Menggunakan arsitektur Flat: root collection 'topics'
      for (var group in _data) {
        String level = group['level'];
        String scenarioKey = group['scenario'];
        
        // 1. Buat / Update Document TEMA di root collection 'topics'
        // Cegah overwrite (Beginner ditimpa Expert) dengan prefix level
        String docId = '${level}_$scenarioKey';
        DocumentReference topicRef = firestore.collection('topics').doc(docId);
        
        await topicRef.set({
          'level': level,
          'scenario': scenarioKey, // Simpan kunci aslinya untuk mengambil gambar kartun
          'title': group['title'],
          'description': group['desc'],
        }, SetOptions(merge: true));

        // 2. Masukkan semua pertanyaan ke sub-koleksi 'items'
        List<Map<String, dynamic>> questions = group['questions'];
        for (int i = 0; i < questions.length; i++) {
          String qId = '${scenarioKey}_$level\_$i'; 
          await topicRef.collection('items').doc(qId).set({
            'audioUrl': questions[i]['audioUrl'],
            'question': questions[i]['question'],
            'Pronunciation': questions[i]['Pronunciation'],
          });
        }
      }

      setState(() {
        _status = "BERHASIL! Ratusan soal beserta Skema Flat berhasil diunggah.";
      });
    } catch (e) {
      setState(() {
        _status = "ERROR: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Skema Soal Otomatis")),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.blue[400]),
              const SizedBox(height: 20),
              Text(
                _status,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton.icon(
                  onPressed: _uploadAllData,
                  icon: const Icon(Icons.upload),
                  label: const Text("Suntik Semua Soal Ke Firestore", style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
