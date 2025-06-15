import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref('Event');
  List<Map<dynamic, dynamic>> _allEvents = [];
  List<String> _eventKeys = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllEvents();
    _setupRealtimeListener();
  }

  Future<void> _fetchAllEvents() async {
    try {
      final snapshot = await _eventsRef.once();
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
        _processEventData(data);
      }
      setState(() => _isLoading = false);
    } catch (e) {
      _handleError('Error loading events: ${e.toString()}');
    }
  }

  void _setupRealtimeListener() {
    _eventsRef.onValue.listen((event) {
      if (!mounted || !event.snapshot.exists) return;
      _processEventData(event.snapshot.value as Map<dynamic, dynamic>);
    });
  }

  void _processEventData(Map<dynamic, dynamic>? data) {
    if (data == null) return;

    final List<Map<dynamic, dynamic>> loadedEvents = [];
    final List<String> loadedKeys = [];

    data.forEach((key, value) {
      if (value is Map) {
        loadedEvents.add(value);
        loadedKeys.add(key.toString());
      }
    });

    if (mounted) {
      setState(() {
        _allEvents = loadedEvents;
        _eventKeys = loadedKeys;
      });
    }
  }

  String _getStatusText(int flag) {
    switch (flag) {
      case 0:
        return 'Pending';
      case 1:
        return 'Approved';
      case 2:
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int flag) {
    switch (flag) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.green;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _handleError(String message) {
    debugPrint(message);
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.contains('Error') 
              ? message.split(':').last.trim() 
              : 'Operation failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Track'),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _allEvents.isEmpty
              ? const Center(child: Text('No booking requests found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _allEvents.length,
                  itemBuilder: (context, index) {
                    final event = _allEvents[index];
                    final flag = event['flag'] as int? ?? 0;
                    return _buildEventCard(event, flag);
                  },
                ),
    );
  }

  Widget _buildEventCard(Map<dynamic, dynamic> event, int flag) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(flag).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _getStatusColor(flag)),
                ),
                child: Text(
                  _getStatusText(flag),
                  style: TextStyle(
                    color: _getStatusColor(flag),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Event details
            _buildDetailRow('Event:', event['Event Name']),
            const SizedBox(height: 8),
            _buildDetailRow('Description:', event['Description']),
            const SizedBox(height: 8),
            _buildDetailRow('Venue:', event['Venue']),
            const SizedBox(height: 8),
            _buildDetailRow('Department:', event['Department']),
            const SizedBox(height: 8),
            _buildDetailRow('Requested by:', event['Coordinator Name']),
            const SizedBox(height: 8),
            _buildDetailRow('Contact No:', event['Contact Details']),
            const SizedBox(height: 8),
            _buildDetailRow('Date:', event['eventDate']),
            const SizedBox(height: 8),
            _buildDetailRow('Time:', event['eventTime']),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
        children: [
          TextSpan(
            text: '$label ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          TextSpan(text: value ?? 'N/A'),
        ],
      ),
    );
  }
} 