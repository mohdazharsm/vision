import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vision/ui/setup_snackbar_ui.dart';
import 'package:wifi_iot/wifi_iot.dart';

import 'package:stacked/stacked.dart';
import 'package:vision/services/imageprocessing_service.dart';
import 'package:stacked_services/stacked_services.dart';
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

  final _snackBarService = locator<SnackbarService>();
  final TTSService _ttsService = locator<TTSService>();
  final ImageProcessingService _imageProcessingService =
      locator<ImageProcessingService>();
  // final _navigationService = locator<NavigationService>();

  File? _image;
  File? get imageSelected => _image;

  List<String> _labels = <String>[];
  List<String> get labels => _labels;

  String? _ip;
  String? get ip => _ip;
  bool _isHotspot = false;
  bool get isHotspot => _isHotspot;

  void onModelReady() async {
    setBusy(true);
    log.i("Model ready");
    _isHotspot = await WiFiForIoTPlugin.isWiFiAPEnabled();
    log.i("Hotspot: $_isHotspot");
    if (_isHotspot) {
      showClientListAndGetIP();
    } else {
      // _ip = "192.168.43.199";
      _ip = "192.168.149.87";
      setBusy(false);
    }
  }

  void work() async {
    setBusy(true);
    await getImageFromHardware();
    setBusy(false);
    await getLabel();
  }

  Future getLabel() async {
    log.i("Getting label");
    _labels = <String>[];

    _labels = await _imageProcessingService.getTextFromImage(_image!);

    notifyListeners();

    String text = _imageProcessingService.processLabels(_labels);
    log.i("SPEAK");
    await _ttsService.speak(text);
    return Future.delayed(const Duration(milliseconds: 1000));
  }

  Uint8List? _img;
  Uint8List? get img => _img;

  bool _isCalled = false;

  Future getImageFromHardware() async {
    _isCalled = true;

    Uri uri = Uri(
      scheme: 'http',
      host: ip!,
      path: '/jpg',
    );

    http.Response response = await http.get(uri);
    //calling twise for skipping image
    if (_isCalled) response = await http.get(uri);

    if (_image != null) {
      _image!.delete();
    } else {
      final directory = await getApplicationDocumentsDirectory();
      _image = await File('${directory.path}/image.png').create();
    }
    _img = response.bodyBytes;
    return _image!.writeAsBytes(_img!);
  }

  void showClientListAndGetIP() async {
    log.i("Get clients");

    /// Refresh the list and show in console
    _getClientList(false, 300).then((val) => val.forEach((oClient) {
          if (oClient.isReachable != null && oClient.isReachable!) {
            _ip = oClient.ipAddr;
            log.i(_ip);
            setBusy(false);
            _snackBarService.showCustomSnackBar(
                message: "Connected to IP: $_ip",
                variant: SnackbarType.success);
          } else {
            if (_ip == null)
              _snackBarService.showCustomSnackBar(
                  message: "No devices found", variant: SnackbarType.error);
          }
          log.i("************************");
          log.i("Client :");
          log.i("ipAddr = '${oClient.ipAddr}'");
          log.i("hwAddr = '${oClient.hwAddr}'");
          log.i("device = '${oClient.device}'");
          log.i("isReachable = '${oClient.isReachable}'");
          log.i("************************");
        }));
  }

  Future<List<APClient>> _getClientList(
      bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;

    try {
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } catch (e) {
      htResultClient = <APClient>[];
    }

    return htResultClient;
  }
}
