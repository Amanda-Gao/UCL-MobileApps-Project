import 'package:vibration/vibration.dart';

class MyVibrate{

  high() async {
    Vibration.vibrate(pattern: [500, 1000, 500, 1000, 500, 1000, 500, 1000], intensities: [1, 255]);
  }

  fluffy() async {
    Vibration.vibrate(pattern: [500, 100, 500, 100, 500, 100, 500, 100], intensities: [1, 255]);
  }

  cancel() async {
    Vibration.cancel();
  }
}