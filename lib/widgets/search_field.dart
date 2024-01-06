import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    required TextEditingController searchController,
    required VoidCallback onSubmitted,
    required FocusNode focusNode,
  })  : _searchController = searchController,
        _onSubmitted = onSubmitted,
        _focusNode = focusNode;

  final TextEditingController _searchController;
  final VoidCallback _onSubmitted;
  final FocusNode _focusNode;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  late bool _isSearchEmpty;
  @override
  void initState() {
    super.initState();
    _isSearchEmpty = widget._searchController.text.isEmpty;
    widget._searchController.addListener(_onSearchTextChanged);
  }

  void _onSearchTextChanged() {
    setState(() {
      _isSearchEmpty = widget._searchController.text.isEmpty;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColors.primaryHighlight[600],
      ),
      padding: const EdgeInsets.all(8),
      child: TextField(
        cursorColor: Theme.of(context).shadowColor,
        controller: widget._searchController,
        decoration: InputDecoration(
          focusColor: Theme.of(context).shadowColor,
          fillColor: Theme.of(context).primaryColorDark,
          hoverColor: Theme.of(context).primaryColor,
          labelText: 'Wyszukaj nagranie na YouTube',
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          suffixIcon: GestureDetector(
            onTap: () {
              if (!_isSearchEmpty) {
                widget._searchController.clear();
              }
            },
            child: Icon(
              _isSearchEmpty ? Icons.youtube_searched_for_rounded : Icons.close,
              color: Colors.red[700],
            ),
          ),
        ),
        onSubmitted: (value) {
          widget._onSubmitted();
        },
        focusNode: widget._focusNode,
      ),
    );
  }
}
