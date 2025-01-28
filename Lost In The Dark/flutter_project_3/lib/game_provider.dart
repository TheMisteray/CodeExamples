import 'dart:math';

import 'package:flutter/material.dart';
import 'classes.dart';
import 'main.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// Enum for the escape method, which determines which events are necessary to escape for generation
///
enum EscapeMethod{
  well,
  chest,
  box,
  placeSkull,
  donate
}

///
/// Game provider for tracking and updating game changes
///
class GameProvider extends ChangeNotifier{
  //Statics
  //static const int DUNGEONHEIGHT = 9;
  static const int DUNGEONWIDTH = 9;
  static const int DUNGEONSIZE = DUNGEONWIDTH * DUNGEONWIDTH;
  Random rand = Random();
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer sfxPlayer = AudioPlayer();
    //Log shared prefs
  late SharedPreferences myPrefs;

  //Provider data
  double _musicVolume = 1;
  double _sfxVolume = 1;
  int _playerX = 0;
  int _playerY = 0;
  int health = 100;
  int hunger = 100;
  int actionsMade = 0;
  String causeOfDeath = "";
  String recordText = "";
  bool victory = false;
  List<int> records = [10000, 10000, 10000, 10000, 10000];
  EscapeMethod escapeMethod = EscapeMethod.well;
  bool runeWall = false; //If a rune wall is present

  List<Item> _inventory = [];

  //Generate dungeon 'empty' where each tile is set to -1 which is nothing
  List<List<Room>> dungeon = List<List<Room>>.generate(DUNGEONWIDTH, (i) => List<Room>.generate(DUNGEONWIDTH, (index) => Room(id:-1), growable: false), growable: false);

  //Getters
  double get musicVolume => _musicVolume;
  double get sfxVolume => _sfxVolume;

  int get playerX => _playerX;
  int get playerY => _playerY;
  Room get playerRoom => dungeon[_playerX][_playerY];

  List<Item> get inventory => _inventory;

  //Setters
  set musicVolume(double value){
    _musicVolume = value;
    musicPlayer.setVolume(_musicVolume);
    notifyListeners();
  }

  set sfxVolume(double value){
    _sfxVolume = value;
    sfxPlayer.setVolume(_sfxVolume);
    notifyListeners();
  }

  ///
  /// Plays a gbm
  /// music - Path to audio
  ///
  void playBgm(String music) async{
    musicPlayer.setReleaseMode(ReleaseMode.loop);
    await musicPlayer.play(AssetSource(music));
  }

  ///
  /// Play an sfx
  /// sfx - path to sound effect
  ///
  void playSfx(String sfx) async{
    sfxPlayer.setReleaseMode(ReleaseMode.stop);
    await sfxPlayer.play(AssetSource(sfx));
  }

  @override
  void dispose(){
    musicPlayer.stop();
    musicPlayer.dispose();
    sfxPlayer.stop();
    sfxPlayer.dispose();
    super.dispose();
  }

  ///
  /// bool rather than regular setter so that when this funciton is used you can detect if player should die
  /// returns false if player hits 0 HP or less
  ///
  bool modifyHP(int value){
    if (health + value > 0){
      health += value;
      notifyListeners();
      return true;
    } else {
      causeOfDeath = "Injury";
      health = 0;
      notifyListeners();
      return false;
    }
  }

  ///
  /// same as setHP but for hunger instead
  ///
  bool modifyHunger(int value){
    if (hunger + value > 0){
      hunger += value;
      notifyListeners();
      return true;
    } else {
      if (inventoryContains("Slice of Bread")){
        removeItem("Slice of Bread");
        hunger = 10;
        notifyListeners();
        return true;
      }
      causeOfDeath = "Starvation";
      hunger = 0;
      notifyListeners();
      return false;
    }
  }

  ///
  /// Adds an item to inventory
  /// item - the item to add
  ///
  void addItem(Item item){
    _inventory.add(item);
    notifyListeners();
  }

  ///
  /// Removes item with given name from inventory
  /// name - item name
  /// returns true if an item is successfully remove from inventory
  ///
  bool removeItem(String name){
    for (int i = 0; i < _inventory.length; i++){
      if (_inventory[i].name == name){
        _inventory.removeAt(i);
        notifyListeners();
        return true;
      }
    }
    return false;
  }

  ///
  /// Checks if the inventory contains an item
  /// name - item name (Case Sensitive!)
  ///
  bool inventoryContains(String name){
    for (int i = 0; i < _inventory.length; i++){
      if (_inventory[i].name == name){
        return true;
      }
    }
    return false;
  }

