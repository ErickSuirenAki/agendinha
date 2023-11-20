import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Contact {
  String name;
  String phone;
  String email;

  Contact({required this.name, required this.phone, required this.email});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Contact> contacts = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agenda de contatos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddContactScreen(),
                  ),
                );

                if (result != null && result is Contact) {
                  setState(() {
                    contacts.add(result);
                  });
                }
              },
              child: Text('Novo Contato'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContactsScreen(contacts: contacts),
                  ),
                );
              },
              child: Text('Contatos'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactsScreen extends StatelessWidget {
  final List<Contact> contacts;

  ContactsScreen({required this.contacts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contatos'),
      ),
      body: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(contacts[index].name),
            subtitle: Text(
                'Telefone: ${contacts[index].phone}\nE-mail: ${contacts[index].email}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contato removido: ${contacts[index].name}'),
                  ),
                );

                contacts.removeAt(index);

                // Atualizar a tela para refletir a remoção
                Navigator.popAndPushNamed(context, '/contacts');
              },
            ),
          );
        },
      ),
    );
  }
}

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Contato'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Telefone'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'E-mail'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  Contact newContact = Contact(
                    name: nameController.text,
                    phone: phoneController.text,
                    email: emailController.text,
                  );

                  Navigator.pop(context, newContact);
                }
              },
              child: Text('Adicionar Contato'),
            ),
          ],
        ),
      ),
    );
  }
}
