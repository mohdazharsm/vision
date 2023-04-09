import 'dart:async';
import 'dart:io';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vision/services/regula_service.dart';
import 'package:vision/services/tts_service.dart';
import 'package:vision/ui/setup_snackbar_ui.dart';

import '../../../app/app.locator.dart';
import '../../../app/app.logger.dart';
import '../../../services/imageprocessing_service.dart';

class InAppViewModel extends BaseViewModel {
  final log = getLogger('InAppViewModel');

  final _snackBarService = locator<SnackbarService>();
  // final _navigationService = locator<NavigationService>();
  final TTSService _ttsService = locator<TTSService>();
  final ImageProcessingService _imageProcessingService =
      locator<ImageProcessingService>();
  final _ragulaService = locator<RegulaService>();

  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  File? _image;
  File? get imageSelected => _image;
  InputImage? _inputImage;

  getImageCamera() async {
    setBusy(true);
    // picking image
    _imageFile = await _picker.pickImage(source: ImageSource.camera);

    if (_imageFile != null) {
      log.i("CCC");
      // _dlibService.addImageFace(await _imageFile!.readAsBytes());
      _image = File(_imageFile!.path);
    } else {
      _snackBarService.showCustomSnackBar(
          message: "No images selected", variant: SnackbarType.error);
    }
    setBusy(false);
  }

  getImageGallery() async {
    setBusy(true);
    // picking image
    _imageFile = await _picker.pickImage(source: ImageSource.gallery);

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

    _labels = await _imageProcessingService.getTextFromImage(_image!);

    notifyListeners();

    String text = _imageProcessingService.processLabels(_labels);
    log.i("SPEAK");
    await _ttsService.speak(text);
    // return Future.delayed(const Duration(milliseconds: 1000));
    if (text == "Person detected") processFace();
  }

  void processFace() async {
    _ttsService.speak("Identifying person");
    double? v = await _ragulaService.checkMatch(_imageFile!.path);
    log.i(v);
  }

  Future speak(String text) async {
    _ttsService.speak(text);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
