import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

import 'model/PostResponse.dart';

part 'RestService.g.dart';

@RestApi(baseUrl: "http://developerslife.ru/")
abstract class RestClient {
  factory RestClient(Dio dio) = _RestClient;

  //@GET("/{category}/{page}?json=true")
  //@GET("/random?json=true")
  //@GET("/{id}?json=true")

  static const String TOP_CATEGORY = "top";
  static const String MONTHLY_CATEGORY = "monthly";

  static const String HOT_CATEGORY = "hot";

  static const String LATEST_CATEGORY = "latest";

  @GET("/{category}/{page}?json=true")
  Future<PostResponse> getPosts(@Path() String category, @Path() int page);
}