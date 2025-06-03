import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:pretest/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const PretestApp());
}
