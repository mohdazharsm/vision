import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
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
        return Scaffold(
          appBar: AppBar(
            title: const Text('Hardware'),
          ),
          floatingActionButton: model.imageSelected == null
              ? FloatingActionButton(
                  onPressed: () {
                    model.takeScreenshot();
                  },
                  tooltip: 'camera',
                  child: Icon(Icons.screenshot),
                )
              : null,
          body: model.imageSelected == null
              ? Container(
                  child: Column(children: <Widget>[
                  Expanded(
                      child: InAppWebView(
                    initialUrlRequest: URLRequest(url: model.uri),
                    // initialUrl: "https://github.com/flutter",
                    // initialHeaders: {},
                    initialOptions: InAppWebViewGroupOptions(
                        // crossPlatform: InAppWebViewOptions(debuggingEnabled: true),
                        ),
                    onWebViewCreated: (InAppWebViewController controller) {
                      model.webView = controller;
                    },
                    onLoadStart:
                        (InAppWebViewController controller, Uri? url) {},
                    onLoadStop:
                        (InAppWebViewController controller, Uri? url) async {
                      // model.screenshotBytes = await controller.takeScreenshot();
                      // showDialog(
                      //   context: context,
                      //   builder: (context) {
                      //     return AlertDialog(
                      //       content: Image.memory(model.screenshotBytes!),
                      //     );
                      //   },
                      // );
                    },
                  ))
                ]))
              : Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.file(
                        key: ValueKey(model.count),
                        model.imageSelected!,
                      ),
                    ),
                    if (model.labels.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          model.labels.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    TextButton(
                      onPressed: () {
                        model.getLabel();
                        print("get label");
                      },
                      child: Text(
                        "Get label",
                      ),
                    ),
                  ],
                ),
        );
      },
      viewModelBuilder: () => HardwareViewModel(),
    );
  }
}
