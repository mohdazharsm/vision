import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:stacked/stacked.dart';
import 'package:vision/services/imageprocessing_service.dart';
// import 'package:stacked_services/stacked_services.dart';
import 'package:vision/services/tts_service.dart';
// import 'package:vision/ui/setup_snackbar_ui.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';

//main.dart
import "dart:async";

import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

class HardwareViewModel extends BaseViewModel {
  final log = getLogger('HardwareViewModel');

  // final _snackBarService = locator<SnackbarService>();
  final TTSService _ttsService = locator<TTSService>();
  final ImageProcessingService _imageProcessingService =
      locator<ImageProcessingService>();
  // final _navigationService = locator<NavigationService>();

  File? _image;
  File? get imageSelected => _image;

  List<String> _labels = <String>[];
  List<String> get labels => _labels;

  void getLabel() async {
    log.i("Getting label");
    _labels = <String>[];

    _labels = await _imageProcessingService.getTextFromImage(_image!);

    notifyListeners();

    for (String text in _labels) {
      log.i("SPEAK");
      await _ttsService.speak(text);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  ScreenshotController screenshotController = ScreenshotController();

  void takeScreenCapture() async {
    _labels = <String>[];
    notifyListeners();
    _image = null;
    await screenshotController
        .capture(delay: const Duration(milliseconds: 10))
        .then((Uint8List? image) async {
      if (image != null) {
        final directory = await getApplicationDocumentsDirectory();
        _image = await File('${directory.path}/image$_count.png').create();
        await _image!.writeAsBytes(image);
      }
    });
    notifyListeners();
  }

  late InAppWebViewController webView;
  Uint8List? screenshotBytes;
  final _authority = "google.com";
  final _path = "/api";
  Uri uri = Uri.http(
    "192.168.110.87",
  );

  int _count = 0;
  int get count => _count;

  Future<void> takeScreenshot() async {
    _count++;
    _image = null;
    final image = await webView.takeScreenshot();
    if (image != null) {
      final directory = await getApplicationDocumentsDirectory();
      _image = await File('${directory.path}/image.png').create();
      await _image!.writeAsBytes(image);
    }
    await Future.delayed(const Duration(milliseconds: 500));
    notifyListeners();
  }

  void addDataToStream() {
    log.i("Add data");
    http.get(uri).then((response) {
      log.i(response);
      dom.Document document = parser.parse(response.body);
      final e = document.querySelectorAll('.img_list .thumb');
      List<String?> url = e.map((element) {
        return element.getElementsByTagName('img')[0].attributes['src'];
      }).toList();
      // bloc.urlIn.add(url);
      log.i(url);
    });
  }

  void isHotspot() {
    WiFiForIoTPlugin.isWiFiAPEnabled().then((val) {
      log.i(val ? "Hotspot eabled" : "No hostpot");
    }).catchError((val) {
      log.e("error");
    });
  }
}
