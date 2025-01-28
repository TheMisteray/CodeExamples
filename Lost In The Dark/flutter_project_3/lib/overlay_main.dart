import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

///
/// Game's Overlay
/// Contains navigation buttons to inventory and map and displays player stats
///
Widget MainOverlay(context, game) {
  final gameProvider = Provider.of<GameProvider>(context, listen: true);

  return Align(
    alignment: Alignment.bottomCenter,
    child: Container(
        color: const Color.fromARGB(200, 50, 50, 50),
        width: double.infinity,
        height: game.size.y / 6,
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(bottom: 12, left: 8),
              child: Row(
                children: [
                  Text("Health: ${gameProvider.health}", style: Theme.of(context).textTheme.labelMedium,),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Hunger: ${gameProvider.hunger}", style: Theme.of(context).textTheme.labelMedium,),
                  const SizedBox(
                    width: 10,
                  ),
                  Text("Actions: ${gameProvider.actionsMade}", style: Theme.of(context).textTheme.labelMedium,)
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
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
                      game.paused = true;
                      game.overlays.add('inventory');
                    },
                    child: const Image(image: AssetImage("assets/images/Inventory.png"))
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                SizedBox(
                  width: 80,
                  height: 80,
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
                      ),
                    ),
                    onPressed: () {
                      game.paused = true;
                      game.overlays.add('map');
                    },
                    child: const Image(image: AssetImage("assets/images/Map.png"), fit: BoxFit.cover)
                  ),
                ),
                const SizedBox(
                  width: 90,
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      splashFactory: NoSplash.splashFactory,
                      enableFeedback: false,
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
                      game.gameProvider.playSfx("audio/button.mp3");
                      game.paused = true;
                      game.overlays.add('title');
                      game.gameProvider.playBgm("audio/menu.mp3");
                    },
                    child: const Image(image: AssetImage("assets/images/Home.png"))
                  ),
                ),
              ],
            ),
          ],
        )
    )
  );
}