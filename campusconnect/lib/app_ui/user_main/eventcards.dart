import 'package:campus/app_ui/user_main/BookingHistoryScreen.dart';
import 'package:campus/app_ui/user_main/checkdetails.dart';
import 'package:campus/app_ui/user_main/profilescreen.dart';
import 'package:campus/app_ui/user_main/requestform.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../styles/app_colors.dart';



class EventcardsScreen extends StatefulWidget {
  const EventcardsScreen({super.key});

  @override
  State<EventcardsScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<EventcardsScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EventListScreen(),
    const BookingHistoryScreen(),
    const Eventrequestform(),
    const Profilecard(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CampusConnect'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
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
            icon: Icon(Icons.history),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Request',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
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



class EventListScreen extends StatefulWidget {
  const EventListScreen({super.key});

  @override
  State<EventListScreen> createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
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
    if(value['flag']!=null && value['flag']==1) {
      _events.add({
        ...value,
        'key': key // Add the key to the event data
      });
    }
  }
});

        setState(() {
         // _events = loadedEvents.where((event) => event['flag'] == 1).toList();
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
      appBar: AppBar(
        title: const Text('Upcoming Events'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _events.isEmpty
              ? const Center(child: Text('No upcoming events'))
              : ListView.builder(
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

class EventCard extends StatelessWidget {
  final String title;
  final String organizer;
  final String dateTime;
  final String imageUrl;
    final String eventId; 
  final String? price;

  const EventCard({
    super.key,
    required this.title,
    required this.organizer,
    required this.dateTime,
    required this.imageUrl,
        required this.eventId,
    this.price = 'FREE',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: const Icon(Icons.event, size: 40),
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            
            // Event Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color:AppColors.primaryColor,
                  )),
                  const SizedBox(height: 4),
                  Text(
                    'By $organizer',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dateTime,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  
                ],
              ),
            ),
            
            // Details Button
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventDetailScreen(eventId: eventId),
                  ),
                );
              },
              icon: const Icon(Icons.arrow_forward_ios, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}





