import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordsList extends StatefulWidget {
  const WordsList({super.key, required this.path});

  final String path;

  @override
  State<WordsList> createState() => _WordsListState();
}

class _WordsListState extends State<WordsList> {
  late Future<List<Word>> _wordsFuture;
  late WordsStorage _storage;

  Set<int> _learnedIds = {};

  @override
  void initState() {
    super.initState();
    _storage = WordsStorage(key: widget.path);
    _wordsFuture = loadWords();
  }

  Future<List<Word>> loadWords() async {
    final markdown = await rootBundle.loadString(widget.path);
    final words = parseMarkdown(markdown);
    _learnedIds = await _storage.loadLearned();
    for (final word in words) {
      word.learned = _learnedIds.contains(word.id);
    }
    return words;
  }

  List<Word> parseMarkdown(String markdown) {
    final lines = markdown.split('\n');
    final words = <Word>[];
    for (final line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) continue;
      if (RegExp(r'^\|[\s\-:|]+\|$').hasMatch(trimmed)) continue;
      if (!trimmed.startsWith('|') || !trimmed.endsWith('|')) continue;
      final content = trimmed.substring(1, trimmed.length - 1);
      final cells = content.split('|').map((e) => e.trim()).toList();
      if (cells.length < 2) continue;
      final example = cells[0].replaceAll('**', '').replaceAll('*', '').trim();
      final translation = cells[1].trim();
      if (example.toLowerCase() == 'example') continue;
      words.add(
        Word(
          id: words.length,
          example: example,
          translation: translation,
        ),
      );
    }
    return words;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Word>>(
      future: _wordsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(
                color: Colors.red,
              ),
            ),
          );
        }

        final words = snapshot.data ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];

            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: word.learned,
                    onChanged: (value) async {
                      setState(() {
                        word.learned = value ?? false;
                        if (word.learned) {
                          _learnedIds.add(word.id);
                        } else {
                          _learnedIds.remove(word.id);
                        }
                      });
                      await _storage.saveLearned(_learnedIds);
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          word.example,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: word.learned ? 0.2 : 0.6,
                            ),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        Text(
                          word.translation,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: word.learned ? 0.2 : 0.4,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class Word {
  final int id;
  final String example;
  final String translation;

  bool learned;

  Word({
    required this.id,
    required this.example,
    required this.translation,
    this.learned = false,
  });

  @override
  String toString() {
    return 'Word('
        'example: $example, '
        'translation: $translation'
        ')';
  }
}

class WordsStorage {
  final String key;

  WordsStorage({required this.key});

  Future<Set<int>> loadLearned() async {
    final prefs = await SharedPreferences.getInstance();
    final values = prefs.getStringList(key) ?? [];
    return values.map(int.parse).toSet();
  }

  Future<void> saveLearned(Set<int> learned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      key,
      learned.map((id) => id.toString()).toList(),
    );
  }
}
