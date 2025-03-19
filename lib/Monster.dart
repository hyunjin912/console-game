import 'dart:math';
import 'package:console_game/Character.dart';

/// 몬스터를 만들기 위한 클래스
class Monster {
  String name;
  int hp;
  int def = 0;
  int atk = 0;
  int characterDef;
  int maxAtk;

  Monster({
    required this.name,
    required this.hp,
    required this.characterDef,
    required this.maxAtk,
  }) {
    int random = Random().nextInt(maxAtk - characterDef + 1) + characterDef;
    atk = random;
  }

  /// 캐릭터를 공격하는 메서드
  void attackCharacter(Character character) {
    int realAtk = atk - character.def;
    character.hp -= realAtk;

    print('$name이(가) ${character.name}에게 $realAtk의 데미지를 입혔습니다.');
  }

  /// 행동(턴)이 끝난 후 몬스터의 상태를 보여주기 위한 메서드
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $atk');
  }

  // print()로 몬스터의 속성을 보기 위해 오버라이딩
  @override
  String toString() {
    return 'Monster {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
