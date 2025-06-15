import 'package:campus/app_ui/admin/ApprovalScreen.dart';
import 'package:campus/app_ui/admin/UserListScreen.dart';
import 'package:campus/app_ui/admin/addevent.dart';
import 'package:campus/app_ui/user_main/eventcards.dart';
import 'package:campus/app_ui/user_new/login.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
 // Make sure to import your login screen

import '../../styles/app_colors.dart';

class AdmincardPage extends StatefulWidget {
  const AdmincardPage({super.key});

  @override
  State<AdmincardPage> createState() => _AdmincardPageState();
}

class _AdmincardPageState extends State<AdmincardPage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EventAdminPage(),
    const AddEventPage(),
    const ApprovalScreen(),
    const UserListScreen(),
  ];

  Future<void> _logout() async {
  final shouldLogout = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (shouldLogout ?? false) {
    // Add any logout logic here (like clearing user session)
    
    // Show confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        duration: Duration(seconds: 2),
      ),
    );

    // Navigate to login screen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Event',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pending Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Userlist',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class EventAdminPage extends StatefulWidget {
  const EventAdminPage({super.key});

  @override
  State<EventAdminPage> createState() => _EventAdminPageState();
}

class _EventAdminPageState extends State<EventAdminPage> {
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref('Event');
  List<Map<dynamic, dynamic>> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      final snapshot = await _eventsRef.once();
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
        final List<Map<String, dynamic>> loadedEvents = [];
        
        data.forEach((key, value) {
          if (value is Map) {
            if(value['flag']!=null&&value['flag']==1){
              _events.add(value);
            }
            loadedEvents.add({
              'key': key.toString(),
              'title': value['Event Name']?.toString() ?? 'No Title',
              'organizer': value['Department']?.toString() ?? 'Unknown Organizer',
            });
          }
        });

        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading events: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
  padding: const EdgeInsets.all(16),
  itemCount: _events.length,
  itemBuilder: (context, index) {
    final event = _events[index];
    return Column(
      children: [
        EventCard(
          title: event['Event Name']??"",
          organizer: event['Coordinator Name']??"",
          dateTime: event['eventDate']??"",
          imageUrl: event['imageUrl']??"",
          eventId: event['key'] ?? '', // Make sure you have the event key/id
        ),
        if (index < _events.length - 1)
          const SizedBox(height: 16),
      ],
    );
  },
),
    );
  }
}