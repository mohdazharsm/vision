


//   Future<List<APClient>> getClientList(
//       bool onlyReachables, int reachableTimeout) async {
//     List<APClient> htResultClient;

//     try {
//       htResultClient = await WiFiForIoTPlugin.getClientList(
//           onlyReachables, reachableTimeout);
//     } on PlatformException {
//       htResultClient = <APClient>[];
//     }

//     return htResultClient;
//   }

//     void showClientList() async {
//     /// Refresh the list and show in console
//     getClientList(false, 300).then((val) => val.forEach((oClient) {
//           print("************************");
//           print("Client :");
//           print("ipAddr = '${oClient.ipAddr}'");
//           print("hwAddr = '${oClient.hwAddr}'");
//           print("device = '${oClient.device}'");
//           print("isReachable = '${oClient.isReachable}'");
//           print("************************");
//         }));
//   }