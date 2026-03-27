import 'dart:math';

class DadJokes {
  static final _random = Random();

  static const List<String> jokes = [
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
    "What do you call a dad bringing food home? A hero!",
    "I'm terrified of elevators. I'm going to start taking steps to avoid them.",
    "What's orange and sounds like a parrot? A carrot!",
    "Dad's home with the food... that's what I call a special delivery!",
  ];

  static String get random => jokes[_random.nextInt(jokes.length)];
}
