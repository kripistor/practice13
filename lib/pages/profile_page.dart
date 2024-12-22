import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'orders_page.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = _authService.getCurrentUserEmail() ?? '';
    _nameController.text = _authService.getCurrentUserName() ?? 'Виктор';
  }

  Future<void> _updateProfile() async {
    final name = _nameController.text;
    if (name.isNotEmpty) {
      try {
        //await _authService.updateUserName(name);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Профиль обновлен')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка обновл��ния профиля: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              if (!_isEditing) {
                _updateProfile(); // Сохраняем изменения, если завершено редактирование
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                child: Icon(Icons.person, size: 50),
              ),
            ),
            const SizedBox(height: 20),
            _isEditing
                ? TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Почта'),
              enabled: false, // Почта не редактируемая
            )
                : Text(
              'Почта: ${_emailController.text}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            _isEditing
                ? TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Имя'),
            )
                : Text(
              'Имя: ${_nameController.text}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            if (_isEditing)
              Center(
                child: ElevatedButton(
                  onPressed: _updateProfile,
                  child: const Text('Сохранить изменения'),
                ),
              ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OrdersPage()),
                  );
                },
                child: const Text('Мои заказы'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}