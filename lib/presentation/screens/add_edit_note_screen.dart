import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/note.dart';
import '../../features/notes/note_providers.dart';

class AddEditNoteScreen extends ConsumerStatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  ConsumerState<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends ConsumerState<AddEditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _selectedColor;

  final List<Color> _colors = [
    Colors.blue,
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.amber,
    Colors.pink,
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _selectedColor = isNoteColorValid(widget.note?.color) 
        ? widget.note!.color 
        : _colors[0];
  }

  bool isNoteColorValid(Color? color) {
    if (color == null) return false;
    return _colors.any((c) => c.value == color.value);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    // If both empty, don't create a new empty note
    if (title.isEmpty && content.isEmpty && widget.note == null) {
      return;
    }
    
    // If it's an existing note and becomes empty, maybe delete it or keep it empty? 
    // Let's keep it as is or delete if desired. For now, saving empty updates is fine.

    final note = Note(
      id: widget.note?.id,
      title: title.isEmpty ? 'Untitled' : title,
      content: content,
      colorValue: _selectedColor.value,
      dateCreated: widget.note?.dateCreated ?? DateTime.now(),
      dateModified: DateTime.now(),
    );

    if (widget.note == null) {
      ref.read(noteListProvider.notifier).addNote(note);
    } else {
      ref.read(noteListProvider.notifier).updateNote(note);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Force a light pastel background color to ensure readability and "sticky note" feel
    // regardless of the system theme (Light/Dark).
    final backgroundColor = Color.alphaBlend(
      _selectedColor.withOpacity(0.2),
      Colors.white,
    );

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        if (didPop) {
          _saveNote();
        }
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          title: Text(
            widget.note == null ? 'New Note' : 'Edit Note',
            style: const TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check, color: Colors.black),
              onPressed: () {
                // Popping triggers onPopInvoked which calls _saveNote
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _colors.length,
                itemBuilder: (context, index) {
                  final color = _colors[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor.value == color.value
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: _selectedColor.value == color.value
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.black12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextField(
                    controller: _titleController,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Force black text
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87, // Force dark text
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Type something...',
                      hintStyle: TextStyle(color: Colors.black38),
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
