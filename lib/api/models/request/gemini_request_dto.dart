class GeminiRequestDto {
  final List<Content> contents;

  GeminiRequestDto({required this.contents});

  Map<String, dynamic> toJson() => {
    "contents": contents.map((x) => x.toJson()).toList(),
  };
}

class Content {
  final String role;
  final List<Part> parts;

  Content({required this.role, required this.parts});

  Map<String, dynamic> toJson() => {
    "role": role,
    "parts": parts.map((x) => x.toJson()).toList(),
  };
}

class Part {
  final String text;

  Part({required this.text});

  Map<String, dynamic> toJson() => {"text": text};
}
