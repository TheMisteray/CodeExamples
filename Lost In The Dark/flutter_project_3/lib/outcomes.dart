import 'package:flutter_project_3/game_provider.dart';
import 'classes.dart';

///
/// This file contains all of the outcome functions that can occur when the player
/// clicks on an event option.
/// They will all be Map<String, Strin> functions and will return what text the event will display after the option is taken as well as whether the event should remain afterwards
///     With this approach it would be easy to have these funtions return even more data (like alternate event sprites to display based on the result, which was planned but I do not have time for)
/// They all take the game provider as a parameter
/// These will all be hyper specific, and are not the best diplay of DRY, but with how the foundation was build this is the only way that would give me a satisfactoy amount of flexibility
///

///
/// Outcomes for fallback event
///
Map<String, String> giveRoundStone(GameProvider provider) {
  Item stone = Item(name: "Round Stone", sprite: "RoundStone.png", description: "An oddly round stone");
  provider.addItem(stone);
  return {
    'end': "true",
    'text': "You find a strange stone"
  };
}
Map<String, String> giveClimbingPics(GameProvider provider) {
  Item stone = Item(name: "Climbing Picks", sprite: "ClimbingPicks.png", description: "A pair of climbing tools");
  provider.addItem(stone);
  return {
    'end': "true",
    'text': "You find a pair of climbing pics"
  };
}

///
/// Event -5
/// Game end event
///
Map<String, String> openEndingDoor(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Old Key")){
    provider.removeItem("Old Key");
    provider.victory = true;
    provider.playSfx("audio/door.mp3");
    return{
      'end': "true",
      'text': "You open the door"
    };
  } else if (provider.inventoryContains("Key")){
    provider.playSfx("audio/search.mp3");
    return{
      'end': "true",
      'text': "Try as you might, the key you have doesn't fit"
    };
  } else {
    return{
      'end': "false",
      'text': "You need a Key"
    };
  }
}
Map<String, String> readEndingDoorInscription(GameProvider provider){
  provider.actionsMade ++;
  provider.playSfx("audio/search.mp3");
  String helpText = "";
  switch(provider.escapeMethod){
    case EscapeMethod.well:
    helpText = "The inscription reads: Descend where water once reigned.";
    break;
    case EscapeMethod.chest:
    helpText = "The inscription reads: Locked away and forgotten.";
    break;
    case EscapeMethod.box:
    helpText = "The inscription reads: Take the box of nothing to where it all began.";
    break;
    case EscapeMethod.placeSkull:
    helpText = "The inscription reads: Death for wealth.";
    break;
    case EscapeMethod.donate:
    helpText = "The inscription reads: Karma catches up to everyone.";
  }
  return{
      'end': "false",
      'text': provider.runeWall? "The inscription has been scraped out." : helpText
    };
}

///
/// Event -4
/// Wall of runes
///
Map<String, String> examineWallOfRunes(GameProvider provider){
  provider.actionsMade ++;
  provider.modifyHunger(-3);
  provider.playSfx("audio/search.mp3");
  String helpText = "";
  switch(provider.escapeMethod){
    case EscapeMethod.well:
    helpText = "The inscription reads: Descend where water once reigned.";
    break;
    case EscapeMethod.chest:
    helpText = "The inscription reads: Locked away and forgotten.";
    break;
    case EscapeMethod.box:
    helpText = "The inscription reads: Take the box of nothing to where it all began.";
    break;
    case EscapeMethod.placeSkull:
    helpText = "The inscription reads: Death for wealth.";
    break;
    case EscapeMethod.donate:
    helpText = "The inscription reads: Karma catches up to everyone.";
  }
  if (provider.inventoryContains("Old Book")){
    return{
      'end': "true",
      'text': "Using your book you decipher the text. $helpText."
    };
  } else {
    return{
      'end': "false",
      'text': "You take some time to examine the wall, but learn nothing new. It seems almost like language, but not quite?"
    };
  }
}

