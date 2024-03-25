import 'dart:io';

import 'package:pujcovadlo_client/core/responses/image_response.dart';

class ImageRequest {
  int? id;

  File? tmpFile;

  bool isDeleted;

  String? previewLink;

  String? deleteLink;

  bool get isTemporary => id == null;

  factory ImageRequest.fromResponse(ImageResponse response) {
    return ImageRequest(
      id: response.id,
      previewLink: response.url,
      deleteLink: response.getDeleteLink,
    );
  }

  factory ImageRequest.fromFile(File file) {
    return ImageRequest(
      tmpFile: file,
    );
  }

  ImageRequest({
    this.id,
    this.tmpFile,
    this.isDeleted = false,
    this.previewLink,
    this.deleteLink,
  });
}
