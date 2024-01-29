import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fpdart/fpdart.dart';

Task<XFile?> pickImage() {
  final picker = ImagePicker();
  return Task(() async => picker.pickImage(source: ImageSource.gallery));
}

TaskEither<Unit, Uint8List> pickAndReadImageToBytes() {
  return TaskEither.tryCatch(() async {
    final imageFile = await pickImage().run();
    return imageFile!.readAsBytes();
  }, (error, stackTrace) => unit);
}
