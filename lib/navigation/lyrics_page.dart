import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class LyricsPage extends StatefulWidget {
  final String songTitle;
  final String lyrics;
  final String music;

  const LyricsPage({
    Key? key,
    required this.songTitle,
    required this.lyrics,
    required this.music,
  }) : super(key: key);

  @override
  State<LyricsPage> createState() => _LyricsPageState();
}

class _LyricsPageState extends State<LyricsPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _toggleSwitch = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _setupAudio();
  }

  Future<void> _setupAudio() async {
    // Convert title → filename: "Bohemian Rhapsody" → "bohemian_rhapsody.mp3"
    final String fileName = widget.songTitle
        .toLowerCase()
        .replaceAll(' ', '_')
        .replaceAll("'", "") // remove apostrophes
        .replaceAll('&', 'and') // optional: handle special chars
        + '.mp3';

    try {
      await _audioPlayer.setAsset('assets/audio/$fileName');
    } catch (e) {
      print("Error loading local audio '$fileName': $e");
      // Optional: show a snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Audio not found: $fileName')),
        );
      }
      return;
    }

    // Sync play state with UI
    _audioPlayer.playerStateStream.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state.playing;
          _toggleSwitch = state.playing;
        });
      }
    });
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  void _onSwitchChanged(bool value) {
    setState(() {
      _toggleSwitch = value;
    });
    _togglePlayPause();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.songTitle),
        backgroundColor: Colors.purple[700],
        actions: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
            onPressed: _togglePlayPause,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Song Title
              Text(
                'Song: ${widget.songTitle}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              // Artist
              Text(
                'Artist: ${widget.music}',
                style: const TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16),

              // Play Controls
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _togglePlayPause,
                    icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(_isPlaying ? "Pause" : "Play"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[600],
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Music:',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Switch(
                    value: _toggleSwitch,
                    onChanged: _onSwitchChanged,
                    activeColor: Colors.purple[300],
                  ),
                ],
              ),

              const SizedBox(height: 16),
              const Divider(color: Colors.white),
              const SizedBox(height: 16),

              // Scrollable Lyrics
              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    widget.lyrics,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}