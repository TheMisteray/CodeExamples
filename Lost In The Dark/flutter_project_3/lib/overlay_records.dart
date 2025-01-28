import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

///
/// Records Overlay
/// Displays speed records from user prefs
/// 
recordsOverlay(context, game) {
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
        Text("Records",
        style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center,),
        const SizedBox(
          height: 10,
        ),
        Text(gameProvider.records[0] == 10000? "1st: No Record" : "1st: Actions Made: ${gameProvider.records[0]}",
        style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(
          height: 10,
        ),
        Text(gameProvider.records[1] == 10000? "2nd: No Record" : "2nd: Actions Made: ${gameProvider.records[1]}",
        style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(
          height: 10,
        ),
        Text(gameProvider.records[2] == 10000? "3rd: No Record" : "3rd: Actions Made: ${gameProvider.records[2]}",
        style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(
          height: 10,
        ),
        Text(gameProvider.records[3] == 10000? "4th: No Record" : "4th: Actions Made: ${gameProvider.records[3]}",
        style: Theme.of(context).textTheme.bodyMedium,),
        const SizedBox(
          height: 10,
        ),
        Text(gameProvider.records[4] == 10000? "5th: No Record" : "5th: Actions Made: ${gameProvider.records[4]}",
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
          onPressed: () {
            game.gameProvider.playSfx("audio/button.mp3");
            game.overlays.remove('records');
            gameProvider.resetGame();
          },
          child: Text("Back",
          style: Theme.of(context).textTheme.displaySmall,),
        ),
      ],
    ),
  );
}