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
      body: Center(
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
                "Final Project for General Assembly Full-Stack Engineer Class",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              Text(
                "Technologies used",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: [
                  Chip(
                    avatar: Icon(Icons.code),
                    label: Text('Python'),
                  ),
                  Chip(
                    avatar: Icon(Icons.web),
                    label: Text('Django'),
                  ),
                  Chip(
                    avatar: Icon(Icons.storage),
                    label: Text('MongoDB'),
                  ),
                  Chip(
                    avatar: Icon(Icons.data_usage),
                    label: Text('Mongoose'),
                  ),
                  Chip(
                    avatar: Icon(Icons.computer),
                    label: Text('Express'),
                  ),
                  Chip(
                    avatar: Icon(Icons.phone_android),
                    label: Text('Flutter'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset('assets/git-logo.png'),
                    iconSize: 40,
                    onPressed: () => _launchURL('https://github.com/rocknrome'),
                    tooltip: 'GitHub',
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Image.asset('assets/li-logo.png'),
                    iconSize: 40,
                    onPressed: () => _launchURL(
                        'https://www.linkedin.com/in/romanlarionov/'),
                    tooltip: 'LinkedIn',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
