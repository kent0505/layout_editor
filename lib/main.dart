import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'widgets/english.dart';
import 'widgets/layout_editor.dart';
import 'widgets/logictics.dart';
import 'widgets/words_list.dart';

void logger(Object message) {
  developer.log(message.toString());
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xff333333),
          brightness: Brightness.dark,
          surface: Color(0xff333333),
        ),
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Color(0xff444444)),
          checkColor: WidgetStateProperty.all(Colors.white),
          side: BorderSide(color: Color(0xff555555)),
        ),
      ),
      home: const TestScreen(),
    ),
  );
}

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  int _currentIndex = 1;

  final List<Widget> _screens = const [
    LayoutEditor(),
    WordsList(
      key: ValueKey('words'),
      path: 'assets/words.md',
    ),
    WordsList(
      key: ValueKey('phrasal_verbs'),
      path: 'assets/phrasal_verbs.md',
    ),
    English(),
    Logictics(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        height: 90,
        labelPadding: EdgeInsets.only(
          bottom: 24,
          top: 8,
        ),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.layers_outlined),
            selectedIcon: Icon(Icons.layers),
            label: 'Editor',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Words',
          ),
          NavigationDestination(
            icon: Icon(Icons.list_outlined),
            selectedIcon: Icon(Icons.list),
            label: 'Phrasal verbs',
          ),
          NavigationDestination(
            icon: Icon(Icons.table_rows_outlined),
            selectedIcon: Icon(Icons.table_rows),
            label: 'English',
          ),
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Logistics',
          ),
        ],
      ),
    );
  }
}

class SvgWidget extends StatelessWidget {
  const SvgWidget(
    this.assetName, {
    super.key,
    this.height,
    this.width,
    required this.color,
  });

  final String assetName;
  final double? height;
  final double? width;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetName,
      height: height,
      width: width,
      colorFilter: color == null
          ? null
          : ColorFilter.mode(
              color!,
              BlendMode.srcIn,
            ),
      placeholderBuilder: (context) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return SizedBox(
          height: height,
          width: width,
        );
      },
    );
  }
}
