import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/note.dart';
import '../providers/note_provider.dart';

class NoteFormPage extends StatefulWidget {
  final Note? note;
  const NoteFormPage({super.key, this.note});

  @override
  State<NoteFormPage> createState() => _NoteFormPageState();
}

class _NoteFormPageState extends State<NoteFormPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final _audioRecorder = AudioRecorder();

  MediaType _mediaType = MediaType.none;
  String? _mediaPath;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.textContent;
      _mediaPath = widget.note!.mediaPath;
      _mediaType = widget.note!.mediaType;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  Future<String> _saveFileLocally(String path, String ext) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = '${const Uuid().v4()}$ext';
    final savedFile = File(path).copySync(p.join(directory.path, fileName));
    return savedFile.path;
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final savedPath =
          await _saveFileLocally(image.path, p.extension(image.path));
      setState(() {
        _mediaPath = savedPath;
        _mediaType = MediaType.image;
      });
    }
  }

  Future<void> _pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    if (video != null) {
      final savedPath =
          await _saveFileLocally(video.path, p.extension(video.path));
      setState(() {
        _mediaPath = savedPath;
        _mediaType = MediaType.video;
      });
    }
  }

  Future<void> _toggleRecording() async {
    if (await Permission.microphone.request().isGranted) {
      if (_isRecording) {
        final path = await _audioRecorder.stop();
        setState(() {
          _isRecording = false;
        });

        if (path != null) {
          final savedPath = await _saveFileLocally(path, '.m4a');
          setState(() {
            _mediaPath = savedPath;
            _mediaType = MediaType.audio;
          });
        }
      } else {
        final directory = await getTemporaryDirectory();
        final path = p.join(directory.path, '${const Uuid().v4()}.m4a');
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _mediaType = MediaType.none; // reset while recording
          _mediaPath = null;
        });
      }
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
    }
  }

  void _saveNote() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title is required')),
      );
      return;
    }

    final note = Note(
      id: widget.note?.id ?? const Uuid().v4(),
      title: _titleController.text,
      textContent: _contentController.text,
      mediaPath: _mediaPath,
      mediaType: _mediaType,
      createdAt: widget.note?.createdAt ?? DateTime.now(),
    );

    if (widget.note != null) {
      context.read<NoteProvider>().updateNoteAndRefresh(note);
    } else {
      context.read<NoteProvider>().addNoteAndRefresh(note);
    }

    Navigator.pop(context);
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 24.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: Theme.of(context)
                .colorScheme
                .surfaceContainerHighest
                .withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('New Entry',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.check,
                color: Theme.of(context).colorScheme.primary, size: 28),
            onPressed: _saveNote,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INTELLECTUAL SANCTUARY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.note == null ? 'Capture Thought' : 'Refine Thought',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            _buildSectionLabel('NOTE TITLE'),
            _buildInputContainer(
              child: TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  hintText: 'e.g., Quantum Mechanics Context',
                  hintStyle: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.3),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            _buildSectionLabel('NOTE DETAILS'),
            Container(
              height: 250,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  TextField(
                    controller: _contentController,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText:
                          'Start transcribing your lecture notes or research findings here...',
                      hintStyle: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.3),
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'AUTOSAVED',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildSectionLabel('ATTACHMENTS'),
            if (_mediaPath != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _mediaType == MediaType.image
                          ? Icons.image
                          : _mediaType == MediaType.video
                              ? Icons.videocam
                              : Icons.mic,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        p.basename(_mediaPath!),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () {
                        setState(() {
                          _mediaPath = null;
                          _mediaType = MediaType.none;
                        });
                      },
                    )
                  ],
                ),
              ),
            Row(
              children: [
                _buildAttachmentButton(
                  icon: _isRecording ? Icons.stop_circle : Icons.description,
                  label: _isRecording ? 'STOP' : 'AUDIO',
                  color: _isRecording ? Colors.redAccent : Colors.blue.shade300,
                  onTap: _toggleRecording,
                ),
                const SizedBox(width: 12),
                _buildAttachmentButton(
                  icon: Icons.image,
                  label: 'PHOTO',
                  color: Colors.purpleAccent.shade100,
                  onTap: _pickImage,
                ),
                const SizedBox(width: 12),
                _buildAttachmentButton(
                  icon: Icons.videocam,
                  label: 'VIDEO',
                  color: Colors.orangeAccent.shade200,
                  onTap: _pickVideo,
                ),
              ],
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
