import 'dart:math';
import 'package:dadaroo/config/app_config.dart';

class ParentJokes {
  static final _random = Random();

  static const List<String> _dadJokes = [
    "Why did the pizza maker go broke? Because he just couldn't make enough dough!",
    "I'm on a seafood diet. I see food and I eat it!",
    "What do you call a fake noodle? An impasta!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What did the sushi say to the bee? Wasabi!",
    "I told my wife she was drawing her eyebrows too high. She looked surprised.",
    "Why did the burger go to the gym? To get better buns!",
    "What do you call cheese that isn't yours? Nacho cheese!",
    "I'm reading a book about anti-gravity. It's impossible to put down!",
    "Why did the tomato turn red? Because it saw the salad dressing!",
    "What do you call a dad who falls through a screen door? A strain!",
    "I used to hate facial hair, but then it grew on me.",
    "Why can't a bicycle stand on its own? It's two-tired!",
    "What did the fish say when it hit the wall? Dam!",
    "I just got a job at a bakery. I'm making dough!",
    "Why did the kebab go to school? To get a little more seasoned!",
    "What do you call a parent bringing food home? A hero!",
    "I'm terrified of elevators. I'm going to start taking steps to avoid them.",
    "What's orange and sounds like a parrot? A carrot!",
    "Food has arrived... that's what I call a special delivery!",
  ];

  static const List<String> _mumJokes = [
    "Why did the pizza maker go broke? Because he just couldn't make enough dough!",
    "I'm on a seafood diet. I see food and I eat it!",
    "What do you call a fake noodle? An impasta!",
    "Why don't eggs tell jokes? They'd crack each other up!",
    "What did the sushi say to the bee? Wasabi!",
    "Why did the burger go to the gym? To get better buns!",
    "What do you call cheese that isn't yours? Nacho cheese!",
    "Why did the tomato turn red? Because it saw the salad dressing!",
    "Why can't a bicycle stand on its own? It's two-tired!",
    "I just got a job at a bakery. I'm making dough!",
    "Why did the kebab go to school? To get a little more seasoned!",
    "What do you call a mum bringing food home? A hero!",
    "What's orange and sounds like a parrot? A carrot!",
    "Food has arrived... that's what I call a special delivery!",
    "I told my kids I'd be back with food in 10 minutes. They started a countdown.",
    "Why did the chicken cross the road? Because Mum said dinner was ready!",
    "My family said I always pick the best takeaways. I said it's a gift!",
    "They say the way to a family's heart is through their stomach. Challenge accepted!",
    "I asked the kids what they wanted for dinner. They said 'food'. Very helpful.",
    "My superpower? Knowing exactly what everyone wants to eat. Most of the time.",
  ];

  static List<String> get jokes =>
      appConfig.parentRole == 'Mum' ? _mumJokes : _dadJokes;

  static String get random => jokes[_random.nextInt(jokes.length)];
}