///
/// Event 0
/// Empty hall - no options
///

///
/// Event 1
/// Starting Room
///
Map<String, String> startingRoomWaitAround(GameProvider provider){
  provider.actionsMade ++;
  provider.modifyHunger(-2);
  if (provider.rand.nextInt(7) == 0 || provider.runeWall){
    Item itemGiven;
    switch(provider.rand.nextInt(3)){
      case 0:
      itemGiven = Item(name: "Climbing Picks", sprite: "ClimbingPicks.png", description: "A pair of climbing tools.");
      break;
      case 1:
      itemGiven = Item(name: "Slice of Bread", sprite: "SliceOfBread.png", description: "A stale slice of bread. Probably safe to eat. Certainly not tasty. Will save you from death if hunger reaches 0, restoring 10.");
      break;
      case 2:
      default: //default case just in case
      itemGiven = Item(name: "Rusty Knife", sprite: "RustyKnife.png", description: "A small rusted knife. It looks like it could fall apart at any moment.");
      break;
    }
    provider.addItem(itemGiven);
    provider.playSfx("audio/goldcollect.mp3");
    return{
      'end': "true",
      'text': "While waiting around you spy a ${itemGiven.name} lying on the floor, which you take. You are getting hungry (-2 Hunger)."
    };
  } else {
    return{
      'end': "true",
      'text': "Waiting around isn't doing you any good, and you are getting hungry (-2 Hunger)."
    };
  }
}

///
/// Event 2
/// Crack in the wall
///
Map<String, String> enterCrackInTheWall(GameProvider provider){
  provider.actionsMade ++;
  if (provider.modifyHP(-5)){
    Item stone = Item(name: "Round Stone", sprite: "RoundStone.png", description: "An oddly round stone");
    provider.addItem(stone);
    provider.playSfx("audio/punch.mp3");
    return{
      'end': "true",
      'text': "The jagged edges of the opening cut at your hands (-5 Health). But you managed to find a strange stone amongst the rubble."
    };
  } else {
    //die
    return{
      'end': "true",
      'text': "The jagged edges of the opening cut at your hands. And you succumb to the injury."
    };
  }
}
Map<String, String> watchCrackInWallAtADistance(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Rusty Knife")){
    Item stone = Item(name: "Round Stone", sprite: "RoundStone.png", description: "An oddly round stone");
    provider.addItem(stone);
    Item batWing = Item(name: "Bat Wing", sprite: "BatWing.png", description: "A wing cut from a bat");
    provider.addItem(batWing);
    provider.playSfx("audio/bats.mp3");
    return{
      'end': "true",
      'text': "A swarm of bats expel from the opening, dislodging a round stone. You slice a wing off one with your \"Rusty Knife\n."
    };
  } else {
    Item stone = Item(name: "Round Stone", sprite: "RoundStone.png", description: "An oddly round stone");
    provider.addItem(stone);
    provider.playSfx("audio/bats.mp3");
    return{
      'end': "true",
      'text': "A swarm of bats expel from the opening, dislodging a strange looking stone for you to pick up."
    };
  }
}
Map<String, String> leaveCrackInWallAtADistance(GameProvider provider){
  provider.actionsMade ++;
  return{
      'end': "false",
      'text': "It's probably best to leave it for now."
    };
}

///
/// Event 3
/// Narrow Carvern
///
Map<String, String> climbNarrowCavern(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Climbing Picks")){
    Item book = Item(name: "Old Book", sprite: "OldBook.png", description: "A old, dusty tome. It is filled with what seems to be some older version of the language you know. Scrawled on the final page of the book is a means to translate the old text.");
    provider.addItem(book);
    provider.playSfx("audio/move.mp3");
    return{
      'end': "true",
      'text': "Using your \"Climbing Picks\" you ascend the wall, and find an Old Book in an outlet on the wall."
    };
  }
  return{
    'end': "false",
    'text': "The walls are too steep to climb with your hands."
  };
}

