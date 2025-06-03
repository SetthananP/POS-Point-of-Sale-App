import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

bool isDesktop(BuildContext context) {
  final platform = Theme.of(context).platform;
  final screenWidth = MediaQuery.of(context).size.width;

  return platform == TargetPlatform.macOS || platform == TargetPlatform.windows || platform == TargetPlatform.linux || (kIsWeb && screenWidth > 600);
}
