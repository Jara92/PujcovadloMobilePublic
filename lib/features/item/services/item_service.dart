import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/requests/image_request.dart';
import 'package:pujcovadlo_client/core/responses/response_list.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';
import 'package:pujcovadlo_client/core/services/image_service.dart';
import 'package:pujcovadlo_client/features/item/filters/item_filter.dart';

import '../requests/item_request.dart';
import '../responses/item_detail_response.dart';
import '../responses/item_response.dart';

class ItemService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();
  final ImageService imageService = GetIt.instance.get<ImageService>();

  Future<ResponseList<ItemResponse>> getItems({ItemFilter? filter}) {
    filter ??= ItemFilter();

    var uri = Uri.parse("${config.apiEndpoint}/items")
        .replace(queryParameters: filter.toMap());

    return _getItemsByUri(uri);
  }

  Future<ResponseList<ItemResponse>> getItemsByUri(String uri) {
    return _getItemsByUri(Uri.parse(uri));
  }

  Future<ResponseList<ItemResponse>> _getItemsByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ResponseList<ItemResponse>.fromJson(
          response.data, ItemResponse.fromJson);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load items: ${response.statusCode} ${response.data}');
    }
  }

  Future<ItemDetailResponse> getItemByUri(String uri) {
    return _getItemByUri(Uri.parse(uri));
  }

  Future<ItemDetailResponse> getItemById(int id) async {
    return _getItemByUri(Uri.parse("${config.apiEndpoint}/items/$id"));
  }

  Future<ItemDetailResponse> _getItemByUri(Uri uri) async {
    final response = await http.get(uri: uri);

    // Parse JSON if the server returned a 200 OK response
    if (response.isSuccessCode) {
      var data = ItemDetailResponse.fromJson(response.data);

      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(
          'Failed to load item: ${response.statusCode} ${response.data}');
    }
  }

  Future<ItemDetailResponse> createItem(ItemRequest request) async {
    Uri uri = Uri.parse("${config.apiEndpoint}/items");

    var response = await http.post(
      uri: uri,
      body: request.toJson(),
    );

    if (response.isSuccessCode) {
      // Parse JSON to response
      final itemResponse = ItemDetailResponse.fromJson(response.data);

      // Update item request id so we can do update if something fails now
      request.id = itemResponse.id;
      request.updateLink = itemResponse.updateLink;

      // Check if create image link is set
      if (itemResponse.createImageLink == null) {
        throw Exception('Create image link is not set');
      }

      // Upload images
      for (var imgRequest in request.images) {
        // Skip deleted images (there should be none)
        if (imgRequest.isDeleted) continue;

        // Skip non-temporary images (there should be none)
        if (imgRequest.isTemporary == false || imgRequest.tmpFile == null)
          continue;

        // Save new image
        final imageResponse = await imageService.createImage(
            itemResponse.createImageLink!, imgRequest);

        // add image to the item
        itemResponse.images.add(imageResponse);
      }

      // If default main image does not match the request main image
      if (itemResponse.mainImage?.id != request.mainImage?.id) {
        // set main image id
        request.mainImageId = request.mainImage?.id;

        // Update main image
        final updateResponse = await http.put(
            uri: Uri.parse(itemResponse.updateLink!), body: request.toJson());

        // throw an exception if the server did not return a 200 OK response
        if (!updateResponse.isSuccessCode) {
          throw Exception(
              'Failed to update item: ${updateResponse.statusCode} ${updateResponse.data}');
        }
      }

      // return item response with images
      return itemResponse;
    } else {
      throw Exception(
          'Failed to create item: ${response.statusCode} ${response.data}');
    }
  }

  Future<void> updateItem(ItemRequest request) async {
    // There must be an update link
    if (request.updateLink == null) {
      throw Exception('Update link is not set');
    }

    // Sync images first
    for (var imgRequest in request.images) {
      // Delete image if it is marked as deleted
      if (imgRequest.isDeleted) {
        await deleteImage(imgRequest);
        continue;
      }

      // Skip non-temporary images
      if (imgRequest.isTemporary == false || imgRequest.tmpFile == null)
        continue;

      // Save new image
      final imageResponse =
          await imageService.createImage(request.createImageLink!, imgRequest);

      // Set image request id
      imgRequest.id = imageResponse.id;
    }

    // All images should have their ID set
    if (request.mainImage != null) {
      request.mainImageId = request.mainImage!.id;
    }

    // Update item on the server
    Uri uri = Uri.parse(request.updateLink!);

    var response = await http.put(
      uri: uri,
      body: request.toJson(),
    );

    // throw an exception if the server did not return a 200 OK response
    if (!response.isSuccessCode) {
      throw Exception(
          'Failed to update item: ${response.statusCode} ${response.data}');
    }
  }

  Future<void> deleteItem(int id) async {
    // Delete item on the server
    throw UnimplementedError();
  }

  ItemRequest responseToRequest(ItemDetailResponse itemDetailResponse) {
    return ItemRequest(
      id: itemDetailResponse.id,
      name: itemDetailResponse.name,
      description: itemDetailResponse.description,
      pricePerDay: itemDetailResponse.pricePerDay,
      refundableDeposit: itemDetailResponse.refundableDeposit,
      sellingPrice: itemDetailResponse.sellingPrice,
      latitude: itemDetailResponse.latitude,
      longitude: itemDetailResponse.longitude,
      categories: itemDetailResponse.categories.map((e) => e.id).toList(),
      tags: itemDetailResponse.tags.map((e) => e.name).toList(),
      // Convert each image response to request
      images: itemDetailResponse.images
          .map((e) => ImageRequest.fromResponse(e))
          .toList(),
      // Convert main image using the same
      mainImage: itemDetailResponse.mainImage != null
          ? ImageRequest.fromResponse(itemDetailResponse.mainImage!)
          : null,
      mainImageId: itemDetailResponse.mainImage?.id,
      createImageLink: itemDetailResponse.createImageLink,
      updateLink: itemDetailResponse.updateLink,
    );
  }

  Future<void> deleteImage(ImageRequest image) async {
    if (image.deleteLink == null) {
      throw Exception('Delete link is not set');
    }

    await imageService.deleteImageByLink(image.deleteLink!);
  }
}
