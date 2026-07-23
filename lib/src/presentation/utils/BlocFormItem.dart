class BlocformItem {
  final String value;
  final String? error;

  const BlocformItem({this.value = '', this.error});

  BlocformItem copyWith({String? value, String? error}) {
    return BlocformItem(value: value ?? this.value, error: error ?? this.error);
  }
}
