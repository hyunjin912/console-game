import 'dart:math';

import 'package:console_game/Monster.dart';

/// 캐릭터를 만들기 위한 클래스
class Character {
  String? name;
  int hp;
  int atk;
  int def;
  bool isItemActive = false; // 아이템 사용 여부. false = 사용하지 않은 상태

  Character({required this.hp, required this.atk, required this.def});

  /// 몬스터를 공격하는 메서드
  void attackMonster({required Monster monster, int increase = 1}) {
    int realAtk = (atk * increase) - monster.def;

    if (realAtk <= 0) {
      realAtk = 0;
    }

    if (increase == 2) {
      print('아이템을 사용했습니다. 공격력이 1턴 동안 2배가 됩니다! 현재 공격력: ${atk * increase}\n');
    }

    monster.hp -= realAtk;
    print('$name이(가) ${monster.name}에게 $realAtk의 데미지를 입혔습니다.');

    if (monster.hp <= 0) {
      print('${monster.name}을(를) 물리쳤습니다!');
    }
  }

  /// 몬스터의 공격으로부터 방어를 하기 위한 메서드
  void defend(Monster monster) {
    hp += (monster.atk - def);
    print('$name이(가) 방어 태세를 취하여 ${monster.atk - def}만큼 체력을 얻었습니다.');
  }

  /// 행동(턴)이 끝난 후 캐릭터의 상태를 보여주기 위한 메서드
  void showStatus() {
    print('$name - 체력: $hp, 공격력: $atk, 방어력: $def');
  }

  /// 보너스 체력을 제공하는 메서드
  void getLockyHp() {
    int random = Random().nextInt(10);

    if (random < 3) {
      hp += 10;
      print('\n보너스 체력을 얻었습니다! 현재 체력: $hp');
    }
  }

  // print()로 캐릭터의 속성을 보기 위해 오버라이딩
  @override
  String toString() {
    return 'Character {name: $name, hp: $hp, atk: $atk, def: $def}';
  }
}
