import 'package:battery_music/core/services/music_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:battery_music/core/services/node_api_service.dart';
import 'package:battery_music/models/response/daily_recommend.dart';

class DailyRecommendationProvider extends ChangeNotifier {
  DailyRecommend? _dailyRecommendation;
  bool _isLoading = false;
  String? _error;

  DailyRecommend? get dailyRecommendation => _dailyRecommendation;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDailyRecommendation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final apiService = MusicApiService();
      final response = await apiService.everydayRecommend();

      if (response.status == 1) {
        _dailyRecommendation = response.data;
      } else {
        _error = '获取每日推荐失败';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DailyRecommendSongItem> get songs {
    return _dailyRecommendation?.songList
            ?.where(
              (song) =>
                  song.songname != null &&
                  song.authorName != null &&
                  song.sizableCover != null,
            )
            .toList() ??
        [];
  }
}
