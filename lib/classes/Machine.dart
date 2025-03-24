import 'resources.dart';
import 'enums.dart';
import 'icoffee.dart';
import 'coffee_types.dart';

class Machine {
  Resources resources;
  double userBalance; // Баланс пользователя

  Machine({required this.resources, this.userBalance = 0.0});

  String makeCoffee(CoffeeType coffeeType) {
    ICoffee coffee;
    switch (coffeeType) {
      case CoffeeType.espresso:
        coffee = Espresso();
        break;
      case CoffeeType.americano:
        coffee = Americano();
        break;
      case CoffeeType.cappuccino:
        coffee = Cappuccino();
        break;
      case CoffeeType.latte:
        coffee = Latte();
        break;
      case CoffeeType.flatWhite:
        coffee = FlatWhite();
        break;
      case CoffeeType.latteMacchiato:
        coffee = LatteMacchiato();
        break;
      default:
        return "Неизвестный тип кофе";
    }

    if (userBalance < coffee.cost) {
      return "Недостаточно средств на балансе.";
    }

    if (resources.coffeeBeans >= coffee.coffeeBeansNeeded &&
        resources.milk >= coffee.milkNeeded &&
        resources.water >= coffee.waterNeeded) {
      resources.coffeeBeans -= coffee.coffeeBeansNeeded.toInt();
      resources.milk -= coffee.milkNeeded.toInt();
      resources.water -= coffee.waterNeeded.toInt();
      userBalance -= coffee.cost; // Списание с баланса пользователя
      resources.cash += coffee.cost; // Зачисление в кассу аппарата
      return "Кофе готов!";
    } else {
      return "Недостаточно ресурсов для приготовления кофе.";
    }
  }

  void addResources(int coffeeBeans, int milk, int water) {
    resources.coffeeBeans += coffeeBeans;
    resources.milk += milk;
    resources.water += water;
  }

  String checkResources() {
    return "Остатки в аппарате:\n"
        "Кофейные зерна: ${resources.coffeeBeans} гр\n"
        "Молоко: ${resources.milk} мл\n"
        "Вода: ${resources.water} мл\n"
        "Баланс аппарата: ${resources.cash} руб.\n"
        "Ваш баланс: $userBalance руб.";
  }
}