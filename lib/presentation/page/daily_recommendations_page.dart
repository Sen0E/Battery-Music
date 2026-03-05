import 'package:battery_music/presentation/components/song_list_item.dart';
import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/daily_recommendation_provider.dart';
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
    Future.microtask(
      () => Provider.of<DailyRecommendationProvider>(
        context,
        listen: false,
      ).fetchDailyRecommendation(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DailyRecommendationProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => provider.fetchDailyRecommendation(),
        child: provider.isLoading
            ? const Center(child: CircularProgressIndicator())
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

        return SongListItem(
          index: index,
          songName: song.songname!,
          singerName: song.authorName!,
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
