import 'package:flutter/material.dart';
import 'package:http_app/model/User.dart';
import 'package:http_app/service/user_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP and Data Persistence',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

//we are making user state to maintain state on UI
class _UserScreenState extends State<UserScreen> {
  final UserService _userService = UserService();
  User? _user;

  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() async {
    User? user = await _userService.loadUser();
    setState(() {
      _user = user;
    });
  }

  void _fetchAndSaveUser() async {
    User user = await _userService.fetchUser();
    await _userService.saveUser(user);
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _user == null 
        ? Text('No User Loaded!') 
        : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(_user!.thumbnail),
            Text(_user!.name),
            Text(_user!.email)
          ],
        ) ,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAndSaveUser,
        child: Icon(Icons.refresh),
        ),
    );
  }
}
