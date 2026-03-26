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

  factory NlpQuestion.fromMap(String id, Map<String, dynamic> data) {
    return NlpQuestion(
      id: id,
      soal: (data['question'] ?? data['soal'] ?? '').toString(),
      jawabanBenar: (data['Pronunciation'] ?? data['jawaban_benar'] ?? data['correctAnswer'] ?? data['answer'] ?? data['jawaban'] ?? '').toString(),
      audioUrl: (data['audioUrl'] ?? '').toString(),
    );
  }
}
