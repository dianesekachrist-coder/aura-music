import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_session/audio_session.dart';

enum SongRepeatMode { none, one, all }

class MusicProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  List<SongModel> _songs = [];
  List<SongModel> _filteredSongs = [];
  SongModel? _currentSong;
  int _currentIndex = 0;
  bool _isPlaying = false;
  bool _isLoading = false;
  bool _hasPermission = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  SongRepeatMode _repeatMode = SongRepeatMode.none;
  bool _isShuffled = false;
  int _currentNavIndex = 0;
  String _searchQuery = '';

  // Getters
  List<SongModel> get songs => _filteredSongs;
  List<SongModel> get allSongs => _songs;
  SongModel? get currentSong => _currentSong;
  int get currentIndex => _currentIndex;
  bool get isPlaying => _isPlaying;
  bool get isLoading => _isLoading;
  bool get hasPermission => _hasPermission;
  Duration get position => _position;
  Duration get duration => _duration;
  SongRepeatMode get repeatMode => _repeatMode;
  bool get isShuffled => _isShuffled;
  int get currentNavIndex => _currentNavIndex;
  AudioPlayer get player => _player;

  double get progress {
    if (_duration.inMilliseconds == 0) return 0;
    return _position.inMilliseconds / _duration.inMilliseconds;
  }

  MusicProvider() {
    _initAudioSession();
    _setupListeners();
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  void _setupListeners() {
    _player.positionStream.listen((pos) {
      _position = pos;
      notifyListeners();
    });

    _player.durationStream.listen((dur) {
      _duration = dur ?? Duration.zero;
      notifyListeners();
    });

    _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _onSongComplete();
      }
      notifyListeners();
    });
  }

  void _onSongComplete() {
    switch (_repeatMode) {
      case SongRepeatMode.one:
        _player.seek(Duration.zero);
        _player.play();
        break;
      case SongRepeatMode.all:
        playNext();
        break;
      case SongRepeatMode.none:
        if (_currentIndex < _filteredSongs.length - 1) {
          playNext();
        }
        break;
    }
  }

  Future<bool> requestPermission() async {
    final status = await Permission.audio.request();
    if (!status.isGranted) {
      final storageStatus = await Permission.storage.request();
      _hasPermission = storageStatus.isGranted;
    } else {
      _hasPermission = true;
    }
    notifyListeners();
    return _hasPermission;
  }

  Future<void> loadSongs() async {
    _isLoading = true;
    notifyListeners();

    try {
      _songs = await _audioQuery.querySongs(
        sortType: SongSortType.TITLE,
        orderType: OrderType.ASC_OR_SMALLER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true,
      );
      _filteredSongs = List.from(_songs);
    } catch (e) {
      debugPrint('Error loading songs: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> playSong(SongModel song, int index) async {
    _currentSong = song;
    _currentIndex = index;
    notifyListeners();

    try {
      await _player.setAudioSource(
        AudioSource.uri(Uri.parse(song.uri!)),
      );
      await _player.play();
    } catch (e) {
      debugPrint('Error playing song: $e');
    }
  }

  Future<void> togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  Future<void> playNext() async {
    if (_filteredSongs.isEmpty) return;
    int nextIndex = (_currentIndex + 1) % _filteredSongs.length;
    await playSong(_filteredSongs[nextIndex], nextIndex);
  }

  Future<void> playPrevious() async {
    if (_filteredSongs.isEmpty) return;
    if (_position.inSeconds > 3) {
      await _player.seek(Duration.zero);
      return;
    }
    int prevIndex =
        _currentIndex > 0 ? _currentIndex - 1 : _filteredSongs.length - 1;
    await playSong(_filteredSongs[prevIndex], prevIndex);
  }

  Future<void> seekTo(double value) async {
    final position =
        Duration(milliseconds: (value * _duration.inMilliseconds).round());
    await _player.seek(position);
  }

  void toggleRepeat() {
    switch (_repeatMode) {
      case SongRepeatMode.none:
        _repeatMode = SongRepeatMode.all;
        break;
      case SongRepeatMode.all:
        _repeatMode = SongRepeatMode.one;
        break;
      case SongRepeatMode.one:
        _repeatMode = SongRepeatMode.none;
        break;
    }
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    if (_isShuffled) {
      _filteredSongs.shuffle();
    } else {
      _filteredSongs = List.from(_songs);
      _applySearch();
    }
    notifyListeners();
  }

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _filteredSongs = List.from(_songs);
    } else {
      _filteredSongs = _songs.where((song) {
        return song.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            (song.artist ?? '')
                .toLowerCase()
                .contains(_searchQuery.toLowerCase());
      }).toList();
    }
  }

  String formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
