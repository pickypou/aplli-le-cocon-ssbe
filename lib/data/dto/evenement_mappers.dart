// evenement_mappers.dart

import '../../domain/entity/evenements.dart';
import 'evenement_dto.dart';

extension EvenementDtoMapper on EvenementDto {
  Evenements toEntity() {
    return Evenements(
      id: id,
      title: fileName,
      fileUrl: fileUrl,
      fileType: fileType,
      thumbnailUrl: null, // Conversion en Uint8List si nécessaire
      publishDate: publishDate,
    );
  }
}

extension EvenementsMapper on Evenements {
  EvenementDto toDto() {
    return EvenementDto(
      id: id,
      fileUrl: fileUrl,
      fileType: fileType,
      fileName: title,
      thumbnailUrl: null, // Conversion en String si nécessaire
      publishDate: publishDate,
    );
  }
}
