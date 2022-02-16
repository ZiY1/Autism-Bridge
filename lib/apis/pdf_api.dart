import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'dart:io';
import 'package:pdf/widgets.dart';
import 'package:open_file/open_file.dart';

class PdfApi {
  static Future<File> saveDocument(
      {required String name, required Document pdf}) async {
    // save the pdf
    final bytes = await pdf.save();

    // store in the local storage
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  // TODO: not working in my emulator
  static Future<void> openFile(File file) async {
    final url = file.path;

    final result = await OpenFile.open(url);
  }
}
