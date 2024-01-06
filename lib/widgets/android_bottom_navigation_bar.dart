import 'package:flutter/material.dart';

class AndroidBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int>? onTap;
  final int selectedIndex;

  const AndroidBottomNavigationBar(
      {super.key, required this.onTap, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).shadowColor,
      unselectedItemColor: Theme.of(context).shadowColor,
      backgroundColor: Theme.of(context).primaryColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            color: Colors.red[500],
          ),
          label: 'Start',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_arrow, color: Colors.red[500]),
          label: 'Trenuj',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.replay, color: Colors.red[500]),
          label: 'Powtórka',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (index) {
        onTap?.call(index);
      },
    );
  }
}
