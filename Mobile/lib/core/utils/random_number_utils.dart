import 'dart:math';

class RandomNumberUtils {
  static int generateRandomNumber() {
    final Random _random = Random();

    return 1000 + _random.nextInt(9000);
  }
}
