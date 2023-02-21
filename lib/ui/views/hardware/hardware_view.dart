import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stacked/stacked.dart';

import 'hardware_viewmodel.dart';

class HardwareView extends StatelessWidget {
  const HardwareView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HardwareViewModel>.reactive(
      // onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Screenshot(
          controller: model.screenshotController,
          child: WebviewScaffold(
            url: "http://192.168.83.87/",
            // url: "https://google.com",
            appBar: AppBar(
              title: const Text('Hardware'),
              actions: [
                IconButton(
                  onPressed: () {
                    print("icon b");
                    // model.speak("This is test speech output");
                    model.takeScreenCapture();
                  },
                  icon: Icon(Icons.volume_up),
                ),
              ],
            ),
            // floatingActionButton: FloatingActionButton(
            //   onPressed: () {
            //     model.getImageGallery();
            //   },
            //   tooltip: 'camera',
            //   child: Icon(Icons.add_a_photo),
            // ),
            // body: model.isBusy
            //     ? Center(child: CircularProgressIndicator())
            //     : Center(
            //         child: Container(
            //             child: model.imageSelected != null
            //                 ? Column(
            //                     children: [
            //                       Expanded(
            //                           child: Image.file(model.imageSelected!)),
            //                       if (model.labels.isNotEmpty)
            //                         Padding(
            //                           padding: const EdgeInsets.all(8.0),
            //                           child: Text(
            //                             model.labels.toString(),
            //                             textAlign: TextAlign.center,
            //                             style: TextStyle(
            //                               fontWeight: FontWeight.bold,
            //                             ),
            //                           ),
            //                         ),
            //                       TextButton(
            //                         onPressed: () {
            //                           model.getLabel();
            //                           print("get label");
            //                         },
            //                         child: Text(
            //                           "Get label",
            //                         ),
            //                       ),
            //                     ],
            //                   )
            //                 : Text("No images selected!")
            //             // Image.network("http://192.168.29.199/")
            //             ),
            //       ),
          ),
        );
      },
      viewModelBuilder: () => HardwareViewModel(),
    );
  }
}
