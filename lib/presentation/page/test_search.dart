import 'dart:developer';

import 'package:battery_music/core/services/node_service_api.dart';
import 'package:battery_music/models/base_response.dart';
import 'package:battery_music/models/search_song_response.dart';
import 'package:battery_music/models/search_special_response.dart';
import 'package:battery_music/models/search_suggest_response.dart';
import 'package:flutter/material.dart';

/// 搜索测试页面
/// 用于开发阶段测试搜索 API 功能（单曲、歌单搜索及搜索建议）
class TestSearch extends StatefulWidget {
  const TestSearch({super.key});

  @override
  State<TestSearch> createState() => _TestSearchState();
}

class _TestSearchState extends State<TestSearch> {
  String? _selectType = 'song';
  String _keyword = '';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //输入框
        TextField(
          decoration: InputDecoration(
            hintText: '请输入搜索内容',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) async {
            setState(() {
              _keyword = value;
            });
            if (_keyword.isEmpty) return;
            List<SearchSugges> response = await NodeServiceApi.instance
                .searchSuggest(_keyword);
            for (var item in response) {
              log(item.hintInfo!);
            }
          },
        ),
        //选择框 音乐/歌单
        DropdownButton<String>(
          items: [
            DropdownMenuItem(value: 'song', child: Text('音乐')),
            DropdownMenuItem(value: 'special', child: Text('歌单')),
          ],
          onChanged: (value) {
            setState(() {
              _selectType = value;
            });
            log(_selectType!);
          },
          value: _selectType,
        ),
        //搜索按钮
        ElevatedButton(
          onPressed: () async {
            log(_keyword);
            log(_selectType!);
            if (_selectType == 'song') {
              ApiResponse<SearchSongResponse> response = await NodeServiceApi
                  .instance
                  .searchKeywords<SearchSongResponse>(
                    _keyword,
                    1,
                    fromJson: SearchSongResponse.fromJson,
                  );
              // 遍历列表
              for (var item in response.data!.lists!) {
                log(
                  item.songName! +
                      '--' +
                      item.singerName! +
                      '--' +
                      item.albumName! +
                      '--' +
                      item.fileName!,
                );
              }
            }
            if (_selectType == 'special') {
              ApiResponse<SearchSpecialResponse> response = await NodeServiceApi
                  .instance
                  .searchKeywords<SearchSpecialResponse>(
                    _keyword,
                    1,
                    type: _selectType!,
                    fromJson: SearchSpecialResponse.fromJson,
                  );
              for (var item in response.data!.lists!) {
                log(
                  item.specialName! +
                      '--' +
                      item.nickname! +
                      '--' +
                      item.intro! +
                      '--' +
                      item.img!,
                );
              }
            }
          },
          child: Text('搜索'),
        ),
      ],
    );
  }
}
