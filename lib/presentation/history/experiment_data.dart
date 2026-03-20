enum ExperimentStatus { success, failed }

class ExperimentData {
  final String title;
  final String date;
  final String duration;
  final ExperimentStatus status;
  final String? reason;
  final String? extraInfo;

  ExperimentData({
    required this.title,
    required this.date,
    required this.duration,
    required this.status,
    this.reason,
    this.extraInfo,
  });
}