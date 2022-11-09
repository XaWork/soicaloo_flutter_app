import 'package:rxdart/rxdart.dart';
import 'package:socialoo/models/search_post_model.dart';
import 'package:socialoo/repository/repository.dart';

class SearchBloc {
  final _search = PublishSubject<SearchPostModel>();

  Stream<SearchPostModel> get searchStream => _search.stream;

  Future searchSink(String text, String? userID) async {
    SearchPostModel searchModal =
        await Repository().searchRepository(text, userID);
    _search.sink.add(searchModal);
  }

  dispose() {
    _search.close();
  }
}

final searchBloc = SearchBloc();
