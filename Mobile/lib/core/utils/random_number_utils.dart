import 'dart:math';

class RandomNumberUtils {
  static int generateRandomNumber() {
    final Random random = Random();

    return 1000 + random.nextInt(9000);
  }
}
