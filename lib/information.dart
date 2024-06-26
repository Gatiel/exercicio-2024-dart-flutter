import 'package:flutter/material.dart';
import 'models/activity.dart';

class InformationScreen extends StatelessWidget {
  final Activity activity;

  const InformationScreen({super.key, required this.activity});

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
              ],
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo: ${activity.type}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Título: ${activity.title.ptBr}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Descrição: ${activity.description.ptBr}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Categoria: ${activity.category.title.ptBr}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Início: ${activity.start}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Fim: ${activity.end}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pessoas:',
              style: TextStyle(fontSize: 16),
            ),
            ...activity.people.map((person) => Text(
              person.name,
              style: const TextStyle(fontSize: 16),
            )),
            const SizedBox(height: 8),
            const Text(
              'Localizações:',
              style: TextStyle(fontSize: 16),
            ),
            ...activity.locations.map((location) => Text(
              location.title.ptBr,
              style: const TextStyle(fontSize: 16),
            )),
          ],
        ),
      ),
    );
  }
}
