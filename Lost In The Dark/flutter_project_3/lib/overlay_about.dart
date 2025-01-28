import 'package:flutter/material.dart';

///
/// Game Info Overlay
/// 
AboutOverlay(context, game) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    color: Colors.black,
    padding: EdgeInsets.all(30),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("About the Game",
        style: Theme.of(context).textTheme.displayMedium,),
        Text("Lost in the Dark is traditional style dungeon crawler game wherein you must escape a strange dungeon that you mysteriously wake up in. Your goal is simply to escape the dungeon alive.",
        style: Theme.of(context).textTheme.labelMedium,),
        const SizedBox(
          height: 10,
        ),
        Text("Mechanics",
        style: Theme.of(context).textTheme.displayMedium,),
        Text("Use the arrow buttons to navigate through the dungeon's rooms.\nAs you navigate the dungeon your Hunger will slowly deplete, resulting in your death when it reaches 0.\nAs you progress through the dungeon various random events will be encountered within rooms, offering you choices on how to proceed. These events can have various outcomes such as granting items, damaging your health, or giving you vital information on how to escape.\nEach action you take is tracked, try and escape in as few moves as possible!",
        style: Theme.of(context).textTheme.labelMedium,),
        const SizedBox(
          height: 10,
        ),
        Text("Development",
        style: Theme.of(context).textTheme.displayMedium,),
        Text("Developed by Aiden Grieshaber for IGME340 in just under a month.",
        style: Theme.of(context).textTheme.labelMedium,),
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
          onPressed: () {
            game.gameProvider.playSfx("audio/button.mp3");
            game.overlays.remove('about');
          },
          child: Text("BACK",
          style: Theme.of(context).textTheme.displaySmall,),
        ),
      ],
    ),
  );
}