///
/// Event 4
/// Shrine
///
Map<String, String> donateShrine(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Gemstone")){
      provider.playSfx("audio/goldcollect.mp3");
    provider.removeItem("Gemstone");
    if (provider.escapeMethod == EscapeMethod.donate){
      Item key = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
      provider.addItem(key);
      return{
        'end': "false",
        'text': "You toss a gem into the basket, and when you look inside it has transformed into an old key."
      };
    }
    Item key = Item(name: "Key", sprite: "Key.png", description: "A key.");
    provider.addItem(key);
    return{
      'end': "false",
      'text': "You toss a gem into the basket, and when you look inside it has transformed into a key."
    };
  }
  if (provider.inventoryContains("Golden Coin")){
    provider.playSfx("audio/goldcollect.mp3");
    provider.removeItem("Golden Coin");
    Item book = Item(name: "Old Book", sprite: "OldBook.png", description: "A old, dusty tome. It is filled with what seems to be some older version of the language you know. Scrawled on the final page of the book is a means to translate the old text.");
    provider.addItem(book);
    return{
      'end': "false",
      'text': "You toss a coin into the basket, and when you look inside it has transformed into an old book."
    };
  } else {
    return{
      'end': "false",
      'text': "You have nothing to donate."
    };
  }
}
Map<String, String> defaceShrine(GameProvider provider){
  provider.actionsMade ++;
  provider.playSfx("audio/search.mp3");
  if (provider.inventoryContains("Rusty Knife")){
    provider.modifyHunger(-10);
    return{
      'end': "false",
      'text': "You scratch up the shrine with your \"Rusty Knife\". You feel hollow (-10 Hunger)."
    };
  } else if (provider.inventoryContains("Climbing Picks")) {
    provider.modifyHunger(-10);
    return{
      'end': "false",
      'text': "You chip at the stone with your \"Climbing Picks\". You feel hollow (-10 Hunger)."
    };
  } else {
    return{
      'end': "false",
      'text': "You will need a tool to harm the stone."
    };
  }
}

///
/// Event 5
/// Hole in the ground
///
Map<String, String> jumpHoleInGround(GameProvider provider){
  provider.actionsMade ++;
  if (provider.rand.nextBool()){
    provider.playSfx("audio/hit.mp3");
    provider.modifyHP(-20);
    if (provider.inventoryContains("Climbing Picks")){
      Item box = Item(name: "Small Wooden Box", sprite: "SmallBox.png", description: "A small box made of wood that makes noises when shaken. It is surprisingly light.");
      provider.addItem(box);
      return{
        'end': "false",
        'text': "You fall into the hole (-20 Health). But use your \"Climbing Picks\" to reach the middle anyway. Then safely hop back. Strangely, a new box has taken its place when you look back."
      };
    } else {
      return{
        'end': "false",
        'text': "You just barely miss the middle, and fall into the hole (-20 Health). "
      };
    }
  } else {
    Item box = Item(name: "Small Wooden Box", sprite: "SmallBox.png", description: "A small box made of wood that makes noises when shaken. It is surprisingly light.");
    provider.addItem(box);
    provider.playSfx("audio/search.mp3");
    return{
      'end': "false",
      'text': "You jump to the center and grab the box. Then safely hop back. Strangely, a new box has taken its place when you look back."
    };
  }
}
Map<String, String> grabHoleInGround(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Fishing Rod")){
    Item box = Item(name: "Small Wooden Box", sprite: "SmallBox.png", description: "A small box made of wood that makes noises when shaken. It is surprisingly light.");
    provider.addItem(box);
    provider.playSfx("audio/fish.mp3");
    return{
      'end': "false",
      'text': "You sling your fishing line to hook the box and pull it towards you. Strangely, a new box has taken its place when you look up."
    };
  } else {
    return{
      'end': "false",
      'text': "You have no means or grabbing the box from afar."
    };
  }
}
Map<String, String> leaveHoleInGround(GameProvider provider){
  provider.actionsMade ++;
  return{
    'end': "false",
    'text': "This looks too dangerous, you step away for now."
  };
}

