import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

///
/// Game Over overlay
/// Only has a display and a home button
/// 
LoseOverlay(context, game) {
  final gameProvider = Provider.of<GameProvider>(context, listen: true);

  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black,
    padding: const EdgeInsets.all(30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("GAME OVER",
        style: Theme.of(context).textTheme.displayLarge, textAlign: TextAlign.center,),
        const SizedBox(
          height: 20,
        ),
        Text("Actions Made: ${gameProvider.actionsMade}",
        style: Theme.of(context).textTheme.bodyMedium,),
        Text("Cause of death: ${gameProvider.causeOfDeath}",
        style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
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
          onPressed: () async {
            gameProvider.resetGame();
            game.gameProvider.playSfx("audio/button.mp3");
            game.overlays.remove('gameover');
            game.overlays.add('title');
          },
          child: Text("To Title",
          style: Theme.of(context).textTheme.displaySmall,),
        ),
      ],
    ),
  );
}