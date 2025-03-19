import 'package:flutter/material.dart';
import 'package:http_app/model/User.dart';
import 'package:http_app/service/user_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HTTP and Persistence Demo',
      home: UserScreen(),
    );
  }
}

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final UserService _userService = UserService();
  User? _user;
  String _errorMessage = '';

  void _fetchAndSaveUser() async {
    try {
      User user = await _userService.fetchUser();
      setState(() {
        _user = user;
        _errorMessage = '';
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random User Fetcher'),
      ),
      body: Center(
        child: _errorMessage.isNotEmpty
            ? Text(_errorMessage)
            : _user == null
              ? Text('No user loaded')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(_user!.thumbnail),
                    Text(_user!.name),
                    Text(_user!.email),
                  ],
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchAndSaveUser,
        tooltip: 'Fetch User',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
