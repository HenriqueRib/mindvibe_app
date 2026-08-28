import 'package:mindvibe_app/core/error/app_failure.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;

  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Failure<T>() => null,
  };

  AppFailure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Failure<T>(:final error) => error,
  };

  R when<R>({
    required R Function(T value) success,
    required R Function(AppFailure error) failure,
  }) {
    return switch (this) {
      Success<T>(:final value) => success(value),
      Failure<T>(:final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.value);
  final T value;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppFailure error;
}
