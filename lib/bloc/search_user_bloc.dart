import 'package:socialoo/models/search_user_model.dart';
import 'package:socialoo/repository/repository.dart';
import 'package:rxdart/rxdart.dart';

class SearchUserBloc {
  final _searchUser = PublishSubject<SearchUserModel>();

  Stream<SearchUserModel> get searchuserStream => _searchUser.stream;

  Future searchSink(String text) async {
    SearchUserModel searchUserModal =
        await Repository().searchuserRepository(text);
    _searchUser.sink.add(searchUserModal);
  }

  dispose() {
    _searchUser.close();
  }
}

final searchUserBloc = SearchUserBloc();
