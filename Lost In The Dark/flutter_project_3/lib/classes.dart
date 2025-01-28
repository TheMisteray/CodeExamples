import 'dart:async';
//import 'dart:ffi';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_3/game_provider.dart';
import 'package:flutter_project_3/main.dart';
import 'game.dart';
import 'outcomes.dart';

final regularText = TextPaint(
  style: TextStyle(
    fontSize: 15.0,
    color: BasicPalette.white.color,
    fontFamily: 'Scope',
  ),
);

///
/// Non-Flame Classes ----------------------------------------------------
///

///
/// A collectable item for the player
/// name - name of the item
/// sprite - file name of the item's sprite
/// description - the description of the item for the inventory screen
///
class Item{
  Item({required String name, required String sprite, required String description}){
    _name = name;
    _sprite = sprite;
    _description = description;
  }
  
  String _name = "";
  String _sprite = "";
  String _description = "";

  String get name => _name;
  String get sprite => _sprite;
  String get description => _description;
}

///
/// A room of the dungeon
/// id - sets the room ID and fetches a proper event based on that ID
///
class Room{
  Room({required int id}){
    _id = id;
    roomEvent = getEvent(id);
  }

  late int _id;
  bool visited = false;
  bool pathUp = false;
  bool pathDown = false;
  bool pathRight = false;
  bool pathLeft = false;

  late Event roomEvent;

  int get ID => _id;

  set ID (int id){
    _id = id;
    roomEvent = getEvent(id);
  }
}

///
/// Gets an event based on room ID, used by the Room class
///
Event getEvent(int id){
  switch (id){
    case -5:
    return Event(sprite: "ExitDoor.png", eventText: "A massive stone door looms before you, covered in writing, and containing an obvious keyhole.", options: ["Insert a key", "Read the writing"], outcomes: [openEndingDoor, readEndingDoorInscription]);
    case -4:
    return Event(sprite: "RuneWall.png", eventText: "The wall here is covered in writings in a runic text.", options: ["Examine"], outcomes: [examineWallOfRunes]);
    case 0:
    return Event(sprite: "EmptyHall.png", eventText: "Nothing but empty halls here", options: [], outcomes: []);
    case 1:
    return Event(sprite: "EntranceRoom.png", eventText: "You awake in the dark. From what little you can see you appear to be underground. You need to find a way out.", options: ["Wait around for a moment"], outcomes: [startingRoomWaitAround]);
    case 2:
    return Event(sprite: "CrackInWall.png", eventText: "As you walk along, you spy a small crevace in the wall. The stones are jagged, and you cannot see inside.", options: ["Reach inside", "Watch at a distance", "Leave it be"], outcomes: [enterCrackInTheWall, watchCrackInWallAtADistance, leaveCrackInWallAtADistance]);
    case 3:
    return Event(sprite: "NarrowCavern.png", eventText: "Up along the side of the wall, there is a small inlet. You can't see it well from down here and it is too high to reach.", options: ["Climb up to the outlet"], outcomes: [climbNarrowCavern]);
    case 4:
    return Event(sprite: "Shrine.png", eventText: "You come across a small donation box. Odd patches of moss are growing behind it.", options: ["Donate", "Deface the shrine"], outcomes: [donateShrine, defaceShrine]);
    case 5:
    return Event(sprite: "HoleInGround.png", eventText: "There is a huge gap in the ground. In the middle of the opening stands a box placed atop a pedistal.", options: ["Try and jump over", "Grab the box from afar", "Leave"], outcomes: [jumpHoleInGround, grabHoleInGround, leaveHoleInGround]);
    case 6:
    return Event(sprite: "ItemPedistal.png", eventText: "A large, round gemstone is inset into a pedistal in this room.", options: ["Take the gem", "Swap it with a rock", "Swap it with a skull"], outcomes: [takePedistalItem, swapPedistalItem, skullPedistalItem]);
    case 7:
    return Event(sprite: "LockedChest.png", eventText: "This room is vacant, save for a large locked chest.", options: ["Smash the chest", "Pry it open", "Use a key"], outcomes: [breakLockedChest, pryLockedChest, keyLockedChest]);
    case 8:
    return Event(sprite: "Prison.png", eventText: "You come across a wall of metal bars, a prison cell. The skeletal remains of whoever it was for are inside.", options: ["Open the cell"], outcomes: [openPrisonCell]);
    case 9:
    return Event(sprite: "AbandonedCamp.png", eventText: "This appears to be an abandoned camp of some previous traveler of these tunnels.", options: ["Pillage the camp", "Leave it be"], outcomes: [pillageAbandonedCamp, leaveAbandonedCamp]);
    case 10:
    return Event(sprite: "Well.png", eventText: "In the middle of the room lies a dried out well.", options: ["Jump in", "Go fish", "Toss a coin"], outcomes: [jumpInWell, castInWell, coinInWell]);
    case -1:
    default:
    return Event(sprite: "Placeholder.png", eventText: "This is an event with a text that runs on so that I can test the overflow and how long this can go on for", options: ["Option 1", "option 2"], outcomes: [giveRoundStone, giveClimbingPics]);
  }
}

