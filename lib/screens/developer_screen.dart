import 'package:flutter/material.dart';

class DeveloperScreen extends StatelessWidget {
  const DeveloperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Информация о разработчике'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/developer_avatar.png'),
              child: Icon(Icons.person, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text(
              'Максимова Софья Николаевна',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Группа: ИСТУ-22-1',
              style: TextStyle(fontSize: 18, color: Colors.blue),
            ),
            const SizedBox(height: 30),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const ListTile(
                      leading: Icon(Icons.email),
                      title: Text('Email'),
                      subtitle: Text('student@university.unik'),
                    ),
                    const Divider(),
                    const ListTile(
                      leading: Icon(Icons.phone),
                      title: Text('Phone'),
                      subtitle: Text('+7 (999) 123-45-67'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.code),
                      title: const Text('GitHub'),
                      subtitle: const Text('github.com/student'),
                      onTap: () {
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school, size: 50, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(
                    'Лабораторная работа №7\nРазработка мобильных приложений\nна Dart и Flutter',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}