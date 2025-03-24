import 'icoffee.dart';

class Espresso implements ICoffee {
  @override
  double get coffeeBeansNeeded => 50;

  @override
  double get milkNeeded => 0;

  @override
  double get waterNeeded => 100;

  @override
  double get cost => 100;
}

class Americano implements ICoffee {
  @override
  double get coffeeBeansNeeded => 50;

  @override
  double get milkNeeded => 0;

  @override
  double get waterNeeded => 200;

  @override
  double get cost => 120;
}

class Cappuccino implements ICoffee {
  @override
  double get coffeeBeansNeeded => 50;

  @override
  double get milkNeeded => 100;

  @override
  double get waterNeeded => 100;

  @override
  double get cost => 150;
}

class Latte implements ICoffee {
  @override
  double get coffeeBeansNeeded => 50;

  @override
  double get milkNeeded => 200;

  @override
  double get waterNeeded => 100;

  @override
  double get cost => 200;
}

class FlatWhite implements ICoffee {
  @override
  double get coffeeBeansNeeded => 60;

  @override
  double get milkNeeded => 150;

  @override
  double get waterNeeded => 100;

  @override
  double get cost => 180;
}

class LatteMacchiato implements ICoffee {
  @override
  double get coffeeBeansNeeded => 50;

  @override
  double get milkNeeded => 200;

  @override
  double get waterNeeded => 100;

  @override
  double get cost => 200;
}