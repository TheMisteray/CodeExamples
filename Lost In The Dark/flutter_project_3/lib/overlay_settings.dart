import 'package:flutter/material.dart';
import 'game_provider.dart';
import 'package:provider/provider.dart';

///
/// Settings Overlay
/// Contains volume options
/// TODO: allow for game customization like starting health
///
Widget SettingsOverlay(context, game){
  final gameProvider = Provider.of<GameProvider>(context, listen: true);

  return Center(
    child: Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Settings",
          style: Theme.of(context).textTheme.displayMedium,),
          const SizedBox(
            height: 20
          ),
          // Music Slider
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 40,
                child: Text("Music",
                style: Theme.of(context).textTheme.bodyMedium,),
              ),
              Expanded(
                child: Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: gameProvider.musicVolume,
                  min: 0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (value) {
                    gameProvider.musicVolume = value;
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 80,
                height: 40,
                child: Text("SFX",
                style: Theme.of(context).textTheme.bodyMedium,),
              ),
              Expanded(
                child: Slider(
                  activeColor: Colors.white,
                  inactiveColor: Colors.grey,
                  value: gameProvider.sfxVolume,
                  min: 0,
                  max: 1.0,
                  divisions: 10,
                  onChanged: (value) {
                    gameProvider.sfxVolume = value;
                  },
                ),
              ),
            ],
          ),
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
              game.overlays.remove('settings');
            },
            child: Text("BACK",
            style: Theme.of(context).textTheme.displaySmall,),
          ),
        ],
      ),
    ),
  );
}