// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestService.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'http://developerslife.ru/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getPosts(category, page) async {
    ArgumentError.checkNotNull(category, 'category');
    ArgumentError.checkNotNull(page, 'page');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        '/$category/$page?json=true',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = PostResponse.fromJson(_result.data);
    return Future.value(value);
  }
}