///
/// Event 6
/// Item on pedistal
///
Map<String, String> takePedistalItem(GameProvider provider){
  provider.actionsMade ++;
  Item gem = Item(name: "Gemstone", sprite: "Gemstone.png", description: "A glittering gemstone.");
  provider.addItem(gem);
  provider.modifyHP(-45);
  provider.playSfx("audio/stab.mp3");
  return{
    'end': "true",
    'text': "You manage to snag the item, but not before a needle springs from the pedistal straight through your hand (-45 Health)."
  };
}
Map<String, String> swapPedistalItem(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Round Stone")){
    Item gem = Item(name: "Gemstone", sprite: "Gemstone.png", description: "A glittering gemstone.");
    provider.addItem(gem);
    provider.removeItem("Round Stone");
    provider.playSfx("audio/door.mp3");
    return{
      'end': "true",
      'text': "You swap in the \"Round Stone\" as quickly as you can... It seems to have worked, but now the stone is inexplicably stuck to the pedistal."
    };
  }
  return{
    'end': "false",
    'text': "You don't have a suitable item to swap it with."
  };
}
Map<String, String> skullPedistalItem(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Skull")){
    Item gem = Item(name: "Gemstone", sprite: "Gemstone.png", description: "A glittering gemstone.");
    provider.addItem(gem);
    provider.removeItem("Skull");
    if (provider.escapeMethod == EscapeMethod.placeSkull){
      Item key = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
      provider.addItem(key);
      provider.playSfx("audio/goldcollect.mp3");
      return{
        'end': "true",
        'text': "As you swap in the \"Skull\". An old key suddenly falls from its open jaw."
      };
    }
    Item key = Item(name: "Key", sprite: "Key.png", description: "A key.");
    provider.addItem(key);
    provider.playSfx("audio/goldcollect.mp3");
    return{
      'end': "true",
      'text': "As you swap in the \"Skull\". A key suddenly falls from its open jaw."
    };
  }
  return{
    'end': "false",
    'text': "You don't have a suitable item to swap it with."
  };
}

