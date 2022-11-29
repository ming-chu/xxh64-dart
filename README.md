Port of the [XXH64 hashing algorithm](https://github.com/Cyan4973/xxHash/) in Dart.

## Usage
```dart
final hash = XXH64.digest(data: 'Hello hash!', seed: BigInt.from(123456));
```