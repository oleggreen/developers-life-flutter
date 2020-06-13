import 'package:developerslife_flutter/clean/domain/entities/categories.dart';
import 'package:developerslife_flutter/clean/data/model/PostItem.dart';

abstract class PostRepository {
  List<PostItem> getPosts(Category category);
}