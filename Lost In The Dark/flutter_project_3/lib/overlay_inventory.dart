import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';
import 'dart:math';

///
/// Inventory Overlay
/// Shows inventory contents which are clickable with descriptions.
///
InventoryOverlay(context, game) {
  final gameProvider = Provider.of<GameProvider>(context, listen: true);

  return Container(
    width: double.infinity,
    height: MediaQuery.sizeOf(context).height,
    color: Colors.black,
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(0),
          child: Text(
            "Inventory",
            style: Theme.of(context).textTheme.displayMedium,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: GridView.builder(
            itemCount: max(16, (gameProvider.inventory.length/4).toInt() * 4 + 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16
            ), 
            itemBuilder: (context, index){
              if (gameProvider.inventory.length > index){
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 6,
                    )
                  ),
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context, 
                        builder: (context){
                          return AlertDialog(
                            insetPadding: const EdgeInsets.all(36),
                            title: Text(gameProvider.inventory[index].name, style: Theme.of(context).textTheme.bodyLarge),
                            titleTextStyle: Theme.of(context).textTheme.displayMedium,
                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0)), side: BorderSide(width: 5, color: Colors.white)),
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image(image: AssetImage("assets/images/${gameProvider.inventory[index].sprite}")),
                                Container(
                                  margin: const EdgeInsets.only(top: 16, bottom: 16),
                                  child: Text(gameProvider.inventory[index].description, style: Theme.of(context).textTheme.bodySmall)
                                ),
                              ],
                            ),
                          );
                        }
                      );
                    },
                    child: Image.asset("assets/images/${gameProvider.inventory[index].sprite}"),
                  ),
                );
              } else {
                return Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      width: 6,
                    )
                  )
                );
              }
            }
          )
        ),
        const SizedBox(
          height: 20,
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
              game.overlays.remove('inventory');
            },
            child: const Image(image: AssetImage("assets/images/Arrow.png"))
          ),
        ),
      ],
    )
  );
}