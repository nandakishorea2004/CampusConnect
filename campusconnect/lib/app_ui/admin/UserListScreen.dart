import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../../styles/app_colors.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("User");
  Map<dynamic, dynamic> _users = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      DatabaseEvent event = await _userRef.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.exists) {
        setState(() {
          _users = snapshot.value as Map<dynamic, dynamic>;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching users: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: const Text(
        'User List',
        style: TextStyle(color: Colors.white), // White text color
      ),
      backgroundColor: AppColors.primaryColor,
      iconTheme: const IconThemeData(color: Colors.white), // White back button
    ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final key = _users.keys.elementAt(index);
                    final user = _users[key];
                    return Card(
                      margin:  EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: ListTile(
                        title: Text(
                          user['name'] ?? 'No Name',
                          style:  TextStyle(
                            fontWeight: FontWeight.bold,
                            color:  AppColors.primaryColor,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Department: ${user['Dept'] ?? 'No Dept'}'),
                            Text('Email: ${user['emailId'] ?? 'No email'}'),
                            Text('User ID: ${user['id'] ?? 'No id'}'),
                            
                          ],
                        ),
                        trailing: IconButton(
                          icon:  Icon(Icons.delete,
                              color:  AppColors.primaryColor),
                          onPressed: () => _deleteUser(key),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _userRef.child(userId).remove();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully')),
      );
      _fetchUserData(); // Refresh the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting user: ${e.toString()}')),
      );
    }
  }
}