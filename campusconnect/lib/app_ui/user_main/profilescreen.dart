import 'package:campus/app_ui/user_new/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profilecard extends StatefulWidget {
  const Profilecard({super.key});

  @override
  State<Profilecard> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profilecard> {
  final DatabaseReference _userRef = FirebaseDatabase.instance.ref("User");
  dynamic _user = {};
  bool _isLoading = true;
 

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }


  

  final Map<String, dynamic> userData = {
    'avatarUrl': 'assets/images/user_image.jpeg', // Removed leading slash
  };

   Future<void> _fetchUserData() async {
  setState(() {
    _isLoading = true;
  });

  try {
    final prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString("userEmail") ?? "";
    
    if (userId.isEmpty) {
      throw Exception("User ID not found in SharedPreferences");
    }

   
     final DatabaseReference _userRef2 = FirebaseDatabase.instance.ref().child('User');
       // Query the database for the email
      final query = await _userRef2.orderByChild('emailId').equalTo(userId).once();
       if (query.snapshot.value != null) {

        final userData = (query.snapshot.value as Map<dynamic, dynamic>).values.first;
        _user=userData;
  
 //_passwordController.text=userData['name'];
// _isLoading=false;
// setState(() {
// });
       }
       _isLoading=false;
setState(() {
  
});


    print("Successfully fetched user data for ID: $userId");
    print("User data: $_user");

  } catch (e) {
    print("Error fetching user data: $e");
    
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching user data: ${e.toString()}'),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}

updateUser()async{



}


   bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _changePassword() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // In a real app, you would call your API here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password changed successfully')),
                );
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear shared preferences if needed
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("userId");
              
              // Close the dialog first
              Navigator.pop(context);
              
              // Show logout success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logged out successfully')),
              );
              
              // Navigate to login screen and remove all routes
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.done : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(userData['avatarUrl']), // Changed to AssetImage
                  ),
                  if (_isEditing)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, color: Colors.white),
                          onPressed: () {
                            // Implement image picker functionality
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // User Information
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildProfileField(
                      label: 'Name',
                      value: _user['name'] ?? 'No name',
                      isEditable: _isEditing,
                    ),
                    const Divider(),
                    _buildProfileField(
                      label: 'Department',
                      value: _user['Dept'] ?? 'No Dept',
                      isEditable: _isEditing,
                    ),
                    const Divider(),
                    _buildProfileField(
                      label: 'ID',
                      value: _user['id'] ?? 'No id',
                      isEditable: _isEditing,
                    ),
                    const Divider(),
                    _buildProfileField(
                      label: 'Mobile Number',
                      value: _user['mobileNumber'] ?? 'No mobileNumber',
                      isEditable: _isEditing,
                      keyboardType: TextInputType.phone,
                    ),
                    const Divider(),
                    _buildProfileField(
                      label: 'Email',
                      value: _user['emailId'] ?? 'No emailid',
                      isEditable: _isEditing,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Action Buttons
            Column(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.lock),
                  label: const Text('Change Password'),
                  onPressed: _changePassword,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  onPressed: _logout,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileField({
    required String label,
    required String value,
    bool isEditable = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: isEditable
                ? TextFormField(
                    initialValue: value,
                    keyboardType: keyboardType,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (newValue) {
                      // Update the corresponding field in _users
                      setState(() {
                        // You would need to map the label to the correct key in _users
                        // This is a simplified version - you might need to adjust
                        if (label == 'Name') _user['name'] = newValue;
                        else if (label == 'Department') _user['Dept'] = newValue;
                        else if (label == 'ID') _user['id'] = newValue;
                        else if (label == 'Mobile Number') _user['mobileNumber'] = newValue;
                        else if (label == 'Email') _user['emailId'] = newValue;
                      });
                    },
                  )
                : Text(
                    value,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}