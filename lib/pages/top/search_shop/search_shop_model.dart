// search_shop_model.dart
import 'package:flutter/material.dart';
import '/backend/backend.dart'; // PrefecturesRecordなどのため

class SearchShopModel extends ChangeNotifier {
  /// 検索バー
  final searchBarTextController = TextEditingController();
  final searchBarFocusNode = FocusNode();

  /// タブ制御用
  late TabController tabController;

  /// 選択中のチェック項目をローカルで管理
  final List<String> selectedPrefectures = [];
  final List<String> selectedPriceRanges = [];
  final List<String> selectedPayments = [];
  final List<String> selectedClosedDays = [];
  final List<String> selectedGenders = [];
  final List<String> selectedParking = [];

  /// 検索ヒット件数
  int shopCount = 0;

  // ---- 以下、追加/削除用メソッドを定義 ----
  void addToSelectedPrefectures(String val) {
    if (!selectedPrefectures.contains(val)) {
      selectedPrefectures.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedPrefectures(String val) {
    selectedPrefectures.remove(val);
    notifyListeners();
  }

  void addToSelectedPriceRanges(String val) {
    if (!selectedPriceRanges.contains(val)) {
      selectedPriceRanges.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedPriceRanges(String val) {
    selectedPriceRanges.remove(val);
    notifyListeners();
  }

  void addToSelectedPayments(String val) {
    if (!selectedPayments.contains(val)) {
      selectedPayments.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedPayments(String val) {
    selectedPayments.remove(val);
    notifyListeners();
  }

  void addToSelectedClosedDays(String val) {
    if (!selectedClosedDays.contains(val)) {
      selectedClosedDays.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedClosedDays(String val) {
    selectedClosedDays.remove(val);
    notifyListeners();
  }

  void addToSelectedGenders(String val) {
    if (!selectedGenders.contains(val)) {
      selectedGenders.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedGenders(String val) {
    selectedGenders.remove(val);
    notifyListeners();
  }

  void addToSelectedParking(String val) {
    if (!selectedParking.contains(val)) {
      selectedParking.add(val);
      notifyListeners();
    }
  }

  void removeFromSelectedParking(String val) {
    selectedParking.remove(val);
    notifyListeners();
  }
}
