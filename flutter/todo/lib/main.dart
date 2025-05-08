import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GetScreen(),
    );
  }
}

class GetScreen extends StatefulWidget {
  const GetScreen({super.key});

  @override
  State<GetScreen> createState() => _GetScreenState();
}

class _GetScreenState extends State<GetScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  Future<void> submit(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse("http://192.168.29.105:8080/user"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "firstname": firstnameController.text,
        "lastname": lastnameController.text,
        "username": usernameController.text,
        "password": passwordController.text
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: Text('Submitted successfully: ${response.body}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to submit: ${response.body}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: firstnameController,
                decoration:
                    const InputDecoration(hintText: 'Enter your first name'),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: lastnameController,
                decoration:
                    const InputDecoration(hintText: 'Enter your last name'),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: usernameController,
                decoration:
                    const InputDecoration(hintText: 'Enter your  Username'),
              ),
              const SizedBox(height: 5),
              TextFormField(
                controller: passwordController,
                decoration:
                    const InputDecoration(hintText: 'Enter your password'),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => submit(context), // Fixed onPressed callback
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircularProgressIndicator(),
                      )
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;
  Future<void> login(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(
        Uri.parse("http://192.168.29.105:8080/auth"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": usernameController.text,
          "password": passwordController.text
        }));
    if (response.statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Message'),
              content: Text('login success: ${response.body}'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const GetHome()));
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const GetHome()));
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Failed',
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
            content: Text('Failed to submit: ${response.body}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: const InputDecoration(hintText: 'enter username'),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(hintText: 'enter password'),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    login(context);
                  },
                  child: _isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: CircularProgressIndicator(),
                        )
                      : const Text('login'))
            ],
          ),
        ),
      ),
    );
  }
}

class GetHome extends StatefulWidget {
  const GetHome({super.key});

  @override
  State<GetHome> createState() => _GetHomeState();
}

class _GetHomeState extends State<GetHome> {
  bool _isLoading = false;
  List<Map<String, dynamic>>? responseBody;

  Future<void> get() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse("http://192.168.29.105:8080/user"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        setState(() {
          responseBody =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        print('Failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : responseBody != null && responseBody!.isNotEmpty
                  ? ListView.builder(
                      itemCount: responseBody!.length,
                      itemBuilder: (context, index) {
                        final user = responseBody![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Firstname: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(user['firstname'] ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Lastname: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(user['lastname'] ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Username: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(user['username'] ?? 'N/A'),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text('Password: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(user['password'] ?? 'N/A'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(child: Text('No data available')),
        ),
      ),
    );
  }
}
