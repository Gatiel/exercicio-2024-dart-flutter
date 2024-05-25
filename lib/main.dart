import 'package:flutter/material.dart';


void main() {
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF456189), // Cor RGB(69, 97, 137)
        ),
        useMaterial3: true,
      ),
      home: const Calendar(),
    );
  }
}

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}
class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2023, 11, 26);
  bool _clicked = false;

  void _changeDate(DateTime newDate) {
    setState(() {
      _currentDate = newDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Chuva ❤️ Flutter',
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Programação',
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: const [
                    Text('Nov', style: TextStyle(fontSize: 8.0)),
                    Text('2023', style: TextStyle(fontSize: 10.0)),
                  ],
                ),
                SizedBox(width: 5),
                // Espaçamento entre Nov 2023 e os dias
                Expanded(
                  child: Container(
                    color: Colors.lightBlueAccent, // Cor do fundo da linha
                    child: Row(
                      children: List.generate(5, (index) {
                        int day = 26 + index;
                        return Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click, // Altera o cursor para a mão com o dedo
                            child: GestureDetector(
                              onTap: () {
                                _changeDate(DateTime(2023, 11, day));
                              },
                              child: Container(
                                width: 30, // Largura do quadrado
                                height: 30, // Altura do quadrado
                                color: Colors.lightBlueAccent, // Cor do fundo da linha
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(color: Colors.white), // Cor do número do dia
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),





            if (_currentDate.day == 26)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _clicked = true;
                  });
                },
                child: const Text('Mesa redonda de 07:00 até 08:00'),
              ),
            if (_currentDate.day == 28)
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _clicked = true;
                  });
                },
                child: const Text('Palestra de 09:30 até 10:00'),
              ),
            if (_currentDate.day == 26 && _clicked) const Activity(),
          ],
        ),
      ),
    );
  }
}



class Activity extends StatefulWidget {
  const Activity({super.key});

  @override
  State<Activity> createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(children: [
        Text(
          'Activity title',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Text('A Física dos Buracos Negros Supermassivos'),
        const Text('Mesa redonda'),
        const Text('Domingo 07:00h - 08:00h'),
        const Text('Sthepen William Hawking'),
        const Text('Maputo'),
        const Text('Astrofísica e Cosmologia'),
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              _favorited = !_favorited;
            });
          },
          icon: _favorited
              ? const Icon(Icons.star)
              : const Icon(Icons.star_outline),
          label: Text(
              _favorited ? 'Remover da sua agenda' : 'Adicionar à sua agenda'),
        )
      ]),
    );
  }
}
