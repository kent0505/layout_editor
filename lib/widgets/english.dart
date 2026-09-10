import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

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
            tableBody: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 12,
              height: 1,
            ),
            h1: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
            ),
            h2: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
