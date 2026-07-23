abstract class Resource<T> {}

class Loading<T> extends Resource<T> {}

class Success<T> extends Resource<T> {
  final T data;
  Success({required this.data});
}

class ErrorData<T> extends Resource<T> {
  final String message;
  ErrorData({required this.message});
}
