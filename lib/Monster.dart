import 'dart:math';

import 'package:console_game/Character.dart';

class Monster {
  String name;
  int hp;
  int def = 0;
  int atk = 0;
  int characterDef;
  int maxAtk;

  // Monster({required this.name, required this.hp});
  Monster({
    required this.name,
    required this.hp,
    required this.characterDef,
    required this.maxAtk,
  }) {
    int random = Random().nextInt(maxAtk - characterDef + 1) + characterDef;
    this.atk = random;
  }

  void attackCharacter(Character character) {
    int realAtk = atk - character.def;
    character.hp -= realAtk;

    print('$name이(가) ${character.name}에게 $realAtk의 데미지를 입혔습니다.');
  }

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $atk\n');
  }

  @override
  String toString() {
    return 'Monster {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
