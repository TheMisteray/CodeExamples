import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

///
/// Title Screen Overlay
/// Contains button navigation to other parts of the game
///
class OverlayTitle extends StatelessWidget {
  final game;
  const OverlayTitle({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Title Text
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Text(
              "Lost In The",
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
          Container(
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.all(0),
            child: Text(
              "DARK",
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ),
          SizedBox(height: 20),
          SizedBox( //Play button
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                //overlayColor: Colors.transparent,
                enableFeedback: false,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                side: const BorderSide(
                  color: Colors.white,
                  width: 5
                )
              ),
              onPressed: () {
                game.gameProvider.playSfx("audio/button.mp3");
                game.paused = false;
                game.updateGameRoom();
                game.overlays.remove('title');
                game.overlays.add('main');
                game.gameProvider.playBgm("audio/gamebgm.mp3");
              },
              child: Text("PLAY",
              style: Theme.of(context).textTheme.displaySmall,),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox( //Settings Button
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                //shadowColor: Colors.black,
                //elevation: 10.0,
                enableFeedback: false,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                side: const BorderSide(
                  color: Colors.white,
                  width: 5
                )
              ),
              onPressed: () {
                game.gameProvider.playSfx("audio/button.mp3");
                game.overlays.add('settings');
              },
              child: Text("OPTIONS",
              style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox( //Records Button
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                enableFeedback: false,
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
                game.overlays.add('records');
              },
              child: Text("RECORDS",
              style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SizedBox( //Quit Button
            width: 200,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                splashFactory: NoSplash.splashFactory,
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                enableFeedback: false,
                //shadowColor: Colors.black,
                //elevation: 10.0,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                side: const BorderSide(
                  color: Colors.white,
                  width: 5
                )
              ),
              onPressed: () { //Might close app? Apparently IOS has issues with this
                Future.delayed(const Duration(milliseconds: 500), () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                });
              },
              child: Text("EXIT",
              style: Theme.of(context).textTheme.displaySmall),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox( //About Button
                width: 95,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    enableFeedback: false,
                    //shadowColor: Colors.black,
                    //elevation: 10.0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 3
                    )
                  ),
                  onPressed: () {
                    game.gameProvider.playSfx("audio/button.mp3");
                    game.overlays.add('about');
                  },
                  child: Text("About",
                  style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox( //Docs Button
                width: 95,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    splashFactory: NoSplash.splashFactory,
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.black,
                    enableFeedback: false,
                    //shadowColor: Colors.black,
                    //elevation: 10.0,
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
                    side: const BorderSide(
                      color: Colors.white,
                      width: 3
                    )
                  ),
                  onPressed: () async {
                    Uri url = Uri.parse("https://docs.google.com/document/d/1Wj0Ml3CN-8u1-y75LVC9fDK1YepjBldo9NKat7SkEoM/edit?usp=sharing");
                    if (!await launchUrl(url, mode: LaunchMode.inAppWebView)){
                      throw "Count not lauch $url";
                    }
                  },
                  child: Text("Docs",
                  style: Theme.of(context).textTheme.labelSmall,),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}