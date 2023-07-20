// // class LoginModel with ChangeNotifier {
// //   String? _username;
// //   String? _password;
// //   bool _isLoggedIn = false;

// //   String? get username => _username;
// //   String? get password => _password;
// //   bool get isLoggedIn => _isLoggedIn;

// //   bool get isValid {
// //     return _username != null &&
// //         _username!.isNotEmpty &&
// //         _password != null &&
// //         _password!.isNotEmpty;
// //   }

// //   void setUsername(String username) {
// //     _username = username;
// //     notifyListeners();
// //   }

// //   void setPassword(String password) {
// //     _password = password;
// //     notifyListeners();
// //   }

// //   Future<void> login() async {
// //     if (!isValid) {
// //       // Validation failed, return without attempting to login
// //       return;
// //     }

// //     Future<void> login() async {
// //       final url =
// //           'https://portal.fastsmsnigeria.com/api/?username=$_username&password=$_password&action=login';

// //       try {
// //         final response = await http.get(Uri.parse(url));

// //         if (response.statusCode == 200) {
// //           // Successful login
// //           final jsonData = json.decode(response.body);
// //           final String status = jsonData['status'];
// //           // if (status == 'OK') {
// //           //          if (status == 'OK') {
// //           // goToPush(context, const HomeScreen());
// //           //    }
// //           _isLoggedIn = true;
// //           print(status);
// //           notifyListeners();
// //         } else {
// //           // Failed login

// //           _isLoggedIn = false;
// //           notifyListeners();
// //         }
// //       } catch (e) {
// //         // Error occurred
// //         _isLoggedIn = false;
// //         notifyListeners();
// //       }
// //     }
// //   }
// // }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:nbsms/api_service/http_service.dart';
// import 'package:nbsms/navigators/goto_helper.dart';
// import 'package:nbsms/screens/home_screen.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginProvider extends ChangeNotifier {
//   // Handle page routing based on login status
//   void pageRoute(BuildContext context, String status) async {
//     SharedPreferences pref = await SharedPreferences.getInstance();
//     await pref.setString("login", status);
//     goToPush(context, const HomeScreen());
//   }

//   Future<void> login(
//       BuildContext context, String username, String password) async {
//     final url = APIConstants.getApiUrl('login');
//     final response = await http.post(Uri.parse(url), body: {
//       'username': username,
//       'password': password,
//     });

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       final String status = jsonData['status'];
//       if (status == 'OK') {
//         // Successful login
//         goToPush(context, const HomeScreen());
//         pageRoute(context, status);
//       }
//     } else {
//       // Failed login
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
//       // Handle the error response
//     }
//   }
//   // loginusrrqt() async {
//   //   var data = {
//   //     "username": emailController.text,
//   //     "password": pwordController.text,
//   //     "action": "login",
//   //   };
//   //   final response = await http
//   //       .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);
//   //   if (response.statusCode == 200) {
//   //     var data = jsonDecode(response.body);

//   //     if (data['status'] == "OK") {
//   //       LocalStorage().storeToken(emailController.text);
//   //       // LocalStorage().storeusername(emailController.text);
//   //       // LocalStorage().storepassword(pwordController.text);
//   //       Navigator.pushReplacement(context,
//   //           MaterialPageRoute(builder: (context) => const DashboardScreen()));
//   //       // }
//   //       print(data['status']);
//   //     }
//   //     if (data['error'] != "") {
//   //       print(data['error']);
//   //     }
//   //   } else {
//   //     print(response.body);
//   //   }
//   // }

// }

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:nbsms/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String? _token;

  String? get token => _token;

  UserProvider() {
    // Retrieve token from shared preferences on initialization
    initializeToken();
  }

  void initializeToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('login');
    notifyListeners();
  }

  void storeToken(String status) async {
    _token = status;
    // Save token to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('login', status);
    notifyListeners();
  }

//  storeToken(String token) async{
//     var storaged = await SharedPreferences.getInstance();
//     await storaged.setString("auth_token", jsonEncode(token));
//   }
  // Future<String?> fetchToken() async{
  //   final storaged = await SharedPreferences.getInstance();
  //   return storaged.getString(jsonDecode("auth_token"));
  // }

  logoff() async {
    final storaged = await SharedPreferences.getInstance();
    await storaged.remove("login");
  }

  void loginusrrqt(BuildContext context) async {
    var emailController = TextEditingController();
    var pwordController = TextEditingController();

    var data = {
      "username": emailController.text,
      "password": pwordController.text,
      "action": "login",
    };

    final response = await http
        .post(Uri.parse("https://portal.fastsmsnigeria.com/api/?"), body: data);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      final status = data['status'];
      if (status == "OK") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('login', emailController.text);
        Provider.of<UserProvider>(context, listen: false)
            .storeToken(emailController.text);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
        print(data['status']);
      } else if (data['error'] == "") {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
        print(data['error']);
      }
    } else {
      // This line does not make sense in this context
      // const CircularProgressIndicator();
      print(response.body);
    }
  }
}
