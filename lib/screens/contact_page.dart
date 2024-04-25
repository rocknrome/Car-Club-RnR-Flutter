import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  // Helper method to launch URLs
  void _launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Me"),
      ),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Roman Larionov",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Text(
                  "Final Project for General Assembly",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                Text(
                  "Full-Stack Engineer Class",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                Text(
                  "Technologies used",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Backend One:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(label: Text('Python'), avatar: Icon(Icons.code)),
                        Chip(label: Text('Django'), avatar: Icon(Icons.web)),
                        Chip(
                            label: Text('Neon'),
                            avatar: Icon(Icons.lightbulb_outline)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Backend Two:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                            label: Text('Express'),
                            avatar: Icon(Icons.computer)),
                        Chip(
                            label: Text('MongoDB'),
                            avatar: Icon(Icons.storage)),
                        Chip(
                            label: Text('Mongoose'),
                            avatar: Icon(Icons.data_usage)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Text('Frontend:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(
                            label: Text('Flutter'),
                            avatar: Icon(Icons.phone_android)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  "My Profile",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset('assets/git-logo.png'),
                        iconSize: 40,
                        onPressed: () =>
                            _launchURL('https://github.com/rocknrome'),
                        tooltip: 'GitHub',
                      ),
                    ),
                    SizedBox(width: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: Offset(0, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        icon: Image.asset('assets/li-logo.png'),
                        iconSize: 40,
                        onPressed: () => _launchURL(
                            'https://www.linkedin.com/in/romanlarionov/'),
                        tooltip: 'LinkedIn',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
