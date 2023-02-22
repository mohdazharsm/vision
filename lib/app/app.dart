import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:vision/services/imageprocessing_service.dart';
import 'package:vision/services/tts_service.dart';
import 'package:vision/ui/views/hardware/hardware_view.dart';
import 'package:vision/ui/views/inapp/inapp_view.dart';

import '../ui/views/home/home_view.dart';
import '../ui/views/startup/startup_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView, path: '/home'),
    MaterialRoute(page: InAppView, path: '/inapp'),
    MaterialRoute(page: HardwareView, path: '/hardware'),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: TTSService),
    LazySingleton(classType: ImageProcessingService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
