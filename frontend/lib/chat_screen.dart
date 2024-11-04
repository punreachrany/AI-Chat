import 'package:flutter/material.dart';
import 'api_service.dart'; // Import the API service

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> messages = []; // List to store messages
  final TextEditingController _controller =
      TextEditingController(); // Controller for the input field
  final ApiService apiService = ApiService(
      baseUrl: 'http://127.0.0.1:8000'); // Change the base URL if needed

  bool isLoading = false; // Variable to track loading state

  void _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      // Step 1: Show the user's message on the screen
      String userMessage = _controller.text;
      setState(() {
        messages.add(Message(
            text: userMessage,
            isUser: true)); // Add user message to the messages list
        isLoading = true; // Set loading state to true
      });

      // Step 2: Clear the input field immediately after adding the message
      _controller.clear();

      // Step 3: Call the API to get the response
      try {
        String? responseMessage = await apiService.sendMessage(userMessage);
        if (responseMessage != null) {
          // If the response is not null, add it to the messages list
          setState(() {
            messages.add(Message(
                text: responseMessage,
                isUser: false)); // Add bot response to the messages list
          });
        }
      } catch (e) {
        // Handle any errors that occur during the API call
        setState(() {
          messages.add(Message(
              text: 'Error: ${e.toString()}',
              isUser: false)); // Add error message to the messages list
        });
      } finally {
        // Reset the loading state after the API call is complete
        setState(() {
          isLoading = false; // Set loading state to false
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return _buildMessage(messages[index]); // Build message bubbles
              },
            ),
          ),
          if (isLoading) // Show loading indicator if loading
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          _buildInputField(), // Input field at the bottom
        ],
      ),
    );
  }

  // Method to build message bubbles
  Widget _buildMessage(Message message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          message.text,
          style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  // Method to build input field
  Widget _buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type a message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage, // Call send message when button is pressed
          ),
        ],
      ),
    );
  }
}

// Class to represent a message
class Message {
  final String text; // Message text
  final bool isUser; // Flag to indicate if the message is from the user

  Message({required this.text, required this.isUser});
}
