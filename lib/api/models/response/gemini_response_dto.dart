class GeminiResponseDto {
  final List<Candidate> candidates;

  GeminiResponseDto({required this.candidates});

  factory GeminiResponseDto.fromJson(Map<String, dynamic> json) =>
      GeminiResponseDto(
        candidates: List<Candidate>.from(
          json["candidates"].map((x) => Candidate.fromJson(x)),
        ),
      );
}

class Candidate {
  final ContentResponse content;

  Candidate({required this.content});

  factory Candidate.fromJson(Map<String, dynamic> json) =>
      Candidate(content: ContentResponse.fromJson(json["content"]));
}

class ContentResponse {
  final List<PartResponse> parts;

  ContentResponse({required this.parts});

  factory ContentResponse.fromJson(Map<String, dynamic> json) =>
      ContentResponse(
        parts: List<PartResponse>.from(
          json["parts"].map((x) => PartResponse.fromJson(x)),
        ),
      );
}

class PartResponse {
  final String text;

  PartResponse({required this.text});

  factory PartResponse.fromJson(Map<String, dynamic> json) =>
      PartResponse(text: json["text"]);
}
