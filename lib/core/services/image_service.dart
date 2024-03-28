import 'package:get_it/get_it.dart';
import 'package:pujcovadlo_client/config.dart';
import 'package:pujcovadlo_client/core/requests/image_request.dart';
import 'package:pujcovadlo_client/core/responses/image_response.dart';
import 'package:pujcovadlo_client/core/services/http_service.dart';

class ImageService {
  final Config config = GetIt.instance.get<Config>();
  final HttpService http = GetIt.instance.get<HttpService>();

  Future<ImageResponse> createImage(String link, ImageRequest request) async {
    if (request.tmpFile == null) {
      throw Exception('File is not set');
    }

    final uri = Uri.parse(link);

    final response = await http.postFile(
      uri: uri,
      file: request.tmpFile!,
    );

    if (response.isSuccessCode) {
      // Convert to ImageResponse
      final imageResponse = ImageResponse.fromJson(response.data);

      // Convert request to already saved image
      makeImageSaved(request, imageResponse);

      return imageResponse;
    } else {
      throw Exception(
          'Failed to create image: ${response.statusCode} ${response.data}');
    }
  }

  Future<void> deleteImageByLink(String link) async {
    final uri = Uri.parse(link);

    final response = await http.delete(uri: uri);

    if (!response.isSuccessCode) {
      throw Exception(
          'Failed to delete image: ${response.statusCode} ${response.data}');
    }
  }

  void makeImageSaved(ImageRequest request, ImageResponse response) {
    // Update image request id
    request.id = response.id;
    request.deleteLink = response.getDeleteLink;

    // Dont delete the file becuase we may use it later
    // It should be deleted automatically by the system
  }
}
