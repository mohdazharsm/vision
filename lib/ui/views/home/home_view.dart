import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:video_player/video_player.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      // onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Vision'),
            actions: [
              IconButton(
                onPressed: () {
                  print("icon b");
                  model.speak("This is test speech output");
                },
                icon: Icon(Icons.volume_up),
              ),
              IconButton(
                onPressed: () {
                  print("icon c");
                  model.fetchDataFromApi();
                },
                icon: Icon(Icons.cloud_download),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              model.getImageGallery();
            },
            tooltip: 'camera',
            child: Icon(Icons.add_a_photo),
          ),
          body: model.isBusy
              ? Center(child: CircularProgressIndicator())
              : Center(
                  child: Container(
                    child: model.imageSelected != null
                        ? Column(
                            children: [
                              Expanded(child: Image.file(model.imageSelected!)),
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
                          )
                        :
                        // Image.network("http://192.168.29.199/")
                        Container(
                            height: 240,
                            width: 320,
                            child: WebViewWidget(
                              controller: model.controller,
                            ),
                          ),
                  ),
                ),
        );
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
