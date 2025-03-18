import 'dart:math';

import 'package:console_game/Character.dart';

class Monster {
  String name;
  int hp;
  late int atk;
  int def = 0;
  int characterDef;
  int maxAtk;

  Monster({
    required this.name,
    required this.hp,
    required this.characterDef,
    required this.maxAtk,
  }) {
    int random = Random().nextInt(maxAtk - characterDef + 1) + characterDef;
    this.atk = random;
  }

  void attackCharacter(Character character) {}

  void showStatus() {}

  @override
  String toString() {
    return 'Monster {name: $name, hp: $hp, atk: $atk, def: $def, characterDef: $characterDef, maxAtk: $maxAtk}';
  }
}
