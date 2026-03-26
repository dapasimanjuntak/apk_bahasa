import 'dart:math';

class TfIdfService {
  // Daftar kata hubung/stop words bahasa Indonesia dasar
  static final List<String> _stopWords = [
    'yang', 'untuk', 'pada', 'ke', 'di', 'dari', 'dan', 'atau', 'dengan',
    'ini', 'itu', 'adalah', 'sebagai', 'akan', 'bisa', 'ada', 'tidak', 'ya', 'belum',
    'bahwa', 'oleh', 'saat', 'ketika'
  ];

  /// Tokenisasi teks: lowercasing, hapus tanda baca, dan buang stop words
  static List<String> tokenizeAndClean(String text) {
    String cleanText = text.toLowerCase().replaceAll(RegExp(r'[^\w\s]'), '');
    List<String> words = cleanText.split(RegExp(r'\s+'));
    return words.where((w) => w.isNotEmpty && !_stopWords.contains(w)).toList();
  }

  /// Menghitung kemiripan (0.0 sampai 1.0) menggunakan TF-IDF & Cosine Similarity.
  /// Membandingkan jawaban user [answer] dengan kunci jawaban [expected].
  static double calculateSimilarity(String expected, String answer) {
    List<String> docExpected = tokenizeAndClean(expected);
    List<String> docAnswer = tokenizeAndClean(answer);

    if (docExpected.isEmpty && docAnswer.isEmpty) return 1.0;
    if (docExpected.isEmpty || docAnswer.isEmpty) return 0.0;

    Set<String> vocab = {};
    vocab.addAll(docExpected);
    vocab.addAll(docAnswer);

    // Kumpulan seluruh dokumen studi kasus
    List<List<String>> corpus = [docExpected, docAnswer];

    // Menghitung TF-IDF
    Map<String, double> tfIdfExpected = _calculateTfIdf(docExpected, corpus, vocab);
    Map<String, double> tfIdfAnswer = _calculateTfIdf(docAnswer, corpus, vocab);

    // Cosine Similarity
    return _cosineSimilarity(tfIdfExpected, tfIdfAnswer, vocab);
  }

  // Term Frequency (TF)
  static Map<String, double> _calculateTfIdf(List<String> doc, List<List<String>> corpus, Set<String> vocab) {
    Map<String, double> tfIdf = {};
    int docLen = doc.length;
    int corpusLen = corpus.length;

    for (var word in vocab) {
      // 1. Hitung TF
      int countInDoc = doc.where((w) => w == word).length;
      double tf = countInDoc / docLen;

      // 2. Hitung IDF (Inverse Document Frequency)
      int docsWithWord = corpus.where((d) => d.contains(word)).length;
      double idf = log(corpusLen / (docsWithWord > 0 ? docsWithWord : 1));

      tfIdf[word] = tf * idf;
    }
    return tfIdf;
  }

  // Cosine Similarity Algorithm
  static double _cosineSimilarity(Map<String, double> vec1, Map<String, double> vec2, Set<String> vocab) {
    double dotProduct = 0.0;
    double norm1 = 0.0;
    double norm2 = 0.0;

    for (var word in vocab) {
      double val1 = vec1[word] ?? 0.0;
      double val2 = vec2[word] ?? 0.0;

      dotProduct += val1 * val2;
      norm1 += val1 * val1;
      norm2 += val2 * val2;
    }

    if (norm1 == 0 || norm2 == 0) return 0.0; // Mencegah division by zero
    return dotProduct / (sqrt(norm1) * sqrt(norm2));
  }
}
