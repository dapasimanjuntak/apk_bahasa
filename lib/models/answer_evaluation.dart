class AnswerEvaluation {
  final double similarity;
  final String status;
  final String cleanedUserAnswer;
  final String cleanedCorrectAnswer;
  final String reason;

  const AnswerEvaluation({
    required this.similarity,
    required this.status,
    required this.cleanedUserAnswer,
    required this.cleanedCorrectAnswer,
    required this.reason,
  });
}
