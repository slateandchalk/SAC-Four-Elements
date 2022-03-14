import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:sac_slide_puzzle/app/app.dart';
import 'package:sac_slide_puzzle/bootstrap.dart';
import 'package:streaming_shared_preferences/streaming_shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  StreamingSharedPreferences preferences = await StreamingSharedPreferences.instance;
  preferences.setInt('currentIndex', 0);
  preferences.setInt('totalMoves', 0);
  preferences.setBool('canPress', true);
  preferences.setString('nickName', '');
  preferences.setString('airTime', '0');
  preferences.setString('earthTime', '0');
  preferences.setString('waterTime', '0');
  preferences.setString('fireTime', '0');
  preferences.setBool('stateStarted', false);
  preferences.setBool('audioState', false);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  bootstrap(() => const App());
}
