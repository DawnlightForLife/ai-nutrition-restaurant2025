import 'package:dio/dio.dart';
import '../models/search_result_model.dart';
import '../models/search_suggestion_model.dart';
import '../../domain/entities/search_query.dart';

/// 搜索远程数据源接口
abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> search(SearchQuery query);
  Future<List<SearchSuggestionModel>> getSuggestions(String keyword);
  Future<List<String>> getHotKeywords();
  Future<List<String>> getSearchTrends();
  Future<void> reportSearchBehavior({
    required String keyword,
    String? resultType,
    int? resultCount,
    int? clickPosition,
    String? clickedItemId,
  });
  Future<List<String>> getCategorySuggestions();
  Future<List<String>> getTagSuggestions();
}

/// 搜索远程数据源实现
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;
  
  const SearchRemoteDataSourceImpl(this._dio);
  
  @override
  Future<List<SearchResultModel>> search(SearchQuery query) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search', queryParameters: {
        'keyword': query.keyword,
        'types': query.types?.map((t) => t.toString().split('.').last).toList(),
        'category': query.category,
        'tags': query.tags,
        'sortBy': query.sortType.toString().split('.').last,
        'page': query.page,
        'pageSize': query.pageSize,
        'filters': query.filters,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> resultsJson = data['data'] as List<dynamic>;
          return resultsJson
              .map((json) => SearchResultModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      
      return _getDefaultSearchResults(query.keyword);
    } catch (e) {
      return _getDefaultSearchResults(query.keyword);
    }
  }
  
  @override
  Future<List<SearchSuggestionModel>> getSuggestions(String keyword) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search/suggestions', queryParameters: {
        'keyword': keyword,
      });
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> suggestionsJson = data['data'] as List<dynamic>;
          return suggestionsJson
              .map((json) => SearchSuggestionModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
      
      return _getDefaultSuggestions(keyword);
    } catch (e) {
      return _getDefaultSuggestions(keyword);
    }
  }
  
  @override
  Future<List<String>> getHotKeywords() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search/hot-keywords');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> keywordsJson = data['data'] as List<dynamic>;
          return keywordsJson.map((keyword) => keyword.toString()).toList();
        }
      }
      
      return _getDefaultHotKeywords();
    } catch (e) {
      return _getDefaultHotKeywords();
    }
  }
  
  @override
  Future<List<String>> getSearchTrends() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search/trends');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> trendsJson = data['data'] as List<dynamic>;
          return trendsJson.map((trend) => trend.toString()).toList();
        }
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }
  
  @override
  Future<void> reportSearchBehavior({
    required String keyword,
    String? resultType,
    int? resultCount,
    int? clickPosition,
    String? clickedItemId,
  }) async {
    try {
      await _dio.post<Map<String, dynamic>>('/analytics/search-behavior', data: {
        'keyword': keyword,
        'resultType': resultType,
        'resultCount': resultCount,
        'clickPosition': clickPosition,
        'clickedItemId': clickedItemId,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // 忽略埋点错误，不影响用户体验
    }
  }
  
  @override
  Future<List<String>> getCategorySuggestions() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search/categories');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> categoriesJson = data['data'] as List<dynamic>;
          return categoriesJson.map((category) => category.toString()).toList();
        }
      }
      
      return _getDefaultCategories();
    } catch (e) {
      return _getDefaultCategories();
    }
  }
  
  @override
  Future<List<String>> getTagSuggestions() async {
    try {
      final response = await _dio.get<Map<String, dynamic>>('/search/tags');
      
      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['success'] == true && data['data'] != null) {
          final List<dynamic> tagsJson = data['data'] as List<dynamic>;
          return tagsJson.map((tag) => tag.toString()).toList();
        }
      }
      
      return _getDefaultTags();
    } catch (e) {
      return _getDefaultTags();
    }
  }
  
  /// 获取默认搜索结果
  List<SearchResultModel> _getDefaultSearchResults(String keyword) {
    return [
      SearchResultModel(
        id: 'dish_demo_1',
        title: '宫保鸡丁',
        subtitle: '经典川菜',
        description: '嫩滑鸡丁搭配花生米，香辣下饭',
        imageUrl: 'assets/images/dish_gongbao_chicken.png',
        type: 'dish',
        category: '川菜',
        tags: ['辣', '下饭', '经典'],
        relevanceScore: 0.95,
      ),
      SearchResultModel(
        id: 'merchant_demo_1',
        title: '川香小厨',
        subtitle: '正宗川菜馆',
        description: '专业川菜制作，地道口味',
        imageUrl: 'assets/images/merchant_sichuan_kitchen.png',
        type: 'merchant',
        category: '餐厅',
        tags: ['川菜', '正宗', '好评'],
        relevanceScore: 0.85,
      ),
    ];
  }
  
  /// 获取默认搜索建议
  List<SearchSuggestionModel> _getDefaultSuggestions(String keyword) {
    if (keyword.isEmpty) return [];
    
    return [
      SearchSuggestionModel(
        text: '${keyword}炒饭',
        type: 'autoComplete',
      ),
      SearchSuggestionModel(
        text: '${keyword}面条',
        type: 'autoComplete',
      ),
      SearchSuggestionModel(
        text: '${keyword}汤',
        type: 'autoComplete',
      ),
    ];
  }
  
  /// 获取默认热门关键词
  List<String> _getDefaultHotKeywords() {
    return [
      '减脂餐',
      '营养套餐',
      '健康轻食',
      '高蛋白',
      '低卡路里',
      '素食',
      '无糖',
      '有机',
    ];
  }
  
  /// 获取默认分类
  List<String> _getDefaultCategories() {
    return [
      '川菜',
      '粤菜',
      '湘菜',
      '鲁菜',
      '苏菜',
      '浙菜',
      '闽菜',
      '徽菜',
      '西餐',
      '日料',
      '韩料',
      '快餐',
      '小食',
      '甜品',
      '饮品',
    ];
  }
  
  /// 获取默认标签
  List<String> _getDefaultTags() {
    return [
      '健康',
      '营养',
      '减脂',
      '高蛋白',
      '低脂',
      '无糖',
      '有机',
      '素食',
      '辣',
      '酸',
      '甜',
      '咸',
      '清淡',
      '重口味',
      '下饭',
      '开胃',
    ];
  }
}