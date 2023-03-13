import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'facerec_viewmodel.dart';

class FaceRecView extends StatelessWidget {
  const FaceRecView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<FaceRecViewModel>.reactive(
      onViewModelReady: (model) => model.onModelReady(),
      builder: (context, model, child) {
        // print(model.node?.lastSeen);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Hardware'),
            actions: [
              // IconButton(
              //     onPressed: () {
              //       // Navigator.of(context)
              //       // .push(MaterialPageRoute(builder: (context) => MyApp()));
              //     },
              //     icon: Icon(Icons.speaker),
              // ),

              if (model.isHotspot && model.ip != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.developer_board, color: Colors.amber),
                ),
            ],
          ),
          floatingActionButton: model.ip != null
              ? FloatingActionButton(
                  onPressed: () {
                    model.work();
                  },
                  tooltip: 'camera',
                  child: Icon(Icons.camera_alt),
                )
              : null,
          body: Container(
              child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  if (model.isBusy) CircularProgressIndicator(),
                  if (model.imageSelected != null &&
                      model.imageSelected!.path != "")
                    Expanded(
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Image.memory(model.img!
                            // model.imageSelected!.readAsBytesSync(),
                            ),
                      ),
                    ),
                  if (model.labels.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Text(
                        model.labels.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // TextButton(
                  //   onPressed: () async {
                  //     await model.getImageFromHardware();
                  //     model.getLabel();
                  //     print("get label");
                  //   },
                  //   child: Text(
                  //     "Get label",
                  //   ),
                  // ),
                ]),
          )),
        );
      },
      viewModelBuilder: () => FaceRecViewModel(),
    );
  }
}