///
/// Event 7
/// Locked Chest
///
Map<String, String> breakLockedChest(GameProvider provider){
  provider.actionsMade ++;
  if (provider.rand.nextInt(12) == 0){
    Item itemGiven;
    switch(provider.rand.nextInt(4)){
      case 0:
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
      break;
      case 1:
      itemGiven = Item(name: "Fishing Rod", sprite: "FishingRod.png", description: "A traditional wooden fishing rod. Who brought this here?");
      break;
      case 2:
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
      break;
      case 3:
      default: //default case just in case
      itemGiven = Item(name: "Rusty Knife", sprite: "RustyKnife.png", description: "A small rusted knife. It looks like it could fall apart at any moment.");
      break;
    }
    if (provider.escapeMethod == EscapeMethod.chest && !provider.inventoryContains("Old Key")){
      itemGiven = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
    } else if (provider.escapeMethod == EscapeMethod.well){
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
    } else if (provider.escapeMethod == EscapeMethod.placeSkull) {
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
    }
    provider.addItem(itemGiven);
    provider.playSfx("audio/search.mp3");
    return{
      'end': "true",
      'text': "The chest shatters, and from it you pull a ${itemGiven.name}."
    };
  }
  provider.modifyHP(-5);
  provider.playSfx("audio/punch.mp3");
  return{
    'end': "false",
    'text': "Beating the chest hurts your hands (-5 Health). But you feel like it might be possible..."
  };
}
Map<String, String> pryLockedChest(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Climbing Picks")){
    Item itemGiven;
    switch(provider.rand.nextInt(4)){
      case 0:
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
      break;
      case 1:
      itemGiven = Item(name: "Fishing Rod", sprite: "FishingRod.png", description: "A traditional wooden fishing rod. Who brought this here?");
      break;
      case 2:
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
      break;
      case 3:
      default: //default case just in case
      itemGiven = Item(name: "Rusty Knife", sprite: "RustyKnife.png", description: "A small rusted knife. It looks like it could fall apart at any moment.");
      break;
    }
    if (provider.escapeMethod == EscapeMethod.chest && !provider.inventoryContains("Old Key")){
      itemGiven = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
    } else if (provider.escapeMethod == EscapeMethod.well){
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
    } else if (provider.escapeMethod == EscapeMethod.placeSkull) {
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
    }
    provider.addItem(itemGiven);
    provider.playSfx("audio/door.mp3");
    return{
      'end': "true",
      'text': "You pry the chest open with your \"Climbing Picks\" and find a ${itemGiven.name} inside."
    };
  }
  else if (provider.inventoryContains("Rusty Knife")){
        Item itemGiven;
    switch(provider.rand.nextInt(4)){
      case 0:
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
      break;
      case 1:
      itemGiven = Item(name: "Fishing Rod", sprite: "FishingRod.png", description: "A traditional wooden fishing rod. Who brought this here?");
      break;
      case 2:
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
      break;
      case 3:
      default: //default case just in case
      itemGiven = Item(name: "Climbing Picks", sprite: "ClimbingPicks.png", description: "A pair of climbing tools.");
      break;
    }
    if (provider.escapeMethod == EscapeMethod.chest && !provider.inventoryContains("Old Key")){
      itemGiven = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
    } else if (provider.escapeMethod == EscapeMethod.well){
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
    } else if (provider.escapeMethod == EscapeMethod.placeSkull) {
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
    }
    provider.addItem(itemGiven);
    provider.removeItem("Rusty Knife");
    provider.playSfx("audio/door.mp3");
    return{
      'end': "true",
      'text': "You pry the chest open with your \"Rusty Knife\" and find a ${itemGiven.name} inside. The knife breaks from this strain."
    };
  }
  return{
    'end': "false",
    'text': "You have nothing to pry the chest open with."
  };
}
Map<String, String> keyLockedChest(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Key")){
    Item itemGiven;
    switch(provider.rand.nextInt(4)){
      case 0:
      itemGiven = Item(name: "Climbing Picks", sprite: "ClimbingPicks.png", description: "A pair of climbing tools.");
      break;
      case 1:
      itemGiven = Item(name: "Fishing Rod", sprite: "FishingRod.png", description: "A traditional wooden fishing rod. Who brought this here?");
      break;
      case 2:
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
      break;
      case 3:
      default: //default case just in case
      itemGiven = Item(name: "Rusty Knife", sprite: "RustyKnife.png", description: "A small rusted knife. It looks like it could fall apart at any moment.");
      break;
    }
    if (provider.escapeMethod == EscapeMethod.chest && !provider.inventoryContains("Old Key")){
      itemGiven = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
    } else if (provider.escapeMethod == EscapeMethod.well){
      itemGiven = Item(name: "Golden Coin", sprite: "GoldenCoin.png", description: "A huge coin of pure gold!");
    } else if (provider.escapeMethod == EscapeMethod.placeSkull) {
      itemGiven = Item(name: "Key", sprite: "Key.png", description: "A key.");
    }
    provider.addItem(itemGiven);
    provider.removeItem("Key");
    provider.playSfx("audio/goldcollect.mp3");
    return{
      'end': "true",
      'text': "The key fits, and you open the chest. There is a ${itemGiven.name} inside."
    };
  } else {
    return{
      'end': "false",
      'text': "You don't have the correct key."
    };
  }
}

///
/// Event 8
/// Old Prison Cell
///
Map<String, String> openPrisonCell(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Key")){
    Item skull = Item(name: "Skull", sprite: "Skull.png", description: "A human skull. Makes you feel uneasy.");
    provider.addItem(skull);
    provider.removeItem("Key");
    provider.playSfx("audio/search.mp3");
    return{
      'end': "true",
      'text': "You open the cell and take the skull."
    };
  }
  return{
    'end': "false",
    'text': "You don't have the right key."
  };
}

