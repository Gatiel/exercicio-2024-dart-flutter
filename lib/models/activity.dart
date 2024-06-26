// lib/models/activity.dart

import 'package:html/parser.dart' show parseFragment;

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
