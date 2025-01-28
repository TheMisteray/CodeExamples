import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_project_3/game_provider.dart';
import 'package:flutter_project_3/overlay_inventory.dart';
import 'package:flutter_project_3/overlay_map.dart';
import 'package:provider/provider.dart';

import 'game.dart';
import 'overlay_title.dart';
import 'overlay_main.dart';
import 'overlay_settings.dart';
import 'overlay_about.dart';
import 'overlay_lose.dart';
import 'overlay_win.dart';
import 'overlay_records.dart';

///
/// Project 3
/// Flutter App
/// I opted to create a game for this final project
///
/// @author Aiden Grieshaber
/// @version 1.0
/// @since 12/8/2024
/// 
/// notes:
/// See more in the About & Documentation pages
///

///
/// Enum for cardinal directions used by some navigation related components
///
enum Direction{
  up,
  down,
  left,
  right
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen();
  //runApp(const MainApp());
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const MainApp(),
    )
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Colors.white, fontSize: 62, fontWeight: FontWeight.bold, fontFamily: 'Charis'),
          displayMedium: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.normal, fontFamily: 'Charis'),
          displaySmall: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal, fontFamily: 'Charis'),
          labelMedium: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.normal, fontFamily: 'Scope'),
          labelSmall: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal, fontFamily: 'Charis'),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.normal, fontFamily: 'Charis'),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.normal, fontFamily: 'Scope'),
          bodySmall: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.normal, fontFamily: 'Scope'),
        )
      ),
      home: Main(),
    );
  }
}

class Main extends StatelessWidget {
  const Main({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget.controlled(
        gameFactory: () => MainGame(context)..paused = true,
        overlayBuilderMap: {
          'title': (_, game) {
            return OverlayTitle(game: game);
          },
          'main': (_, game) {
            return MainOverlay(context, game);
          },
          'pause': (_, game) {
            return SettingsOverlay(context, game);
          },
          'about': (_, game) {
            return AboutOverlay(context, game);
          },
          'settings': (_, game) {
            return SettingsOverlay(context, game);
          },
          'inventory': (_, game){
            return InventoryOverlay(context, game);
          },
          'map': (_, game){
            return MapOverlay(context, game);
          },
          'gameover': (_, game){
            return LoseOverlay(context, game);
          },
          'win': (_, game){
            return WinOverlay(context, game);
          },
          'records': (_, game){
            return recordsOverlay(context, game);
          }
        },
        initialActiveOverlays: const ['title'],
      ),
    );
  }
}
