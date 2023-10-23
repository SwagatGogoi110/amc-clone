import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final downloadsDirectory = await getExternalStorageDirectory();

    if (downloadsDirectory != null) {
      final file = File('${downloadsDirectory.path}/$name');

      await file.writeAsBytes(bytes);
      return file;
    } else {
      throw Exception('Downloads directory not found');
    }
  }

  static Future openFile(File file) async {
    final url = file.path;
    print('File path: $url');
    await OpenFile.open(url);
  }
}
