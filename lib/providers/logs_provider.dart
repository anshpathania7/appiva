import 'package:appiva/models/log_model.dart';
import 'package:flutter/foundation.dart';

import '../repository/logs_repository.dart';

class LogsProvider extends ChangeNotifier {
  List<LogModel>? logs;
  bool isLoading = true;

  void _getAllLogs() async {
    logs = await LogsRepository().getAllLogs();
    isLoading = false;
    notifyListeners();
  }

  void init() async {
    _getAllLogs();
  }
}
