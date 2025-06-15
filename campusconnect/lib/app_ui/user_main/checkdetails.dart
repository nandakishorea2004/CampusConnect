import 'package:campus/app_ui/user_main/eventcards.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../styles/app_colors.dart';

class EventDetailScreen extends StatefulWidget {
  final String eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late DatabaseReference _eventRef;
  Map<String, dynamic> _eventData = {};
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _eventRef = FirebaseDatabase.instance.ref('Event').child(widget.eventId);
    _fetchEventData();
  }

  Future<void> _fetchEventData() async {
    try {
      final snapshot = await _eventRef.get();
      if (snapshot.exists) {
        setState(() {
          _eventData = Map<String, dynamic>.from(snapshot.value as Map);
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Event not found';
        });
        _showErrorAndPop();
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error loading event: ${e.toString()}';
      });
      _showErrorAndPop();
    }
  }

  void _showErrorAndPop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_errorMessage)),
      );
      Navigator.pop(context);
    });
  }

  DateTime? _parseEventDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;

    try {
      // Try ISO format first (e.g., "2025-06-10")
      if (dateString.contains('-') && dateString.split('-')[0].length == 4) {
        return DateTime.parse(dateString);
      }
      
      // Try custom format (e.g., "10-Jun-2025")
      if (dateString.contains('-') && dateString.split('-').length == 3) {
        return DateFormat('dd-MMM-yyyy').parse(dateString);
      }

      // Try timestamp (if stored as milliseconds)
      final timestamp = int.tryParse(dateString);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } catch (e) {
      debugPrint('Date parsing error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final eventDate = _parseEventDate(_eventData['eventDate']?.toString());
    final dateFormat = DateFormat('d MMMM yyyy');
    final timeFormat = DateFormat('h:mm a');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                _eventData['imageUrl'] ?? '',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[300],
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _eventData['Event Name'] ?? 'No Title',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        eventDate != null 
                          ? '${dateFormat.format(eventDate)} • ${timeFormat.format(eventDate)}'
                          : 'Date not specified',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        _eventData['Venue'] ?? 'Venue not specified',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[700],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'About Event',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text(
                    _eventData['Description'] ?? 'No description available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Event Coordinator',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(_eventData['Coordinator Name'] ?? 'No coordinator specified'),
                    subtitle: Text(_eventData['Contact Details'] ?? 'No contact information'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booked successfully!')),
              );
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const EventcardsScreen()),
                (Route<dynamic> route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text(
              'Book',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}