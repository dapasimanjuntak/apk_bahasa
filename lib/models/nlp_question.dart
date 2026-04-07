class NlpQuestion {
  final String id;
  final String soal;
  final String jawabanBenar;
  final String audioUrl;

  const NlpQuestion({
    required this.id,
    required this.soal,
    required this.jawabanBenar,
    this.audioUrl = '',
  });

  factory NlpQuestion.fromMap(String id, Map<String, dynamic> data, String langCode) {
    // Fungsi untuk mengambil soal berdasarkan bahasa (fallback ke 'en' jika tidak ada)
    String getQuestionText() {
      final qData = data['question'];
      if (qData is Map) {
        // Coba ambil bahasa yang dipilih, jika tidak ada pakai 'en', jika tidak ada pakai 'id'
        return (qData[langCode] ?? qData['en'] ?? qData['id'] ?? '').toString();
      }
      // Fallback jika datanya masih format lama (string langsung)
      return (data['question'] ?? data['soal'] ?? '').toString();
    }

    return NlpQuestion(
      id: id,
      soal: getQuestionText(),
      // Jawaban (Bahasa Indonesia) tetap satu untuk semua bahasa pengantar
      jawabanBenar: (data['answer'] ?? data['jawaban'] ?? data['jawaban_benar'] ?? data['Pronunciation'] ?? data['correctAnswer'] ?? '').toString(),
      audioUrl: (data['audioUrl'] ?? '').toString(),
    );
  }
}
