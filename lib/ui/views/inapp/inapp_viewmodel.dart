import 'dart:async';
import 'dart:io';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vision/ui/setup_snackbar_ui.dart';
// import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
// import '../../setup_snackbar_ui.dart';

class HomeViewModel extends BaseViewModel {
  final log = getLogger('HomeViewModel');

  final _snackBarService = locator<SnackbarService>();
  final _navigationService = locator<NavigationService>();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  // XFile? get imageFile => _imageFile;
  File? _image;
  File? get imageSelected => _image;
  InputImage? _inputImage;

  getImageGallery() async {
    setBusy(true);
    // picking image
    _imageFile = await _picker.pickImage(source: ImageSource.camera);

    if (_imageFile != null) {
      _image = File(_imageFile!.path);
    } else {
      _snackBarService.showCustomSnackBar(
          message: "No images selected", variant: SnackbarType.error);
    }
    setBusy(false);
  }

  List<String> _labels = <String>[];
  List<String> get labels => _labels;

  void getLabel() async {
    log.i("Getting label");
    _labels = <String>[];

    final inputImage = InputImage.fromFilePath(_imageFile!.path);
    final ImageLabelerOptions options =
        ImageLabelerOptions(confidenceThreshold: 0.5);
    final imageLabeler = ImageLabeler(options: options);

    final List<ImageLabel> labels = await imageLabeler.processImage(inputImage);

    for (ImageLabel label in labels) {
      final String text = label.label;
      final int index = label.index;
      final double confidence = label.confidence;
      log.i("$index $text $confidence");
      // if (confidence > 0.65) {
      _labels.add(text);
      // }
    }

    imageLabeler.close();

    notifyListeners();

    for (String text in _labels) {
      log.i("SPEAK");
      await speak(text);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  FlutterTts flutterTts = FlutterTts();
  // TtsState _ttsState = TtsState.stopped;
  // TtsState get ttsState => _ttsState;

  Future speak(String text) async {
    var result = await flutterTts.speak(text);
    if (result == 1) {
      // _ttsState = TtsState.playing;
      // notifyListeners();
    }
  }
  //
  // Future stop() async {
  //   var result = await flutterTts.stop();
  //   if (result == 1) {
  //     _ttsState = TtsState.stopped;
  //     notifyListeners();
  //   }
  // }

  // _loadImage(File file) async {
  //   final data = await file.readAsBytes();
  //   await decodeImageFromList(data).then((value) => setState(() {
  //     _image = value;
  //     isLoading = false;
  //   }));
  // }

  @override
  void dispose() {
    super.dispose();
  }
}
