import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:html/parser.dart' show parseFragment;
import 'package:go_router/go_router.dart';
import 'models/activity.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _currentDate = DateTime(2023, 11, 26);

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    ...filteredActivities.map((activity) {
                      return OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          context.push('/information', extra: activity);
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
  const IconTextRectangle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Ajuste o padding conforme necessário
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 16.0), // Ajuste o padding conforme necessário
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
          mainAxisSize: MainAxisSize.min, // Adjust the size of Row to its content
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today,
              color: Colors.blue,
            ),
            SizedBox(width: 10.0), // Espaçamento entre o ícone e o texto
            Text(
              'Exibindo todas atividades',
              style: TextStyle(color: Colors.black, fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}



class ActivityWidget extends StatelessWidget {
  final Activity activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.inversePrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${activity.type} de ${activity.start.hour}:${activity.start.minute.toString().padLeft(2, '0')} até ${activity.end.hour}:${activity.end.minute.toString().padLeft(2, '0')}',
          ),
          Text(
            activity.title.ptBr,
            style: const TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic, color: Colors.blue),
          ),
          Text(
            activity.people.isNotEmpty ? activity.people[0].name : '',
          ),
        ],
      ),
    );
  }
}
