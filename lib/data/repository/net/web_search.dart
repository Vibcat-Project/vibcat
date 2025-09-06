import 'package:vibcat/bean/web_search_args.dart';
import 'package:vibcat/service/web_search.dart';

class WebSearchRepository {
  Future<String?> request(WebSearchArgs args) async {
    return await WebSearchServiceFactory.create(args).request();
  }
}
