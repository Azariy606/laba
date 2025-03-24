import 'package:flutter/material.dart';
import 'classes/Machine.dart';
import 'classes/resources.dart';
import 'classes/enums.dart';

void main() {
  runApp(const CoffeeMachineApp());
}

class CoffeeMachineApp extends StatelessWidget {
  const CoffeeMachineApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Кофемашина',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
      ),
      home: const CoffeeMachineScreen(),
    );
  }
}

class CoffeeMachineScreen extends StatefulWidget {
  const CoffeeMachineScreen({Key? key}) : super(key: key);

  @override
  _CoffeeMachineScreenState createState() => _CoffeeMachineScreenState();
}

class _CoffeeMachineScreenState extends State<CoffeeMachineScreen> {
  final Machine coffeeMachine = Machine(
    resources: Resources(
      coffeeBeans: 250,
      milk: 250,
      water: 250,
      cash: 0.0,
    ),
    userBalance: 0.0,
  );

  final TextEditingController _moneyController = TextEditingController();
  final TextEditingController _coffeeBeansController = TextEditingController();
  final TextEditingController _milkController = TextEditingController();
  final TextEditingController _waterController = TextEditingController();

  String _statusMessage = "Добро пожаловать в кофемашину!";

  void _makeCoffee(CoffeeType coffeeType) {
    setState(() {
      _statusMessage = coffeeMachine.makeCoffee(coffeeType);
    });
  }

  void _addMoney() {
    double amount = double.tryParse(_moneyController.text) ?? 0;
    if (amount > 0) {
      setState(() {
        coffeeMachine.userBalance += amount;
        _statusMessage = "Баланс пополнен на $amount рублей. Текущий баланс: ${coffeeMachine.userBalance} руб.";
        _moneyController.clear();
      });
    } else {
      setState(() {
        _statusMessage = "Введите корректную сумму.";
      });
    }
  }

  void _withdrawAllMoney() {
    setState(() {
      if (coffeeMachine.userBalance > 0) {
        double withdrawnAmount = coffeeMachine.userBalance;
        coffeeMachine.userBalance = 0;
        _statusMessage = "Снято $withdrawnAmount рублей. Баланс обнулен.";
      } else {
        _statusMessage = "На балансе нет средств.";
      }
    });
  }

  void _addResources() {
    int coffeeBeans = int.tryParse(_coffeeBeansController.text) ?? 0;
    int milk = int.tryParse(_milkController.text) ?? 0;
    int water = int.tryParse(_waterController.text) ?? 0;

    setState(() {
      coffeeMachine.resources.coffeeBeans += coffeeBeans;
      coffeeMachine.resources.milk += milk;
      coffeeMachine.resources.water += water;
      _statusMessage = "Ресурсы пополнены:\n"
          "Кофейные зерна: +$coffeeBeans гр\n"
          "Молоко: +$milk мл\n"
          "Вода: +$water мл";
      _coffeeBeansController.clear();
      _milkController.clear();
      _waterController.clear();
    });
  }

