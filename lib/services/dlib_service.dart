import 'dart:typed_data';
import 'dart:ui';

import 'package:stacked_services/stacked_services.dart';
import 'package:flutter_opencv_dlib/flutter_opencv_dlib.dart';
import 'package:stacked/stacked.dart';
import '../app/app.locator.dart';
import '../app/app.logger.dart';
import '../ui/setup_snackbar_ui.dart';

import 'package:image/image.dart' as IMG;

class DlibService with ListenableServiceMixin {
  final log = getLogger('DlibService');
  final _snackBarService = locator<SnackbarService>();

  RecognizerInterface _recognizerInterface = RecognizerInterface();

  //is initialised
  bool _recognizerInitialized = false;

  bool get recognizerInitialized => _recognizerInitialized;

  //face image
  Uint8List? _faceImage;
  Uint8List? get faceImage => _faceImage;

  void init() async {
    log.i("Initializing dlib");
    _recognizerInitialized = await _recognizerInterface.initRecognizer();
    _recognizerInterface.setInputColorSpace(ColorSpace.SRC_GRAY);
    _recognizerInterface.setRotation(1);
  }

  // * called when a face is added
  void setupFaceAddedListener() {
    _recognizerInterface.streamAddFaceController.stream.listen((addedFaceImg) {
      // fpsDlib++;
      if (addedFaceImg.face.isNotEmpty) {
        log.i("Added");
        _faceImage = addedFaceImg.face;
        if (!addedFaceImg.alreadyExists) {
          // faceID++;
        }
        notifyListeners();
      }
      if (addedFaceImg.alreadyExists) {
        _snackBarService.showCustomSnackBar(
            message: 'FACE ALREADY EXISTS', variant: SnackbarType.success);
      } else {
        _snackBarService.showCustomSnackBar(
            message: 'FACE ADDED ${addedFaceImg.name}',
            variant: SnackbarType.error);
      }
    });
  }

  // * called when a face(s) is recognized
  void setupFaceRecognizedListener() {
    _recognizerInterface.streamCompareFaceController.stream.listen((faces) {
      // fpsDlib++;
      if (faces.isNotEmpty && faces[0].face.isNotEmpty) {
        log.i("Face is recognized");
        _faceImage = faces[0].face;
        // List<int> points = [];
        // for (var element in faces) {
        //   points.addAll(element.rectPoints);
        // }

        // _points.value = FacePoints(
        //   faces.length,
        //   2,
        //   points,
        //   List.generate(faces.length, (index) => faces[index].name),
        // );
      }
    });
  }

  void addImageFace(Uint8List img) async {
    log.i("Add image");
    IMG.Image? image = IMG.decodeImage(img);
    final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(img);
    final imDescr = await ImageDescriptor.encoded(buffer);
    // image.channels = ;
    log.d("Bytesperpixel: ${imDescr.bytesPerPixel}");
    try {
      RecognizedFace? recognizedFace = await _recognizerInterface.addFace(
        image?.width ?? 544,
        image?.height ?? 725,
        // 1,
        imDescr.bytesPerPixel,
        "Azhar",
        img,
        // image!.getBytes(format: IMG.Format.rgb),
      );
      log.e(recognizedFace?.name ?? "Not added");
    } catch (e) {
      log.e(e);
    }
  }

  void compareImageFace(Uint8List img) async {
    log.i("Compare image");
    RecognizedFace? recognizedFace =
        await _recognizerInterface.compareFace(544, 725, 1, img);
    log.e(recognizedFace?.name ?? "Not added");
  }

  Future<Uint8List?> getAdjustedImageD(Uint8List img) async {
    log.i("Adjusted image");
    IMG.Image? image = IMG.decodeImage(img);
    final ImmutableBuffer buffer = await ImmutableBuffer.fromUint8List(img);
    final imDescr = await ImageDescriptor.encoded(buffer);
    // image.channels = ;
    log.d("Bytesperpixel: ${imDescr.bytesPerPixel}");
    try {
      return _recognizerInterface.getAdjustedSource(
        image?.width ?? 544,
        image?.height ?? 725,
        // 1,
        imDescr.bytesPerPixel,
        img,
        // image!.getBytes(format: IMG.Format.rgb),
      );
      // log.e(recognizedFace?.name ?? "Not added");
    } catch (e) {
      log.e(e);
    }
    return null;
  }
}
