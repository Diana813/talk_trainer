import 'dart:io';

import 'package:flutter/material.dart';
import 'package:talk_trainer/screens/android_search_result_screen.dart';

import '../widgets/search_field.dart';

class AndroidWelcomeScreen extends StatefulWidget {
  const AndroidWelcomeScreen({super.key});

  @override
  _AndroidWelcomeScreenState createState() => _AndroidWelcomeScreenState();
}

class _AndroidWelcomeScreenState extends State<AndroidWelcomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _visible = true;
  late FocusNode _focusNode;
  bool _isSubmitted = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      if (_focusNode.hasFocus || _isSubmitted) {
        _visible = false;
      } else {
        sleep(const Duration(milliseconds: 100));
        _visible = true;
      }
    });
  }

  void _handlePop() {
    setState(() {
      _isSubmitted = false;
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (value) {
        _handlePop();
      },
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_visible)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Text(
                        'Witaj w talk trainer!',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Rozwijaj swoje umiejętności językowe, ucząc się z ulubionych filmów na YouTube.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Wybierz podcast, wykład lub inne nagranie, które najbardziej Cię interesuje i po prostu powtarzaj po lektorze.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ),
            SearchField(
              searchController: _searchController,
              onSubmitted: () {
                _isSubmitted = true;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AndroidSearchResultsScreen(
                          keywords: _searchController.text)),
                ).then((_) {
                  _handlePop();
                });
              },
              focusNode: _focusNode,
            ),
          ],
        ),
      ),
    );
  }
}
