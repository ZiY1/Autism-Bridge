import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'num_constants.dart';

class RegularHelpers {
  static Future<File> urlToFile(String imageUrl) async {
    // generate random number.
    var rng = Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = File(tempPath + (rng.nextInt(100)).toString() + '.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get(Uri.parse(imageUrl));
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  static double getSalaryAsNumberStr(String salaryStr) {
    if (salaryStr == 'None') {
      return kNone;
    } else if (salaryStr.isEmpty) {
      return kEmpty;
    } else if (salaryStr[0] == '<' || salaryStr[0] == '>') {
      // get rid of the start '<' or '>', and the end 'k'
      return double.parse(salaryStr.substring(1, salaryStr.length - 1));
    } else {
      // get rid of the end 'k'
      return double.parse(salaryStr.substring(0, salaryStr.length - 1));
    }
  }
}
