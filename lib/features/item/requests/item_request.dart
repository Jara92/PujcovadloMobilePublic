import 'package:pujcovadlo_client/core/requests/image_request.dart';

class ItemRequest{
  int? id;
  String? name;
  String? description;

  List<ImageRequest> images;
  ImageRequest? mainImage;

  ItemRequest({
    this.id,
    this.name,
    this.description,
    this.images = const [],
    this.mainImage,
  });
}