///
/// Flame Classes -------------------------------------------------
///

///
/// Navigation buttons for the player to move between rooms of the dungeon
/// direction - the buttons direction that it will move the player
/// gameProvider - game provider reference
///
class ArrowButton extends SpriteComponent with TapCallbacks, HasGameRef<MainGame>{
  ArrowButton({required Direction direction, required GameProvider gameProvider}){
    _direction = direction;
    _gameProvider = gameProvider;
  }
  
  Direction _direction = Direction.up;
  late GameProvider _gameProvider;

  @override
  FutureOr<void> onLoad() async {
    sprite = Sprite(
      game.images.fromCache("Arrow.png")
    );
    anchor = Anchor.center;
    switch(_direction){
      case Direction.down:
        position = Vector2(
          game.size.x / 2, 
          game.size.y - 50 - (game.size.y / 6),
        );
        angle = -pi/2;
        break;
      case Direction.up:
        position = Vector2(
          game.size.x / 2, 
          50,
        );
        angle = pi/2;
        break;
      case Direction.left:
        position = Vector2(
          50, 
          game.size.y / 2 - (game.size.y / 12),
        );
        angle = 0;
        break;
      case Direction.right:
        position = Vector2(
          game.size.x - 50, 
          game.size.y / 2 - (game.size.y / 12),
        );
        angle = pi;
        break;
    }
  }

  ///
  /// Asks game provider to move player in specified direction
  ///
  @override
  void onTapUp(TapUpEvent event) {
    if(_gameProvider.movePosition(_direction)){
      game.updateGameRoom();
      _gameProvider.actionsMade++;
      _gameProvider.playSfx("audio/steps.mp3");
      if (!_gameProvider.modifyHunger(-1)){ // consume hunger
        game.gameOver();
      }
    }
    super.onTapUp(event);
  }

  ///
  /// Renders with orientation based on direction
  ///
  @override
  void render(Canvas canvas) {
    switch(_direction){
      case Direction.up:
        if (!_gameProvider.playerRoom.pathUp){return;}
        break;
      case Direction.down:
      if (!_gameProvider.playerRoom.pathDown){return;}
        break;
      case Direction.left:
      if (!_gameProvider.playerRoom.pathLeft){return;}
        break;
      case Direction.right:
      if (!_gameProvider.playerRoom.pathRight){return;}
        break;
    }
    super.render(canvas);
  }
}

///
/// A component class for a room's "event" i.e. the text and options that appear in a room
/// sprite - the background sprite for the event
/// eventText - the main text describing the event
/// options - the options buttons that display in this event
///
class Event extends SpriteComponent with HasGameRef<MainGame>{
  Event({required String sprite, required String eventText, required List<String> options, required List<Function(GameProvider)> outcomes}){
    _sprite = sprite;
    _eventText = eventText;
    _options = options;
    _outcomes = outcomes;
  }

