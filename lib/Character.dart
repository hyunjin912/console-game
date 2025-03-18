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

  void attackMonster(Monster monster) {
    monster.hp -= atk;
    print('$name이(가) ${monster.name}에게 $atk의 데미지를 입혔습니다.');
  }

  void defend() {}

  void showStatus() {
    print('$name - 체력: $hp, 공격력: $atk, 방어력: $def');
  }

  @override
  String toString() {
    return 'Character {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
