import 'package:flutter/material.dart';

class NewsFeedScreen extends StatelessWidget {
  const NewsFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SatyaPress - Layer 1: News Feed'),
      ),
      body: const Center(
        child: Text('News Feed & AI Summaries (Placeholder)'),
      ),
    );
  }
}
