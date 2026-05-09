import 'package:battery_music/presentation/components/song_list_item.dart';
import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/daily_recommendation_provider.dart';
import 'package:battery_music/presentation/widgets/loading/skeleton_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyRecommendationsPage extends StatefulWidget {
  const DailyRecommendationsPage({super.key});

  @override
  State<DailyRecommendationsPage> createState() =>
      _DailyRecommendationsPageState();
}

class _DailyRecommendationsPageState extends State<DailyRecommendationsPage> {
  @override
  void initState() {
    super.initState();
    // 初始化时获取每日推荐数据
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DailyRecommendationProvider>().fetchDailyRecommendation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DailyRecommendationProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDailyRecommendation(),
        child: provider.isLoading
            ? const _DailyRecommendationsSkeleton()
            : provider.error != null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(provider.error!, style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => provider.fetchDailyRecommendation(),
                      child: const Text('重新加载'),
                    ),
                  ],
                ),
              )
            : _buildContent(provider),
      ),
    );
  }

  Widget _buildContent(DailyRecommendationProvider provider) {
    final songs = provider.songs;

    if (songs.isEmpty) {
      return const Center(child: Text('暂无推荐歌曲'));
    }

    return ListView.builder(
      itemCount: songs.length,
      itemBuilder: (context, index) {
        final song = songs[index];

        final filenameParts = (song.filename ?? '').split(' - ');
        final fallbackSinger = filenameParts.length > 1
            ? filenameParts.first
            : '未知歌手';
        final fallbackSong = filenameParts.length > 1
            ? filenameParts.last
            : (song.filename ?? '未知歌曲');

        return SongListItem(
          index: index,
          songName: song.songname ?? fallbackSong,
          singerName: song.authorName ?? fallbackSinger,
          coverUrl: song.getSizableCoverUrl(size: 120),
          duration: song.timeLength,
          musicpackAdvance: song.payType != 1 ? 1 : 0,
          onTap: () {
            // 播放歌曲的逻辑可以在这里实现
            // debugPrint('点击播放歌曲: ${song.songname}');
            context.read<AudioPlayerProvider>().playSong(
              song,
              playlist: provider.songs,
              index: index,
            );
          },
        );
      },
    );
  }
}

class _DailyRecommendationsSkeleton extends StatelessWidget {
  const _DailyRecommendationsSkeleton();

  @override
  Widget build(BuildContext context) {
    return SkeletonPulse(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: 12,
        separatorBuilder: (context, index) => const SizedBox(height: 4),
        itemBuilder: (context, index) => const SkeletonSongRow(),
      ),
    );
  }
}
