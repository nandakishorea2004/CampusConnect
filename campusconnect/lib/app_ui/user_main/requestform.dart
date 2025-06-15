import 'package:campus/app_ui/user_main/eventcards.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';



class Eventrequestform extends StatefulWidget {
  const Eventrequestform({super.key});

  @override
   State<Eventrequestform> createState() => _EventrequestformState();
}

class _EventrequestformState extends State<Eventrequestform> {
  TextEditingController eventname=TextEditingController();
  TextEditingController description=TextEditingController();
  TextEditingController department=TextEditingController();
  TextEditingController venue=TextEditingController();
TextEditingController coordinator=TextEditingController();
TextEditingController contact=TextEditingController();
TextEditingController flag=TextEditingController();

final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

insertNewEvent()async{

  final newEventRef = _dbRef.child('Event').push();
  //  final fileName = 'events/${DateTime.now().millisecondsSinceEpoch}.jpg';
  // final storageRef = FirebaseStorage.instance.ref().child(fileName);
  // final uploadTask = await storageRef.putFile(_selectedImage!);
  // final imageUrl = await storageRef.getDownloadURL();
  await newEventRef.set({
     'Event Name': eventname.text,
        'Description': description.text,
        'Department' : department.text,
        'Venue': venue.text,
        'Coordinator Name': coordinator.text,
        'Contact Details' : contact.text,
        'flag':0,
        'createdAt':DateFormat("dd-MMM-yyyy").format(DateTime.now()),
        'createdUser':"",
        "eventDate":DateFormat("dd-MMM-yyyy").format(_selectedDate),
        "eventTime":formatTimeOfDay(_selectedTime),
        "imageUrl": "https://i.pinimg.com/originals/c9/50/ad/c950ada78e80c73e05fd30c8fd61506f.jpg"
  });


}
String formatTimeOfDay(TimeOfDay time) {
  final now = DateTime.now();
  final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
  final format = DateFormat.jm(); // 'jm' gives hh:mm a (e.g., 5:08 PM)
  return format.format(dt);
}
final _formKey = GlobalKey<FormState>();
  String? selectedModel; // This will hold the selected value
  List<String> models = [
    'Open Assembly',
    'Exclusive Circle ',
  ];



  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  File? _selectedImage;

 
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _submitForm() {
    
      // Here you would typically send the data to your backend
      // For now, we'll just show a success dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Request Successful'),
            content: const Text('Your event has Successfully Requested Please wait for Confirmation.'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => EventcardsScreen()),
                 (Route<dynamic> route) => false, );
                },
                
              ),
            ],
          );
        },
      );

      // Clear the form
      //_formKey.currentState!.reset();
      //setState(() {
      //  _selectedImage = null;
      // _selectedDate = DateTime.now();
      //  _selectedTime = TimeOfDay.now();
      //});
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Booking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Event Poster Image
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: _selectedImage != null
                      ? Image.file(_selectedImage!, fit: BoxFit.cover)
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo, size: 50),
                            SizedBox(height: 8),
                            Text('Tap to add event poster'),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),

              // Event Name
              TextFormField(
                controller: eventname,
                decoration: const InputDecoration(
                  labelText: 'Event Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the event name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Date and Time
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Date',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(DateFormat('MMM dd, yyyy').format(_selectedDate)),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectTime(context),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Time',
                          border: OutlineInputBorder(),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(_selectedTime.format(context)),
                            const Icon(Icons.access_time),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: department,
                decoration: const InputDecoration(
                  labelText: 'Department',
                  border: OutlineInputBorder(),
                ),
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a Department';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Venue
              TextFormField(
                controller: venue,
                decoration: const InputDecoration(
                  labelText: 'Venue',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the venue';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Coordinator Name
              TextFormField(
                controller: coordinator,
                decoration: const InputDecoration(
                  labelText: 'Coordinator Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter coordinator name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Contact Details
              TextFormField(
                controller: contact,
                decoration: const InputDecoration(
                  labelText: 'Contact Details',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact details';
                  }
                  return null;
                },
              ),
              
          
              const SizedBox(height: 16),
              DropdownButtonFormField(
              decoration: InputDecoration(
                labelText: 'Event Type',
                hintText: 'Choose your Event type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                filled: true,
                fillColor: Colors.grey[50],
              ), 
              
              value: selectedModel,
              isExpanded: true,
              items: models.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(
                      color: value == models[0] ? const Color.fromARGB(255, 0, 0, 0) : Colors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != models[0]) { // Prevent selecting the hint
                  setState(() {
                    selectedModel = newValue;
                  });
                }
              },
              validator: (value) {
                if (value == null || value == models[0]) {
                  return 'Please select a valid model';
                }
                return null;
              },
            ),

              // Submit Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    insertNewEvent();
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  ),
                  child: const Text('Request', style: TextStyle(fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}