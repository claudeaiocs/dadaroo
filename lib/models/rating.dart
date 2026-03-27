class Rating {
  final double speed;
  final double foodChoice;
  final double communication;
  final double overallDadness;

  Rating({
    required this.speed,
    required this.foodChoice,
    required this.communication,
    required this.overallDadness,
  });

  double get average => (speed + foodChoice + communication + overallDadness) / 4;
}
