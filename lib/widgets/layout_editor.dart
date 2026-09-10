import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../main.dart';

class LayoutEditor extends StatefulWidget {
  const LayoutEditor({super.key});

  @override
  State<LayoutEditor> createState() => _LayoutEditorState();
}

class _LayoutEditorState extends State<LayoutEditor> {
  static const int columns = 7;
  static const int rows = 8;
  static const double boardTop = 130;
  List<_Layout> layouts = [];
  final List<List<_Layout>> _history = [];
  final _random = Random();
  final Map<String, String> _tileAssets = {};
  bool get canUndo => _history.isNotEmpty;
  bool get canCopy => layouts.isNotEmpty && layouts.length.isEven;

  void exportLevel() async {
    final buffer = StringBuffer();
    buffer.writeln('import \'../models/layout.dart\';');
    buffer.writeln('const level1 = [');
    for (final layout in layouts) {
      buffer.writeln(
        '  Layout(x: ${layout.x}, y: ${layout.y}, z: ${layout.z}),',
      );
    }
    buffer.writeln('];');

    final levelString = buffer.toString();
    await Clipboard.setData(ClipboardData(text: levelString));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Copied to clipboard!')),
      );
    }

    logger(levelString);
  }

  void clearBoard() {
    setState(() {
      layouts.clear();
      _tileAssets.clear();
      _history.clear();
    });
  }

  void _saveHistory() {
    _history.add(
      layouts
          .map((layout) => _Layout(x: layout.x, y: layout.y, z: layout.z))
          .toList(),
    );
  }

  void undo() {
    if (_history.isEmpty) return;
    setState(() {
      layouts = _history.removeLast();
      final validKeys = layouts.map(_layoutKey).toSet();
      _tileAssets.removeWhere((key, _) => !validKeys.contains(key));
    });
  }

  String _layoutKey(_Layout layout) {
    return '${layout.x}:${layout.y}:${layout.z}';
  }

  bool _containsLayout({required int x, required int y, required int z}) {
    return layouts.any(
      (layout) => layout.x == x && layout.y == y && layout.z == z,
    );
  }

  void _sortLayouts() {
    layouts.sort((a, b) {
      if (a.z != b.z) return a.z.compareTo(b.z);
      if (a.y != b.y) return a.y.compareTo(b.y);
      return a.x.compareTo(b.x);
    });
  }

  void onAdd(_Layout layout) {
    if (_containsLayout(x: layout.x, y: layout.y, z: layout.z)) {
      return;
    }
    _saveHistory();
    final key = _layoutKey(layout);
    setState(() {
      layouts.add(layout);
      _tileAssets[key] =
          Assets.tileAssets[_random.nextInt(Assets.tileAssets.length)];
      _sortLayouts();
    });
  }

  void onRemove(_Layout layout) {
    final index = layouts.indexWhere(
      (item) => item.x == layout.x && item.y == layout.y && item.z == layout.z,
    );
    if (index == -1) return;
    _saveHistory();
    setState(() {
      layouts.removeAt(index);
      _tileAssets.remove(_layoutKey(layout));
      _sortLayouts();
    });
  }

  void onMove(_Layout oldLayout, _Layout newLayout) {
    final index = layouts.indexWhere(
      (item) =>
          item.x == oldLayout.x &&
          item.y == oldLayout.y &&
          item.z == oldLayout.z,
    );
    if (index == -1) return;
    if (_containsLayout(x: newLayout.x, y: newLayout.y, z: newLayout.z)) {
      return;
    }
    _saveHistory();
    final oldKey = _layoutKey(oldLayout);
    final newKey = _layoutKey(newLayout);
    setState(() {
      layouts[index] = newLayout;
      final asset = _tileAssets.remove(oldKey);
      if (asset != null) _tileAssets[newKey] = asset;
      _sortLayouts();
    });
  }

  void _handleSwipe(_Tile tile, DragEndDetails details) {
    final velocity = details.velocity.pixelsPerSecond;
    if (velocity.distance < 100) return;
    final dx = velocity.dx.abs();
    final dy = velocity.dy.abs();
    if (dx > dy) {
      final direction = velocity.dx > 0 ? 1 : -1;
      onMove(
        _Layout(x: tile.x, y: tile.y, z: tile.z),
        _Layout(x: tile.x + direction, y: tile.y, z: tile.z),
      );
    } else {
      final direction = velocity.dy > 0 ? 1 : -1;
      onMove(
        _Layout(x: tile.x, y: tile.y, z: tile.z),
        _Layout(x: tile.x, y: tile.y + direction, z: tile.z),
      );
    }
  }

  List<_Tile> get tiles {
    return layouts.map((layout) {
      final key = _layoutKey(layout);
      final asset = _tileAssets[key] ??
          Assets.tileAssets[_random.nextInt(Assets.tileAssets.length)];
      _tileAssets[key] = asset;

      return _Tile(id: asset, x: layout.x, y: layout.y, z: layout.z);
    }).toList();
  }

  double _tileLeft(BuildContext context, _Tile tile) {
    return (MediaQuery.of(context).size.width - tile.width * columns) / 2 +
        tile.x * tile.width / 2 -
        tile.z * 4;
  }

  double _tileTop(_Tile tile) {
    return boardTop + tile.y * tile.height / 2 - tile.z * 4;
  }

  double _cellLeft(BuildContext context, int x) {
    const cellWidth = 50.0;
    return (MediaQuery.of(context).size.width - cellWidth * columns) / 2 +
        x * cellWidth / 2;
  }

  double _cellTop(int y) {
    const cellHeight = 70.0;
    return boardTop + y * cellHeight / 2;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ...List.generate(columns * rows, (index) {
          final x = (index % columns) * 2;
          final y = (index ~/ columns) * 2;

          return Positioned(
            left: _cellLeft(context, x),
            top: _cellTop(y),
            child: GestureDetector(
              onTap: () {
                onAdd(_Layout(x: x, y: y, z: 0));
              },
              child: Container(
                width: 50,
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                ),
                child: Center(
                  child: Text(
                    '$x:$y',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
        ...tiles.map((tile) {
          return Positioned(
            left: _tileLeft(context, tile),
            top: _tileTop(tile),
            child: GestureDetector(
              onTap: () {
                onAdd(_Layout(x: tile.x, y: tile.y, z: tile.z + 1));
              },
              onLongPress: () {
                onRemove(_Layout(x: tile.x, y: tile.y, z: tile.z));
              },
              onPanEnd: (details) {
                _handleSwipe(tile, details);
              },
              child: _TileWidget(tile: tile),
            ),
          );
        }),
        Positioned(
          right: 20,
          top: 50,
          child: SafeArea(
            child: Row(
              children: [
                Text(
                  'Tiles: ${tiles.length}',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
                IconButton(
                  onPressed: canUndo ? undo : null,
                  icon: const Icon(Icons.undo),
                ),
                IconButton(
                  onPressed: canCopy ? exportLevel : null,
                  icon: const Icon(Icons.copy),
                ),
                IconButton(
                  onPressed: clearBoard,
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TileWidget extends StatelessWidget {
  const _TileWidget({required this.tile});

  final _Tile tile;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      height: tile.height,
      width: tile.width,
      decoration: BoxDecoration(
        color: const Color(0xffeaf9dd),
        borderRadius: BorderRadius.circular(6),
        border: const Border(
          left: BorderSide(width: 0.5, color: Color(0xFF2c412e)),
          top: BorderSide(width: 0.5, color: Color(0xFF2c412e)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 4,
            offset: const Offset(5, 5),
          ),
          const BoxShadow(color: Color(0xffa1c683), offset: Offset(1, 2)),
          const BoxShadow(color: Color(0xffa1c683), offset: Offset(2, 3)),
          const BoxShadow(color: Color(0xffa1c683), offset: Offset(3, 4)),
        ],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SvgWidget(tile.id, color: null),
        ),
      ),
    );
  }
}

class _Tile {
  _Tile({
    this.id = '',
    this.x = 0,
    this.y = 0,
    this.z = 0,
  });

  String id;
  final int x;
  final int y;
  final int z;

  double get height => 70;
  double get width => 50;
}

final class _Layout {
  const _Layout({
    required this.x,
    required this.y,
    required this.z,
  });

  final int x;
  final int y;
  final int z;
}

abstract final class Assets {
  static List<String> animals =
      List.generate(48, (i) => 'assets/icons/animals/${i + 1}.svg');
  static List<String> eats =
      List.generate(35, (i) => 'assets/icons/eats/${i + 1}.svg');
  static List<String> flowers =
      List.generate(11, (i) => 'assets/icons/flowers/${i + 1}.svg');
  static List<String> others =
      List.generate(12, (i) => 'assets/icons/others/${i + 1}.svg');
  static final List<String> tileAssets = [
    ...animals,
    ...eats,
    ...flowers,
    ...others,
  ];
}
