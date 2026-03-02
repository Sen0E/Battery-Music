class MusicItem {
  final String hash;
  final String songName;
  final String singerName;
  final String coverImage;

  MusicItem({
    required this.hash,
    required this.songName,
    required this.singerName,
    required this.coverImage,
  });

  @override
  String toString() => 'MusicItem(songName: $songName, singer: $singerName)';
}