  ///
  /// Does some things for startup, currently mostly audio related
  ///
  Future startupActions() async{
    //music setup
    musicPlayer.setVolume(_musicVolume);
    sfxPlayer.setVolume(_sfxVolume);

    //Do shared prefs
    myPrefs = await SharedPreferences.getInstance();
    List<String>? oldRecords = myPrefs.getStringList("records");
    if (oldRecords != null){
      for(int i = 0; i < oldRecords.length; i++){
        records[i] = int.parse(oldRecords[i]);
      }
    } else {
      records = [10000, 10000, 10000, 10000, 10000];
    }

    playBgm("audio/menu.mp3");
  }

  ///
  /// Generates the Map randomly
  /// This occurs by taking a starting at grid center and setting it to the base event of 0, and the building outwards
  /// Should input 7, 7 to start building at the center
  /// Not the most robust random generation but it works for now
  /// 
  void generateDungeon(){
    //Choose victory method
    switch(rand.nextInt(5)){
      case 0:
      escapeMethod = EscapeMethod.well;
      break;
      case 1:
      escapeMethod = EscapeMethod.chest;
      break;
      case 2:
      escapeMethod = EscapeMethod.box;
      break;
      case 3:
      escapeMethod = EscapeMethod.placeSkull;
      break;
      case 4:
      escapeMethod = EscapeMethod.donate;
      break;
    }
    //randomly determine rune wall spawning
    if (rand.nextBool()){ runeWall = true; } else { runeWall = false; }

    int x = (DUNGEONWIDTH/2).toInt();
    int y = (DUNGEONWIDTH/2).toInt();
    _playerX = x;
    _playerY = y;
    dungeon[x][y].visited = true;
    dungeon[x][y].ID = 1;
    dungeon[x][y].pathDown = true;
    dungeon[x][y+1].pathUp = true;
    dungeon[x][y].pathLeft = true;
    dungeon[x-1][y].pathRight = true;
    dungeon[x][y].pathRight = true;
    dungeon[x+1][y].pathLeft = true;
    dungeon[x][y].pathUp = true;
    dungeon[x][y-1].pathDown = true;
    openRoom(1, x, y + 1);
    openRoom(1, x, y - 1);
    openRoom(1, x-1, y);
    openRoom(1, x+1, y);

    //Set an exit door
    bool notFound = true;
    while (notFound) {
      int randX = rand.nextInt(DUNGEONWIDTH);
      int randY = rand.nextInt(DUNGEONWIDTH);
      if (dungeon[randX][randY].ID >= 0 && dungeon[randX][randY].ID != 1){ //not spawn room or out of bounds
        dungeon[randX][randY].ID = -5;
        notFound = false;
        return;
      }
    }
    //set rune wall
    if (runeWall){
      notFound = true;
      while (notFound) {
        int randX = rand.nextInt(DUNGEONWIDTH);
        int randY = rand.nextInt(DUNGEONWIDTH);
        if (dungeon[randX][randY].ID >= 0 && dungeon[randX][randY].ID != 1){
          dungeon[randX][randY].ID = -4;
          notFound = false;
          return;
        }
      }
      forceRoom(3, -1, -1);
    }

    //check for needed rooms based on victory method
    switch(escapeMethod){
      case EscapeMethod.well:
      forceRoom(10, -1, -1);
      forceRoom(7, 10, -1);
      break;
      case EscapeMethod.chest:
      forceRoom(7, -1, -1);
      break;
      case EscapeMethod.box:
      forceRoom(5, -1, -1);
      forceRoom(9, 5, -1);
      break;
      case EscapeMethod.placeSkull:
      forceRoom(8, -1, -1);
      forceRoom(6, 8, -1);
      forceRoom(7, 8, 6);
      break;
      case EscapeMethod.donate:
      forceRoom(4, -1, -1);
      forceRoom(6, 4, -1);
      forceRoom(2, 6, 4);
      break;
    }
    notifyListeners();
  }

  ///
  /// Forces a room type into the dungeon after creation
  /// id - rood ID to force
  /// dontOverwriteID - extra room type to not overwrite
  /// dontOverwriteID2 - another room to not overwrite just in case
  ///
  void forceRoom(int id, int dontOverwriteID, int dontOverwriteID2){
    //first check if the room already exists
    for(int i = 0; i < DUNGEONWIDTH; i++){
      for(int j = 0; j < DUNGEONWIDTH; j++){
        if (dungeon[i][j].ID == id){
          break; //escape if so since we don't need to force one
        }
      }
    }

    //replace a room with the needed room
    bool notFound = true;
    while (notFound) {
      int randX = rand.nextInt(DUNGEONWIDTH);
      int randY = rand.nextInt(DUNGEONWIDTH);
      if (dungeon[randX][randY].ID >= 0 && dungeon[randX][randY].ID != dontOverwriteID && dungeon[randX][randY].ID != dontOverwriteID){ //not spawn room or out of bounds
        dungeon[randX][randY].ID = id;
        notFound = false;
      }
    }
  }

