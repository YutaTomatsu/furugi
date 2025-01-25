import 'package:flutter/material.dart';
import '/backend/backend.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  bool _butonclicked = true;
  bool get butonclicked => _butonclicked;
  set butonclicked(bool value) {
    _butonclicked = value;
  }

  String _address1 = '';
  String get address1 => _address1;
  set address1(String value) {
    _address1 = value;
  }

  String _address2 = '';
  String get address2 => _address2;
  set address2(String value) {
    _address2 = value;
  }

  String _address3 = '';
  String get address3 => _address3;
  set address3(String value) {
    _address3 = value;
  }

  LatLng? _LatLngs = const LatLng(34.8565154, 136.8198019);
  LatLng? get LatLngs => _LatLngs;
  set LatLngs(LatLng? value) {
    _LatLngs = value;
  }

  String _search = '';
  String get search => _search;
  set search(String value) {
    _search = value;
  }

  String _category = '';
  String get category => _category;
  set category(String value) {
    _category = value;
  }

  List<DocumentReference> _cartItems = [];
  List<DocumentReference> get cartItems => _cartItems;
  set cartItems(List<DocumentReference> value) {
    _cartItems = value;
  }

  void addToCartItems(DocumentReference value) {
    cartItems.add(value);
  }

  void removeFromCartItems(DocumentReference value) {
    cartItems.remove(value);
  }

  void removeAtIndexFromCartItems(int index) {
    cartItems.removeAt(index);
  }

  void updateCartItemsAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    cartItems[index] = updateFn(_cartItems[index]);
  }

  void insertAtIndexInCartItems(int index, DocumentReference value) {
    cartItems.insert(index, value);
  }

  int _cartSum = 0;
  int get cartSum => _cartSum;
  set cartSum(int value) {
    _cartSum = value;
  }

  List<DocumentReference> _prefectures = [];
  List<DocumentReference> get prefectures => _prefectures;
  set prefectures(List<DocumentReference> value) {
    _prefectures = value;
  }

  void addToPrefectures(DocumentReference value) {
    prefectures.add(value);
  }

  void removeFromPrefectures(DocumentReference value) {
    prefectures.remove(value);
  }

  void removeAtIndexFromPrefectures(int index) {
    prefectures.removeAt(index);
  }

  void updatePrefecturesAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    prefectures[index] = updateFn(_prefectures[index]);
  }

  void insertAtIndexInPrefectures(int index, DocumentReference value) {
    prefectures.insert(index, value);
  }

  int _ShopsSum = 0;
  int get ShopsSum => _ShopsSum;
  set ShopsSum(int value) {
    _ShopsSum = value;
  }

  List<DocumentReference> _shops = [];
  List<DocumentReference> get shops => _shops;
  set shops(List<DocumentReference> value) {
    _shops = value;
  }

  void addToShops(DocumentReference value) {
    shops.add(value);
  }

  void removeFromShops(DocumentReference value) {
    shops.remove(value);
  }

  void removeAtIndexFromShops(int index) {
    shops.removeAt(index);
  }

  void updateShopsAtIndex(
    int index,
    DocumentReference Function(DocumentReference) updateFn,
  ) {
    shops[index] = updateFn(_shops[index]);
  }

  void insertAtIndexInShops(int index, DocumentReference value) {
    shops.insert(index, value);
  }

  List<String> _selectedPrefectures = [];
  List<String> get selectedPrefectures => _selectedPrefectures;
  set selectedPrefectures(List<String> value) {
    _selectedPrefectures = value;
  }

  void addToSelectedPrefectures(String value) {
    selectedPrefectures.add(value);
  }

  void removeFromSelectedPrefectures(String value) {
    selectedPrefectures.remove(value);
  }

  void removeAtIndexFromSelectedPrefectures(int index) {
    selectedPrefectures.removeAt(index);
  }

  void updateSelectedPrefecturesAtIndex(
    int index,
    String Function(String) updateFn,
  ) {
    selectedPrefectures[index] = updateFn(_selectedPrefectures[index]);
  }

  void insertAtIndexInSelectedPrefectures(int index, String value) {
    selectedPrefectures.insert(index, value);
  }

  int _shopCount = 0;
  int get shopCount => _shopCount;
  set shopCount(int value) {
    _shopCount = value;
  }

  double _evaluation = 0.0;
  double get evaluation => _evaluation;
  set evaluation(double value) {
    _evaluation = value;
  }

  DocumentReference? _productUser;
  DocumentReference? get productUser => _productUser;

  get currentAction => null;
  set productUser(DocumentReference? value) {
    _productUser = value;
  }

  List<Map<String, dynamic>> paymentCartItems = [];
  int paymentTotalPrice = 0;
}
