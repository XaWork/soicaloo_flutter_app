import 'package:rxdart/rxdart.dart';
import 'package:socialoo/models/latest_model.dart';
import 'package:socialoo/repository/repository.dart';

class LatestPostBloc {
  final _latestPost = PublishSubject<LatestPostModel>();

  Stream<LatestPostModel> get latestStream => _latestPost.stream;

  Future latestSink(String? userID) async {
    LatestPostModel latestModal =
        await Repository().latestpostRepository(userID);
    _latestPost.sink.add(latestModal);
  }

  dispose() {
    _latestPost.close();
  }
}

final latestBloc = LatestPostBloc();
