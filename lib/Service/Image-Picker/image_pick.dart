import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  Future<String?> getImageFromCamera() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? response =
          await picker.pickImage(source: ImageSource.camera);

      if (response != null) {
        return response.path;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<String?> getImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? response =
          await picker.pickImage(source: ImageSource.gallery);

      if (response != null) {
        return response.path;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

}
