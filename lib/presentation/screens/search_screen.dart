import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String query = '';
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text('Explore')));
}