  String _sprite = "";
  String _eventText = "";
  List<String> _options = [];
  List<Function(GameProvider)> _outcomes = [];
  double fadeIn = 0.0;
  late TextBoxComponent headerText;
  List<TextComponent> optionRefs = []; //This will hold refs to the options so they can be removed

  ///
  ///Set up children
  ///
  @override
  FutureOr<void> onLoad() {
    sprite = Sprite(
      game.images.fromCache(_sprite)
    );
    anchor = Anchor.center;
    fadeIn = 0;

    position = Vector2(
      game.size.x / 2, 
      game.size.y / 2 - (game.size.y / 6),
    );

    // add children components
    headerText = EventHeaderTextBox(_eventText, Vector2(
      0, 
      -120,
    ));
    add(headerText);

    for(int i = 0; i < _options.length; i++)
    {
      TextComponent text = OptionButton(
        _options[i], 
        Vector2(0, height + 70 + (50 * i)), 
        i, 
        this,
        _outcomes[i]
      );
      optionRefs.add(text);
      add(text);
    }
  }

  // @override
  // void update(double dt) {
  //   if (fadeIn < 1){
  //     fadeIn += dt;
  //   } else {
  //     fadeIn = 1;
  //   }
  //   opacity = fadeIn;
  // }

  ///
  /// Resolves changes caused by an option being clicked
  /// This includes removing child components and changing displayed text
  /// result - map containing the new event text and data for whether the event resolved
  ///
  void resolveOption(Map<String, String> result){
    if (result['end'] == "true"){
      remove(headerText);
      for(TextComponent option in optionRefs){
        remove(option);
      }

      headerText = EventHeaderTextBox(result['text'].toString(), Vector2(
        0, 
        -120,
      ));
      add(headerText);
    } else{
      remove(headerText);
      headerText = EventHeaderTextBox(result['text'].toString(), Vector2(
        0, 
        -120,
      ));
      add(headerText);
    }
  }

  // void setHeader(String text){
  //   remove(headerText);
  //   headerText = EventHeaderTextBox(text, Vector2(
  //     0, 
  //     -120,
  //   ));
  //   add(headerText);
  // }
}

///
/// A textboxcomponent preset designed for use by event descriptions
///
class EventHeaderTextBox extends TextBoxComponent{
  EventHeaderTextBox(String text, Vector2 pos) : super(
    text: text,
    textRenderer: regularText,
    align: Anchor.topLeft,
    position: pos,
    boxConfig: const TextBoxConfig(
      timePerChar: 0.02,
      maxWidth: 200,
      growingBox: true
    )
  );
}

///
/// A textboxcomponent preset designed for use by event buttons
///
class OptionButton extends TextBoxComponent with TapCallbacks, HasGameRef<MainGame>{
  OptionButton(String text, Vector2 pos, int optionNum, Event parent, Function(GameProvider) outcome) : super(
    text: text,
    textRenderer: regularText,
    align: Anchor.center,
    position: pos,
    boxConfig: const TextBoxConfig(
      maxWidth: 200,
    )
  ) {
    _outcome = outcome;
    _parent = parent;
  }

  final bgPaint = Paint()..color = const Color.fromARGB(0, 0, 0, 0);
  final borderPaint = Paint()..color = const Color.fromARGB(255, 255, 255, 255)..style = PaintingStyle.stroke..strokeWidth = 5;

  late Function(GameProvider) _outcome;
  late Event _parent;

  ///
  /// Redner with outline box
  ///
  @override
  void render(Canvas canvas) {
    Rect rect = Rect.fromLTWH(0, 0, width, height);
    canvas.drawRect(rect, bgPaint);
    canvas.drawRect(rect, borderPaint);
    super.render(canvas);
  }

  ///
  /// Run event outcome, which should always return a string and then change parent event text based on outcome
  ///
  @override
  void onTapUp(TapUpEvent event) {
    _parent.resolveOption(_outcome(gameRef.gameProvider));
  }
}