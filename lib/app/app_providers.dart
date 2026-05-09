import 'package:battery_music/presentation/providers/audio_player_provider.dart';
import 'package:battery_music/presentation/providers/daily_recommendation_provider.dart';
import 'package:battery_music/presentation/providers/home_page_provider.dart';
import 'package:battery_music/presentation/providers/player_ui_provider.dart';
import 'package:battery_music/presentation/providers/playlist_detail_provider.dart';
import 'package:battery_music/presentation/providers/playlist_provider.dart';
import 'package:battery_music/presentation/providers/search_provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:provider/provider.dart';

List<SingleChildWidget> buildAppProviders() {
  return [
    ChangeNotifierProvider(create: (_) => SidebarProvider()),
    ChangeNotifierProvider(create: (_) => SearchProvider()),
    ChangeNotifierProvider(create: (_) => PlaylistProvider()),
    ChangeNotifierProvider(create: (_) => PlaylistDetailProvider()),
    ChangeNotifierProvider(create: (_) => AudioPlayerProvider()),
    ChangeNotifierProvider(create: (_) => HomePageProvider()),
    ChangeNotifierProvider(create: (_) => DailyRecommendationProvider()),
  ];
}
