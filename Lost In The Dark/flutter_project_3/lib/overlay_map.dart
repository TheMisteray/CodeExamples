import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';
import 'classes.dart';

///
/// Map Overlay
/// Displays a visual of the dungeon map and the player's location. Only shows visited rooms.
///
MapOverlay(context, game) {
  final gameProvider = Provider.of<GameProvider>(context, listen: true);

  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black,
    padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          child: Text(
            "Map",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: GameProvider.DUNGEONSIZE,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: GameProvider.DUNGEONWIDTH,
              //crossAxisSpacing: 4,
              //mainAxisSpacing: 4
            ), 
            itemBuilder: (context, index){
              int y = (index/GameProvider.DUNGEONWIDTH).truncate();
              int x = index%GameProvider.DUNGEONWIDTH;
              Room room = gameProvider.dungeon[x][y];
              if (room.ID != -1 && room.visited){ //Check if room is valid and explored
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border(
                      top: BorderSide(color: room.pathUp?const Color.fromARGB(150, 255, 255, 255): const Color.fromARGB(255, 255, 255, 255), width: room.pathUp? 1:5),
                      right: BorderSide(color: room.pathRight?const Color.fromARGB(150, 255, 255, 255): const Color.fromARGB(255, 255, 255, 255), width: room.pathRight? 1:5),
                      bottom: BorderSide(color: room.pathDown?const Color.fromARGB(150, 255, 255, 255): const Color.fromARGB(255, 255, 255, 255), width: room.pathDown? 1:5),
                      left: BorderSide(color: room.pathLeft?const Color.fromARGB(150, 255, 255, 255): const Color.fromARGB(255, 255, 255, 255), width: room.pathLeft? 1:5),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.none,
                      scale: (gameProvider.playerX == x && gameProvider.playerY == y)? 1:0,
                      alignment: Alignment.center,
                      image: const AssetImage("assets/images/Player.png")
                    )
                  ),
                  //child: Image(image: const AssetImage("Player.png"), fit: BoxFit.cover),
                );
              } else {
                return Container(
                  height: 20,
                  width: 20,
                  color: Colors.black,
                );
              }
            }
          )
        ),
        SizedBox(
          width: 70,
          height: 70,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              enableFeedback: false,
              splashFactory: NoSplash.splashFactory,
              //overlayColor: Colors.transparent,
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              //shadowColor: Colors.black,
              //elevation: 10.0,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              side: const BorderSide(
                color: Colors.white,
                width: 5
              )
            ),
            onPressed: () {
              game.paused = false;
              game.overlays.remove('map');
            },
            child: const Image(image: AssetImage("assets/images/Arrow.png"))
          ),
        ),
      ],
    )
  );
}