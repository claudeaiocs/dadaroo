enum TakeawayType {
  chinese,
  indian,
  pizza,
  fishAndChips,
  kebab,
  thai,
  burger,
  sushi,
  other,
  custom;

  String get displayName {
    switch (this) {
      case TakeawayType.chinese:
        return 'Chinese';
      case TakeawayType.indian:
        return 'Indian';
      case TakeawayType.pizza:
        return 'Pizza';
      case TakeawayType.fishAndChips:
        return 'Fish & Chips';
      case TakeawayType.kebab:
        return 'Kebab';
      case TakeawayType.thai:
        return 'Thai';
      case TakeawayType.burger:
        return 'Burger';
      case TakeawayType.sushi:
        return 'Sushi';
      case TakeawayType.other:
        return 'Other';
      case TakeawayType.custom:
        return 'Custom';
    }
  }

  String get emoji {
    switch (this) {
      case TakeawayType.chinese:
        return '🥡';
      case TakeawayType.indian:
        return '🍛';
      case TakeawayType.pizza:
        return '🍕';
      case TakeawayType.fishAndChips:
        return '🐟';
      case TakeawayType.kebab:
        return '🥙';
      case TakeawayType.thai:
        return '🍜';
      case TakeawayType.burger:
        return '🍔';
      case TakeawayType.sushi:
        return '🍣';
      case TakeawayType.other:
        return '🍽️';
      case TakeawayType.custom:
        return '✨';
    }
  }
}
