import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flutter_project_3/main.dart';
import 'package:provider/provider.dart';
import 'game_provider.dart';
import 'classes.dart';

///
/// Main Game
///
class MainGame extends FlameGame with WidgetsBindingObserver{
  MainGame(this.context);
  final BuildContext context;
  late final gameProvider;
  // Currently no need to reference these
  late ArrowButton upArrow;
  late ArrowButton downArrow;
  late ArrowButton leftArrow;
  late ArrowButton rightArrow;
  late Event currentEvent;
  bool gameEnd = false;

  @override
  Color backgroundColor() => const Color.fromARGB(255, 0, 0, 0);

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();

    gameProvider = Provider.of<GameProvider>(context, listen: true);
    await gameProvider.startupActions();

    //Load Sprites (DO THIS BEFORE CALLING CONSTRUCTORS AAAAAAHHHHHHH) (AND AFTER THE PROVIDER IS DEFINED!!!! DOUBLE AHHHHHH!!!!!)
    //This only includes sprites used within the flame game itself
    await images.loadAll([
      "Arrow.png",
      "Placeholder.png",
      "AbandonedCamp.png",
      "CrackInWall.png",
      "EmptyHall.png",
      "EntranceRoom.png",
      "ExitDoor.png",
      "HoleInGround.png",
      "ItemPedistal.png",
      "LockedChest.png",
      "NarrowCavern.png",
      "Prison.png",
      "RuneWall.png",
      "Well.png",
      "Shrine.png"
    ]);

    //Setup arrow buttons
    upArrow = ArrowButton(direction: Direction.up, gameProvider: gameProvider);
    downArrow = ArrowButton(direction: Direction.down, gameProvider: gameProvider);
    leftArrow = ArrowButton(direction: Direction.left, gameProvider: gameProvider);
    rightArrow = ArrowButton(direction: Direction.right, gameProvider: gameProvider);
    add(upArrow);
    add(downArrow);
    add(leftArrow);
    add(rightArrow);

    //Setup Dungeon
    gameProvider.generateDungeon();
    currentEvent = gameProvider.playerRoom.roomEvent;
    add(currentEvent);

    //app life cycle
    WidgetsBinding.instance!.addObserver(this);
  }

  ///
  /// Game checks for lose conditios on update, and will end the game if the player dies
  ///
  @override
  void update(double dt) {
    if (gameProvider.causeOfDeath != "" && gameEnd == false){
      gameEnd = true;
      gameOver();
    }
    else if (gameProvider.victory && gameEnd == false){
      gameEnd = true;
      gameWin();
    }
    //box win condition check
    else if (gameProvider.escapeMethod ==  EscapeMethod.box && gameProvider.inventoryContains("Small Wooden Box") && gameProvider.playerX == (GameProvider.DUNGEONWIDTH/2).toInt() && gameProvider.playerY == (GameProvider.DUNGEONWIDTH/2).toInt()){
      gameProvider.removeItem("Small Wooden Box");
      gameProvider.playSfx("audio/goldcollect.mp3");
      //gameProvider.playerRoom.roomEvent.setHeader("You hear a snap as the wooden box you were carrying breaks, revealing an old key.");
      Item key = Item(name: "Old Key", sprite: "DoorKey.png", description: "The wooden box you were carrying is gone. Replaced by this old key with short, flat teeth.");
      gameProvider.addItem(key);
    }
    super.update(dt);
  }

  @override
  void onAttach() {
    super.onAttach();
    WidgetsBinding.instance!.addObserver(this);
  }

  ///
  /// App lifecycle checks
  ///
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state){
      case AppLifecycleState.resumed:
        resumeEngine();
        gameProvider.musicPlayer.resume();
        gameProvider.sfxPlayer.resume();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
        pauseEngine();
        gameProvider.musicPlayer.pause();
        gameProvider.sfxPlayer.pause();
        break;
      default:
        break;
    }
  }

  @override
  void onDispose() {
    gameProvider.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.onDispose();
  }

  ///
  /// Removes old room event and adds the new one after a room change
  ///
  void updateGameRoom(){
    remove(currentEvent);
    currentEvent = gameProvider.playerRoom.roomEvent;
    add(currentEvent);
  }

  ///
  /// Game Over Logic
  ///
  void gameOver(){
    overlays.add('gameover');
    gameEnd = false;
  }

  ///
  /// Game Win Logic
  ///
  void gameWin(){
    overlays.add('win');
    gameEnd = false;
  }
}