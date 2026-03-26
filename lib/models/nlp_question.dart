class NlpQuestion {
  final String id;
  final String soal;
  final String jawabanBenar;

  const NlpQuestion({
    required this.id,
    required this.soal,
    required this.jawabanBenar,
  });

  factory NlpQuestion.fromMap(String id, Map<String, dynamic> data) {
    return NlpQuestion(
      id: id,
      soal: (data['soal'] ?? data['question'] ?? '').toString(),
      jawabanBenar: (data['jawaban_benar'] ??
              data['correctAnswer'] ??
              data['answer'] ??
              data['jawaban'] ??
              '')
          .toString(),
    );
  }
}
