import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../../styles/app_colors.dart';

class ApprovalScreen extends StatefulWidget {
  const ApprovalScreen({super.key});

  @override
  State<ApprovalScreen> createState() => _ApprovalScreenState();
}

class _ApprovalScreenState extends State<ApprovalScreen> {
  final DatabaseReference _eventRef = FirebaseDatabase.instance.ref("Event");
  final Map<String, dynamic> _events = {};
  bool _isLoading = true;
  final DatabaseReference _eventsRef = FirebaseDatabase.instance.ref('Event');
  List<Map<dynamic, dynamic>> eventData = [];
  List<String> keyValue = [];

  @override
  void initState() {
    super.initState();
    _fetchEventsw();
    _setupRealtimeListener();
  }

  Future<void> _fetchEventsw() async {
    try {
      final snapshot = await _eventsRef.once();
      if (snapshot.snapshot.exists) {
        final data = snapshot.snapshot.value as Map<dynamic, dynamic>? ?? {};
        eventData.clear();
        keyValue.clear();
        data.forEach((key, value) {
          if (value is Map && value['flag'] != null && value['flag'] == 0) {
            eventData.add(value);
            keyValue.add(key.toString());
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

  void _setupRealtimeListener() {
    _eventRef.onValue.listen((event) {
      if (!mounted || !event.snapshot.exists) return;
      _processEventData(event.snapshot.value);
    });
  }

  void _processEventData(dynamic data) {
    final Map<String, dynamic> convertedEvents = {};
    
    if (data is Map) {
      data.forEach((key, value) {
        if (key is String) {
          convertedEvents[key] = value is Map ? Map<String, dynamic>.from(value) : value;
        }
      });
    }

    if (mounted) {
      setState(() {
        _events.clear();
        _events.addAll(convertedEvents);
        // Update our local lists with the latest data
        eventData.clear();
        keyValue.clear();
        _events.forEach((key, value) {
          if (value['flag'] == 0) {
            eventData.add(value);
            keyValue.add(key);
          }
        });
      });
    }
  }

  Future<void> _handleApproval(String eventKey, bool approved) async {
    try {
      // Update flag to 1 for approved, 2 for rejected
      await _eventRef.child(eventKey).update({'flag': approved ? 1 : 2});
      
      if (mounted) {
        _showSnackBar(
          'Request ${approved ? 'approved' : 'rejected'}',
          approved ? Colors.green : AppColors.primaryColor,
        );
        // Remove the processed item from our lists
        setState(() {
          final index = keyValue.indexOf(eventKey);
          if (index != -1) {
            eventData.removeAt(index);
            keyValue.removeAt(index);
          }
        });
      }
    } catch (e) {
      _handleError('Approval error: $e');
    }
  }

  void _handleError(String message) {
    debugPrint(message);
    if (mounted) {
      setState(() => _isLoading = false);
      _showSnackBar(message.contains('Error') ? message.split(':').last.trim() : 'Operation failed', Colors.red);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : eventData.isEmpty
              ? const Center(child: Text('No pending requests'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: eventData.length,
                  itemBuilder: (context, index) {
                    final event = eventData[index];
                    return _buildRequestCard(event, keyValue[index]);
                  },
                ),
    );
  }

  Widget _buildRequestCard(Map<dynamic, dynamic> event, String id) {
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
            const Divider(height: 24),
            _buildActionButtons(id),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(String id) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryColor,
            side: BorderSide(color: AppColors.primaryColor),
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => _handleApproval(id, false),
          child: const Text('Reject'),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24),
          ),
          onPressed: () => _handleApproval(id, true),
          child: const Text('Approve'),
        ),
      ],
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