import 'package:pixiv/model/tags.dart';
import 'package:pixiv/net/api_client.dart';
import 'package:pixiv/provider/view_state_model.dart';

class SearchSuggestionsModel extends ViewStateModel {
  AutoWords autoWords;

  Future<void> fetch(String query) async {
    setBusy();
    try {
      AutoWords autoWords = await apiClient.getSearchAutoCompleteKeywords(query);
      this.autoWords = autoWords;
      if (autoWords == null || autoWords.tags.isEmpty) {
        setEmpty();
      } else {
        setIdle();
      }
    } catch (e) {
      setEmpty();
    }
  }
}
