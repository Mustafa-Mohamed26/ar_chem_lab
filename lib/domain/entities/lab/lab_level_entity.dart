import 'package:ar_chem_lab/domain/entities/lab/experiment_entity.dart';

enum LabLevelStatus { active, locked, completed }

class LabLevelEntity {
  final String id;
  final String title;
  final String description;
  final LabLevelStatus status;
  final double progress; // 0.0 to 1.0
  final List<ExperimentEntity> experiments;
  final String? prerequisite;

  const LabLevelEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    required this.experiments,
    this.prerequisite,
  });
}
