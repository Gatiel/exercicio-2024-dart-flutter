import 'package:flutter/material.dart';


void main() {
  runApp(const ChuvaDart());
}

class ChuvaDart extends StatelessWidget {
  const ChuvaDart({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF456189), // Cor RGB(69, 97, 137)
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_sharp, color: Colors.white),
          onPressed: () {
            // Navigator.of(context).pop();  // Por enquanto não faz nada
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  'Chuva ❤️ Flutter',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Programação',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.white,
                  ),
                ),
                Center(
                  child: IconTextRectangle(),
                ),
              ],
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 120, //define altura do appBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Column(
                  children: [
                    Text('Nov', style: TextStyle(fontSize: 8.0)),
                    Text('2023', style: TextStyle(fontSize: 10.0)),
                  ],
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    color: Colors.lightBlueAccent, // Cor do fundo da linha
                    child: Row(
                      children: List.generate(5, (index) {
                        int day = 26 + index;
                        bool isSelected = _currentDate.day == day;
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
                                decoration: BoxDecoration(
                                  color: Colors.lightBlueAccent,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      color: isSelected ? Colors.white: Color(0x8AFFFFFF),
                                    ),
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

class IconTextRectangle extends StatelessWidget {
  const IconTextRectangle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(120),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(
            Icons.calendar_month,
            color: Colors.blue,
          ),
          SizedBox(width: 120.0),

          Text(
            'Exibindo todas atividades',
            style: TextStyle(
                color: Colors.black,
                fontSize: 16.0
            ),
          ),
        ],
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
      child: Column(
        children: [
          Text(
            'Activity title',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Text('A Física dos Buracos Negros Supermassivos'),
          const Text('Mesa redonda'),
          const Text('Domingo 07:00h - 08:00h'),
          const Text('Stephen William Hawking'),
          const Text('Maputo'),
          const Text('Astrofísica e Cosmologia'),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                _favorited = !_favorited;
              });
            },
            icon: _favorited ? const Icon(Icons.star) : const Icon(Icons.star_outline),
            label: Text(
              _favorited ? 'Remover da sua agenda' : 'Adicionar à sua agenda',
            ),
          ),
        ],
      ),
    );
  }
}
