import 'package:console_game/Monster.dart';

class Character {
  String name;
  int hp;
  int atk;
  int def;

  Character({
    required this.name,
    required this.hp,
    required this.atk,
    required this.def,
  });

  void attackMonster(Monster monster) {}

  void defend() {}

  void showStatus() {}
}
