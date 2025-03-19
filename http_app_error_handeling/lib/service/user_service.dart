import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_app/model/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  final String apiUrl = "https://randomuser.me/api/";

  final String nameKey = 'userName';
  final String emailKey = 'userEmail';
  final String thumbnailKey = 'userThumbnail';

  // adding future because we are fetching from server,
  //will request and server will response

  //Fetch user from Server
  // Future<User> fetchUser() async {
  //   final response = await http.get(Uri.parse(apiUrl));

  //   if (response.statusCode == 200) {
  //     return User.fromJson(json.decode(response.body));
  //   } else {
  //     throw Exception('Failed to load user');
  //   }
  // }

  Future<User> fetchUser() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        return User.fromJson(json.decode(response.body));
      } else {
        // Use the custom exception for non-200 responses
        throw FetchDataException(
            'Failed to load user, Status code: ${response.statusCode}');
      }
    } on http.ClientException {
      // Handle client-side errors
      throw FetchDataException('Client error occurred');
    } catch (e) {
      // Catch and rethrow any other exceptions as a FetchDataException
      throw FetchDataException(e.toString());
    }
  }

  //saving user into our local storage
  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(nameKey, user.name);
    await prefs.setString(emailKey, user.email);
    await prefs.setString(thumbnailKey, user.thumbnail);
  }

  //fetching data from our local storage
  Future<User?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString(nameKey);
    final email = prefs.getString(emailKey);
    final thumbnail = prefs.getString(thumbnailKey);

    if (name != null && email != null && thumbnail != null) {
      return User(name: name, email: email, thumbnail: thumbnail);
    }
    return null;
  }

  //we are creating the service where we will fetch data from server
  //and save in our shared pref its our local data storage.
}

// Custom Exception for fetch data errors
class FetchDataException implements Exception {
  final String message;
  FetchDataException(this.message);

  @override
  String toString() => "FetchDataException: $message";
}

// Optional: Custom Exception for no Internet connection
class NoInternetException implements Exception {
  final String message;
  NoInternetException(this.message);

  @override
  String toString() => "NoInternetException: $message";
}
