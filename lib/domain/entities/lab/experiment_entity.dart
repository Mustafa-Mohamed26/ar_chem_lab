enum ExperimentSafety { high, medium, low }

class ExperimentMaterial {
  final String name;
  final String icon; // Icon name or path

  const ExperimentMaterial({required this.name, required this.icon});
}

class ExperimentStep {
  final String title;
  final String description;

  const ExperimentStep({required this.title, required this.description});
}

class ExperimentEntity {
  final String id;
  final String title;
  final String description;
  final String time;
  final String exp; // e.g., "4 Steps"
  final ExperimentSafety safety;
  final List<ExperimentMaterial> materials;
  final List<ExperimentStep> path;
  final String? tip;
  final String? imageUrl;

  const ExperimentEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.exp,
    required this.safety,
    required this.materials,
    required this.path,
    this.tip,
    this.imageUrl,
  });
}
