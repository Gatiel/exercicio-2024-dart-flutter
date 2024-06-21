import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart' show parseFragment;

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
          seedColor: const Color(0xFF456189),
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

  Future<List<Activity>> loadActivities() async {
    final jsonString1 = await rootBundle.loadString('assets/activities.json');
    final jsonString2 = await rootBundle.loadString('assets/activities-1.json');

    final jsonResponse1 = json.decode(jsonString1);
    final jsonResponse2 = json.decode(jsonString2);

    final List<Activity> activities1 = (jsonResponse1['data'] as List)
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();

    final List<Activity> activities2 = (jsonResponse2['data'] as List)
        .map((activityJson) => Activity.fromJson(activityJson))
        .toList();

    // Combine both lists of activities
    List<Activity> allActivities = [...activities1, ...activities2];

    return allActivities;
  }

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
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
        toolbarHeight: 120,
      ),
      body: FutureBuilder<List<Activity>>(
        future: loadActivities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final activities = snapshot.data!;
            final filteredActivities = activities.where((activity) {
              return _currentDate.day == activity.start.day;
            }).toList();

            return SingleChildScrollView(
              child: Center(
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
                            color: Colors.lightBlueAccent,
                            child: Row(
                              children: List.generate(5, (index) {
                                int day = 26 + index;
                                bool isSelected = _currentDate.day == day;
                                return Padding(
                                  padding: const EdgeInsets.only(left: 4.0),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onTap: () {
                                        _changeDate(DateTime(2023, 11, day));
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.lightBlueAccent,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '$day',
                                            style: TextStyle(
                                              color: isSelected
                                                  ? Colors.white
                                                  : const Color(0x8AFFFFFF),
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
                    // Exibe as atividades filtradas para o dia atual (_currentDate.day)
                    ...filteredActivities.map((activity) {
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _clicked = true;
                          });
                        },
                        child: ActivityWidget(activity: activity),
                      );
                    }),
                  ],
                ),
              ),
            );
          }
        },
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
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_month,
            color: Colors.blue,
          ),
          SizedBox(width: 120.0),
          Text(
            'Exibindo todas atividades',
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}

class Title {
  final String ptBr;

  Title({required this.ptBr});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      ptBr: json['pt-br'] ?? '',
    );
  }
}

class Description {
  final String ptBr;

  Description({required this.ptBr});

  factory Description.fromJson(Map<String, dynamic> json) {
    // Processa e remove as tags HTML removendo Null
    String cleanHtml =
    json['pt-br'] != null ? parseFragment(json['pt-br']!).text ?? '' : '';

    return Description(
      ptBr: cleanHtml,
    );
  }
}

class Category {
  final int id;
  final Title title;
  final String color;
  final String backgroundColor;

  Category({
    required this.id,
    required this.title,
    required this.color,
    required this.backgroundColor,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      title: Title.fromJson(json['title']),
      color: json['color'] ?? '',
      backgroundColor: json['background-color'] ?? '',
    );
  }
}

class Location {
  final int id;
  final Title title;

  Location({
    required this.id,
    required this.title,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'] ?? 0,
      title: Title.fromJson(json['title']),
    );
  }
}

class Person {
  final int id;
  final String name;

  Person({
    required this.id,
    required this.name,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class Activity {
  final int id;
  final DateTime start;
  final DateTime end;
  final Title title;
  final Description description;
  final Category category;
  final List<Location> locations;
  final String type;
  final List<Person> people;

  Activity({
    required this.id,
    required this.start,
    required this.end,
    required this.title,
    required this.description,
    required this.category,
    required this.locations,
    required this.type,
    required this.people,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    var locationsFromJson = json['locations'] as List? ?? [];
    List<Location> locationList =
    locationsFromJson.map((i) => Location.fromJson(i)).toList();

    var peopleFromJson = json['people'] as List? ?? [];
    List<Person> peopleList =
    peopleFromJson.map((i) => Person.fromJson(i)).toList();

    return Activity(
      id: json['id'] ?? 0,
      start: DateTime.parse(json['start'] ?? ''),
      end: DateTime.parse(json['end'] ?? ''),
      title: Title.fromJson(json['title']),
      description: Description.fromJson(json['description']),
      category: Category.fromJson(json['category']),
      locations: locationList,
      type: json['type']?['title']?['pt-br'] ?? '',
      people: peopleList,
    );
  }
}

class ActivityResponse {
  final int count;
  final List<Activity> data;

  ActivityResponse({
    required this.count,
    required this.data,
  });

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    var list = json['data'] as List? ?? [];
    List<Activity> activitiesList =
    list.map((i) => Activity.fromJson(i)).toList();

    return ActivityResponse(
        count: json['count'] ?? 0,
        data: activitiesList,
    );
  }
}

class ActivityWidget extends StatefulWidget {
  final Activity activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  State<ActivityWidget> createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.activity.type} de ${widget.activity.start.hour}:${widget.activity.start.minute.toString().padLeft(2, '0')} até ${widget.activity.end.hour}:${widget.activity.end.minute.toString().padLeft(2, '0')}',
          ),
          Text(
            widget.activity.title.ptBr,
            style: const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.blue),
          ),
          Text(
            widget.activity.people.isNotEmpty
                ? widget.activity.people[0].name
                : '',
          ),
        ],
      ),
    );
  }
}

