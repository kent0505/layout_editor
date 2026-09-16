import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

import '../main.dart';

class Logictics extends StatelessWidget {
  const Logictics({super.key});

  Future<String> loadMarkdown() {
    return rootBundle.loadString('assets/logistics.md');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadMarkdown(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
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
            h3: TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w700,
            ),
            p: TextStyle(
              color: AppColors.text,
            ),
            listBullet: TextStyle(
              color: AppColors.text,
            ),
          ),
        );
      },
    );
  }
}