  void _checkResources() {
    setState(() {
      _statusMessage = coffeeMachine.checkResources();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Кофемашина'),
          backgroundColor: Colors.blue[800],
          bottom: TabBar(
            labelColor: Colors.white,
            labelStyle: const TextStyle(fontSize: 14),
            tabs: const [
              Tab(
                icon: Icon(Icons.coffee, color: Colors.white, size: 20),
                text: "Готовка кофе",
              ),
              Tab(
                icon: Icon(Icons.build, color: Colors.white, size: 20),
                text: "Ресурсы",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Вкладка 1: Готовка кофе и пополнение счета
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Окошко с ресурсами и балансом
                  Row(
                    children: [
                      // Окошко с ресурсами (слева)
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Ресурсы:",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Кофейные зерна: ${coffeeMachine.resources.coffeeBeans} гр",
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                Text(
                                  "Молоко: ${coffeeMachine.resources.milk} мл",
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                Text(
                                  "Вода: ${coffeeMachine.resources.water} мл",
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  "Ваш баланс: ${coffeeMachine.userBalance} руб.",
                                  style: const TextStyle(fontSize: 14, color: Colors.green),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Плитка с кнопками (справа)
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            // Поле для ввода суммы
                            TextField(
                              controller: _moneyController,
                              decoration: InputDecoration(
                                labelText: "Сумма (руб)",
                                border: OutlineInputBorder(),
                                labelStyle: const TextStyle(color: Colors.black87),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 10),
                            // Кнопка для пополнения баланса
                            ElevatedButton.icon(
                              onPressed: _addMoney,
                              icon: const Icon(Icons.attach_money, size: 18),
                              label: const Text("Пополнить", style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Кнопка для снятия всех средств
                            ElevatedButton.icon(
                              onPressed: _withdrawAllMoney,
                              icon: const Icon(Icons.money_off, size: 18),
                              label: const Text("Снять", style: TextStyle(fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Выберите кофе:",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      children: [
                        _buildCoffeeCard(
                          CoffeeType.espresso,
                          "https://upload.wikimedia.org/wikipedia/commons/a/a5/Tazzina_di_caff%C3%A8_a_Ventimiglia.jpg",
                          "Эспрессо",
                          100,
                        ),
                        _buildCoffeeCard(
                          CoffeeType.americano,
                          "https://upload.wikimedia.org/wikipedia/commons/0/09/Hokitika_Cheese_and_Deli%2C_Hokitika_%283526706594%29.jpg",
                          "Американо",
                          120,
                        ),
                        _buildCoffeeCard(
                          CoffeeType.cappuccino,
                          "https://upload.wikimedia.org/wikipedia/commons/e/ed/Wet_Cappuccino_with_heart_latte_art.jpg",
                          "Капучино",
                          150,
                        ),
                        _buildCoffeeCard(
                          CoffeeType.latte,
                          "https://upload.wikimedia.org/wikipedia/commons/9/9f/Latte_at_Doppio_Ristretto_Chiang_Mai_01.jpg",
                          "Латте",
                          200,
                        ),
                        _buildCoffeeCard(
                          CoffeeType.flatWhite,
                          "https://sun9-13.userapi.com/impg/9oKim7h6xbgHWZYFBPDsmRRI4LrwM4ggqb7fng/_4SnfuDf7eQ.jpg?size=540x540&quality=96&sign=30d146d076b88a0b75dde46a210cca62&type=album",
                          "Флэт Уайт",
                          180,
                        ),
                        _buildCoffeeCard(
                          CoffeeType.latteMacchiato,
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvOdappAWyGL5aP88si6jjRWuHT_zjLOeJAQ&s",
                          "Латте Макиато",
                          200,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
            // Вкладка 2: Пополнение ресурсов
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Ресурсы:",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Кофейные зерна: ${coffeeMachine.resources.coffeeBeans} гр",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    "Молоко: ${coffeeMachine.resources.milk} мл",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    "Вода: ${coffeeMachine.resources.water} мл",
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Заработано автоматом: ${coffeeMachine.resources.cash} руб.",
                    style: const TextStyle(fontSize: 16, color: Colors.blue), // Заработок автомата
                  ),
                  const SizedBox(height: 20),
                  // Поле для ввода кофейных зерен
                  TextField(
                    controller: _coffeeBeansController,
                    decoration: InputDecoration(
                      labelText: "Кофейные зерна (гр)",
                      border: OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.black87),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  // Поле для ввода молока
                  TextField(
                    controller: _milkController,
                    decoration: InputDecoration(
                      labelText: "Молоко (мл)",
                      border: OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.black87),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  // Поле для ввода воды
                  TextField(
                    controller: _waterController,
                    decoration: InputDecoration(
                      labelText: "Вода (мл)",
                      border: OutlineInputBorder(),
                      labelStyle: const TextStyle(color: Colors.black87),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Кнопка для пополнения ресурсов
                  ElevatedButton(
                    onPressed: _addResources,
                    child: const Text("Пополнить ресурсы", style: TextStyle(fontSize: 14)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoffeeCard(CoffeeType coffeeType, String imageUrl, String name, int cost) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () => _makeCoffee(coffeeType),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                imageUrl,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              "$cost руб",
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }
}