import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;

import '../utils/enum.dart';

class PictureProvider extends ChangeNotifier {
  String? _imagePath;
  XFile? _imageFile;

  String? get imagePath => _imagePath;
  XFile? get imageFile => _imageFile;
  ResultState? state;

  void setImagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }

  void clearImage() {
    _imagePath = null;
    _imageFile = null;
    notifyListeners();
  }

  void openGalleryView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    state = ResultState.loading;
    notifyListeners();

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }

    state = ResultState.success;
    notifyListeners();
  }

  void openCameraView() async {
    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    state = ResultState.loading;
    notifyListeners();

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      setImageFile(pickedFile);
      setImagePath(pickedFile.path);
    }

    state = ResultState.success;
    notifyListeners();
  }
}
