import 'package:flutter/material.dart';
import 'widgets/body_summary_page.dart';

void main() {
  runApp(const MaterialApp(
    title: 'categoriesSummary',
    home: Summary(),
    debugShowCheckedModeBanner: false,
  ));
}

class Summary extends StatelessWidget {
  const Summary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: ItensSummaryPage(),
      ),
    );
  }
}
