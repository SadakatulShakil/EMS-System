import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum ConnectivityStatus {
  Online,
  Offline
}

class ConnectivityProvider extends ChangeNotifier {
  late Connectivity _connectivity;
  late ConnectivityStatus _status;

  ConnectivityProvider() {
    _connectivity = Connectivity();
    _status = ConnectivityStatus.Online;
    _init();
  }

  Future<void> _init() async {
    await _updateConnectivityStatus();
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _updateConnectivityStatus(result);
    });
  }

  Future<void> _updateConnectivityStatus([ConnectivityResult? result]) async {
    ConnectivityResult connectivityResult = result ?? await _connectivity.checkConnectivity();

    if (connectivityResult == ConnectivityResult.wifi) {
      bool hasDataConnectivity = await _checkDataConnectivity();
      _status = hasDataConnectivity
          ? ConnectivityStatus.Online
          : ConnectivityStatus.Offline;
    } else if (connectivityResult == ConnectivityResult.mobile) {
      bool hasDataConnectivity = await _checkDataConnectivity();
      _status = hasDataConnectivity
          ? ConnectivityStatus.Online
          : ConnectivityStatus.Offline;
    } else if (connectivityResult == ConnectivityResult.none) {
      _status = ConnectivityStatus.Offline;
    }
    notifyListeners();
  }

  Future<bool> _checkDataConnectivity() async {
    try {
      final response = await http.get(Uri.parse('https://www.google.com'));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  ConnectivityStatus get status => _status;
}
