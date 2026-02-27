enum ExperimentStatus { completed, inProgress, incomplete }

class ExperimentData {
  final String title;
  final String date;
  final String duration;
  final ExperimentStatus status;
  final double pHStart;
  final double pHEnd;

  ExperimentData({
    required this.title,
    required this.date,
    required this.duration,
    required this.status,
    required this.pHStart,
    required this.pHEnd,
  });
}