import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File?> compressImage(XFile file) async {
  try {

    final originalPath = file.path;
    final originalFile = File(originalPath);
    final fileName = originalFile.uri.pathSegments.last;

    final originalSize = await originalFile.length();
    debugPrint('🟡 Original size: ${(originalSize / 1024).toStringAsFixed(2)} KB');

    final tempDir = await getTemporaryDirectory();
    final tempPath = '${tempDir.path}/compressed_$fileName';

    final String ext = fileName.split('.').last.toLowerCase();
    CompressFormat format;

    if (ext == 'png') {
      format = CompressFormat.png;
    } else {
      format = CompressFormat.jpeg; // default jpg/jpeg
    }


    final XFile? result = await FlutterImageCompress.compressAndGetFile(
        originalPath,
        tempPath,
        quality: 30,
        format: format
    );

    if (result == null) {
      debugPrint('❌ Compression failed: result is null');
      return null;
    }

    final compressedFile = File(result.path);
    await compressedFile.copy(originalPath);

    final compressedSize = await compressedFile.length();
    debugPrint('🟢 Compressed size: ${(compressedSize / 1024).toStringAsFixed(2)} KB');

    await compressedFile.delete();

    return originalFile;
  } catch (e) {
    debugPrint('Compression failed: $e');
    return null;
  }
}
