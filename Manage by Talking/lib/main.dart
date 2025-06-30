import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skd1/db/db_helper.dart';
import 'package:skd1/services/theme_services.dart';
import 'package:skd1/ui/home_page.dart';
import 'package:skd1/ui/theme.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import "package:get_storage/get_storage.dart";
import "package:get/get.dart";
import 'package:skd1/services/notification_services.dart'; // NotifyHelper import edildi

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  
  // NotifyHelper'ı başlat
  await NotifyHelper.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.light,
      darkTheme: Themes.dark,
      themeMode: ThemeServices().theme,
      home: HomePage(),
      builder: (context, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final bgColor = theme.scaffoldBackgroundColor;
        SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(
            statusBarColor: theme.appBarTheme.backgroundColor ?? bgColor,
            statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
            systemNavigationBarColor: bgColor,
            systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
            systemNavigationBarContrastEnforced: false,
          ),
        );
        return child!;
      },
    );
  }
}