import 'package:flutter/material.dart';

class WelcomeText extends StatelessWidget {
  const WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
