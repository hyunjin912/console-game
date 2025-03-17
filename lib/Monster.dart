import 'package:console_game/Character.dart';

class Monster {
  String name;
  int hp;
  int? maxAtk;
  int def = 0;

  Monster({required this.name, required this.hp, int? maxAtk}) {}

  void attackCharacter(Character character) {}

  void showStatus() {}
}