  ///
  /// Attempts to generate a new room in dungeon generation
  /// chance is the change that the generation actually takes place
  /// x, y are position of the room being generated
  ///
  bool openRoom(double chance, int x, int y){
    if (rand.nextDouble() > chance){return false;} //case where no room is created
    if (chance != 1 && rand.nextDouble() > .6){return false;} //random chance for more chaotic randomness after the first few
    
    //Choose room type
    if (rand.nextInt(10) >= 6){
      dungeon[x][y].ID = 0;
    } else {
      dungeon[x][y].ID = rand.nextInt(9) + 2; //range 2 - 10
    }

    if (x-1 >= 0 && dungeon[x-1][y].ID == -1){ //check of given room is not out of bounds and not already a room
      if (openRoom(chance - 0.15, x-1, y)){
        dungeon[x][y].pathLeft = true;
        dungeon[x-1][y].pathRight = true;
      }
    }
    if (x+1 < DUNGEONWIDTH && dungeon[x+1][y].ID == -1){ //check of given room is not out of bounds and not already a room
      if (openRoom(chance - 0.15, x+1, y)){
        dungeon[x][y].pathRight = true;
        dungeon[x+1][y].pathLeft = true;
      }
    }
    if (y-1 >= 0 && dungeon[x][y-1].ID == -1){ //check of given room is not out of bounds and not already a room
      if (openRoom(chance - 0.15, x, y-1)){
        dungeon[x][y].pathUp = true;
        dungeon[x][y-1].pathDown = true;
      }
    }
    if (y+1 < DUNGEONWIDTH && dungeon[x][y+1].ID == -1){ //check of given room is not out of bounds and not already a room
      if (openRoom(chance - 0.15, x, y+1)){
        dungeon[x][y].pathDown = true;
        dungeon[x][y+1].pathUp = true;
      }
    }
    return true;
  }

  ///
  /// Moves player position in specified direction if a room exists in that direction
  /// reuturns true if moved successfully
  ///
  bool movePosition(Direction direciton){
    Room room = dungeon[_playerX][_playerY];
    switch (direciton){
      case Direction.up:
      if (_playerY > 0 && room.pathUp) {
        _playerY--;
        dungeon[_playerX][_playerY].visited = true;
        notifyListeners();
        return true;
      } else{
        return false;
      }
      case Direction.down:
      if (_playerY < DUNGEONWIDTH-1 && room.pathDown) {
        _playerY++;
        dungeon[_playerX][_playerY].visited = true;
        notifyListeners();
        return true;
      } else{
        return false;
      }
      case Direction.left:
      if (_playerX > 0 && room.pathLeft) {
        _playerX--;
        dungeon[_playerX][_playerY].visited = true;
        notifyListeners();
        return true;
      } else{
        return false;
      }
      case Direction.right:
      if (_playerX < DUNGEONWIDTH-1 && room.pathRight) {
        _playerX++;
        dungeon[_playerX][_playerY].visited = true;
        notifyListeners();
        return true;
      } else{
        return false;
      }
    }
  }

  ///
  /// Update the user prefs with the new score
  ///
  Future updateRecords() async {
    List<String>? recordsToUpdate = ["", "", "", "", ""];
    for(int i = 0; i < records.length; i++){
      if (actionsMade < records[i]){
        for (int j = records.length - 1; j > i; j--){
          records[j] = records[j - 1];
        }
        records[i] = actionsMade;
        if (i == 0){
          recordText = "New Record";
        } else {
          recordText = "Top 5 Record";
        }

        //Cast to string list for saving
        for (int i = 0; i < records.length; i++){
          recordsToUpdate[i] = records[i].toString();
        }
        await myPrefs.setStringList("records", recordsToUpdate);
        break;
      }
    }
  }

  ///
  /// Sets game to defaults and regenerates.
  /// Effectively this restarts the game run.
  ///
  void resetGame(){
    health = 100;
    hunger = 100;
    actionsMade = 0;
    victory = false;
    causeOfDeath = "";
    inventory.clear();
    //clear dungeon
    dungeon = List<List<Room>>.generate(DUNGEONWIDTH, (i) => List<Room>.generate(DUNGEONWIDTH, (index) => Room(id:-1), growable: false), growable: false);
    generateDungeon();
    notifyListeners();
  }
}