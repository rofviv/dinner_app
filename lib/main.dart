import 'package:flutter/material.dart';
import 'package:flutter_fullscreen/flutter_fullscreen.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:overlay_support/overlay_support.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await FullScreen.ensureInitialized();
  runApp(
    OverlaySupport.global(
      child: ModularApp(
        module: AppModule(),
        child: const AppWidget(),
      ),
    ),
  );
}