///
/// Event 9
/// Abandoned Camp
///
Map<String, String> pillageAbandonedCamp(GameProvider provider){
  provider.actionsMade ++;
  if (provider.escapeMethod == EscapeMethod.box || provider.rand.nextBool()){
    Item rod = Item(name: "Fishing Rod", sprite: "FishingRod.png", description: "A traditional wooden fishing rod. Who brought this here?");
    provider.addItem(rod);
    provider.playSfx("audio/search.mp3");
    return{
      'end': "true",
      'text': "Someone left a fishing rod here."
    };
  }
  Item bread = Item(name: "Slice of Bread", sprite: "SliceOfBread.png", description: "A stale slice of bread. Probably safe to eat. Certainly not tasty. Will save you from death if hunger reaches 0, restoring 10.");
  Item bread2 = Item(name: "Slice of Bread", sprite: "SliceOfBread.png", description: "A stale slice of bread. Probably safe to eat. Certainly not tasty. Will save you from death if hunger reaches 0, restoring 10.");
  provider.addItem(bread);
  provider.addItem(bread2);
  provider.playSfx("audio/search.mp3");
  return{
    'end': "true",
    'text': "You scrounge up some bread from the camp."
  };
}
Map<String, String> leaveAbandonedCamp(GameProvider provider){
  return{
    'end': "false",
    'text': "Probably best to leave it. You never know, they might come back."
  };
}

///
/// Event 10
/// The Well
///
Map<String, String> jumpInWell(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Climbing Picks")){
    if (provider.escapeMethod == EscapeMethod.well){
      Item key = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
      provider.addItem(key);
      provider.playSfx("audio/move.mp3");
      return{
        'end': "true",
        'text': "You jump down, using your \"Climbing Picks\" to slow your fall. There is a old key at the bottom of the well for you to take."
      };
    }
    Item key = Item(name: "Key", sprite: "Key.png", description: "A key.");
    provider.addItem(key);
    provider.playSfx("audio/move.mp3");
    return{
      'end': "true",
      'text': "You jump down, using your \"Climbing Picks\" to slow your fall. There is a small key at the bottom of the well for you to take."
    };
  }
  provider.modifyHP(-100);
  provider.playSfx("audio/hit.mp3");
  return{
    'end': "true",
    'text': "The fall is long, you hit the ground. Hard (-100 Health). You sit at the bottom of the well as consciousness fades."
  };
}
Map<String, String> castInWell(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Fishing Rod")){
    provider.removeItem("Fishing Rod");
    return{
      'end': "false",
      'text': "Your line gets stuck on something deep in the well, and snaps."
    };
  }
  return{
    'end': "false",
    'text': "You do not have a fishing rod."
  };
}
Map<String, String> coinInWell(GameProvider provider){
  provider.actionsMade ++;
  if (provider.inventoryContains("Golden Coin")){
    provider.removeItem("Golden Coin");
    if (provider.escapeMethod == EscapeMethod.well){
      Item key = Item(name: "Old Key", sprite: "DoorKey.png", description: "An old key with short, flat teeth.");
      provider.addItem(key);
      provider.playSfx("audio/goldcollect.mp3");
      return{
        'end': "true",
        'text': "You toss in the \"Golden Coin\". Suddenly, a old key is flung out of the well, which you quickly catch."
      };
    }
    Item key = Item(name: "Key", sprite: "Key.png", description: "A key.");
    provider.addItem(key);
    provider.playSfx("audio/goldcollect.mp3");
    return{
      'end': "true",
      'text': "You toss in the \"Golden Coin\". Suddenly, a small key is flung out of the well, which you quickly catch."
    };
  }
  return{
    'end': "false",
    'text': "You do not have a coin."
  };
}