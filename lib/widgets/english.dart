import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../main.dart';

class English extends StatelessWidget {
  const English({super.key});

  Future<String> loadMarkdown() {
    return rootBundle.loadString('assets/english.md');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadMarkdown(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        return Markdown(
          data: snapshot.data ?? '',
          styleSheet: MarkdownStyleSheet(
            tableHeadAlign: TextAlign.start,
            tableBorder: TableBorder.all(
              color: AppColors.text,
            ),
            tableBody: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w600,
              fontSize: 12,
              height: 1,
            ),
            h1: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
            h2: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
            strong: TextStyle(
              color: AppColors.strong,
              fontWeight: FontWeight.w900,
              fontSize: 12,
              height: 1,
            ),
          ),
        );
      },
    );
  }
}
