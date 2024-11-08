

class EvenementDto {
  final String id;
  final String fileUrl;
  final String fileType;
  final String fileName;
  final String? thumbnailUrl;
  final DateTime publishDate;

  EvenementDto({
    required this.id,
    required this.fileUrl,
    required this.fileType,
    required this.fileName,
    this.thumbnailUrl,
    required this.publishDate,
  });

  factory EvenementDto.fromJson(Map<String, dynamic> json) {
    return EvenementDto(
      id: json['id'],  // Correction de 'is' à 'id'
      fileUrl: json['fileUrl'],
      fileType: json['fileType'],
      fileName: json['fileName'],
      thumbnailUrl: json['thumbnailUrl'],
      publishDate: DateTime.parse(json['publishDate']),  // Conversion au format DateTime
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'fileName': fileName,
      'thumbnailUrl': thumbnailUrl,
      'publishDate': publishDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'EvenementDto{id: $id, fileUrl: $fileUrl, fileType: $fileType, fileName: $fileName, thumbnailUrl: $thumbnailUrl, publishDate: $publishDate}';
  }
}