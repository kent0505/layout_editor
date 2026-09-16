import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

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

  bool _showOnlyHighlighted = false;
  bool _showTranslationFirst = false;

  Future<List<Word>> loadWords() async {
    final markdown = await rootBundle.loadString(widget.path);
    final words = parseMarkdown(markdown);
    _learnedIds = await _storage.loadLearned();
    for (final word in words) {
      word.learned = _learnedIds.contains(word.id);
    }
    final learned = words.where((word) => word.learned).toList()..shuffle();
    final notLearned = words.where((word) => !word.learned).toList()..shuffle();

    _words = [
      ...learned,
      ...notLearned,
    ];
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
  void initState() {
    super.initState();
    _storage = WordsStorage(key: widget.path);
    _wordsFuture = loadWords();
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

            final words = _words ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: words.length,
              itemBuilder: (context, index) {
                final word = words[index];

                return _WordTile(
                  word: word,
                  showOnlyHighlighted: _showOnlyHighlighted,
                  showTranslationFirst: _showTranslationFirst,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_learnedIds.length} / ${_words?.length ?? 0}',
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 12,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showOnlyHighlighted = !_showOnlyHighlighted;
                  });
                },
                icon: Icon(
                  _showOnlyHighlighted
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _showTranslationFirst = !_showTranslationFirst;
                  });
                },
                icon: Icon(
                  _showTranslationFirst ? Icons.translate : Icons.g_translate,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WordTile extends StatefulWidget {
  const _WordTile({
    required this.word,
    required this.showOnlyHighlighted,
    required this.showTranslationFirst,
    required this.onChanged,
  });

  final Word word;
  final bool showOnlyHighlighted;
  final bool showTranslationFirst;
  final void Function(bool?) onChanged;

  @override
  State<_WordTile> createState() => __WordTileState();
}

class __WordTileState extends State<_WordTile> {
  Word get word => widget.word;

  String get displayedExample {
    if (!widget.showOnlyHighlighted) return word.example;
    final match = RegExp(r'\*\*(.*?)\*\*').firstMatch(word.example);
    return match?.group(1) ?? word.example;
  }

  bool isVisible = false;

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
        Expanded(
          child: GestureDetector(
            onTap: () async {
              if (!isVisible) {
                setState(() {
                  isVisible = true;
                });
                await Future.delayed(Duration(seconds: 1), () {
                  if (mounted) {
                    setState(() {
                      isVisible = false;
                    });
                  }
                });
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.showTranslationFirst)
                  Text(
                    word.translation,
                    style: TextStyle(
                      color: word.learned ? AppColors.text2 : AppColors.text,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
                if (!widget.showTranslationFirst)
                  SizedBox(
                    height: 14,
                    child: MarkdownBody(
                      data: displayedExample,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color:
                              word.learned ? AppColors.text2 : AppColors.text,
                          fontSize: 14,
                          height: 1,
                        ),
                      ),
                    ),
                  ),
                if (widget.showTranslationFirst) const SizedBox(height: 4),
                if (widget.showTranslationFirst)
                  SizedBox(
                    height: 14,
                    child: MarkdownBody(
                      data: displayedExample,
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          color: isVisible
                              ? word.learned
                                  ? AppColors.text2
                                  : AppColors.text
                              : Colors.transparent,
                          fontSize: 14,
                          height: 1,
                        ),
                      ),
                    ),
                  )
                else
                  Text(
                    word.translation,
                    style: TextStyle(
                      color: isVisible
                          ? word.learned
                              ? AppColors.text2
                              : AppColors.text
                          : Colors.transparent,
                      fontSize: 12,
                      height: 1,
                    ),
                  ),
              ],
            ),
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

  static late SharedPreferences prefs;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  Future<Set<int>> loadLearned() async {
    final values = prefs.getStringList(key) ?? [];
    return values.map(int.parse).toSet();
  }

  Future<void> saveLearned(Set<int> learned) async {
    await prefs.setStringList(
      key,
      learned.map((id) => id.toString()).toList(),
    );
  }
}
