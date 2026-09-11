import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
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

  List<Word>? _words;

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
    _words = words..shuffle();
    return words;
  }

  void shuffleWords() {
    if (_words == null) return;
    setState(() {
      _words!.shuffle();
    });
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
      final example = cells[0].trim();
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
    return Stack(
      children: [
        FutureBuilder<List<Word>>(
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

            final words = _words ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];

                return _WordTile(
                  word: word,
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
                );
              },
            );
          },
        ),
        Positioned(
          right: 20,
          bottom: 20,
          child: IconButton(
            onPressed: shuffleWords,
            icon: Icon(Icons.shuffle),
          ),
        ),
      ],
    );
  }
}

class _WordTile extends StatefulWidget {
  const _WordTile({
    required this.word,
    required this.onChanged,
  });

  final Word word;
  final void Function(bool?) onChanged;

  @override
  State<_WordTile> createState() => __WordTileState();
}

class __WordTileState extends State<_WordTile> {
  Word get word => widget.word;

  bool isVisible = false;

  void onTap() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: word.learned,
          onChanged: (value) {
            widget.onChanged.call(value);
          },
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 14,
                child: MarkdownBody(
                  data: word.example,
                  styleSheet: MarkdownStyleSheet(
                    p: TextStyle(
                      color: Colors.white.withValues(
                        alpha: word.learned ? 0.2 : 0.6,
                      ),
                      fontSize: 14,
                      height: 1,
                    ),
                  ),
                ),
              ),
              Text(
                word.translation,
                style: TextStyle(
                  color: isVisible
                      ? Colors.white.withValues(
                          alpha: word.learned ? 0.2 : 0.4,
                        )
                      : Colors.transparent,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ],
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
  WordsStorage({required this.key});

  final String key;

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
