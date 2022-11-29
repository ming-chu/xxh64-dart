import 'package:flutter_test/flutter_test.dart';
import 'dart:io';
import 'dart:math';
import 'package:xxh64/xxh64.dart';

void main() {
  group('XXH64 Test', () {
    test('test XXH64.rotl', () {
      final rotl = XXH64.rotl(x: BigInt.parse('6221097971675392492'), r: 31);
      expect(rotl.toString(), '9029353272303608786');
    });

    test('test XXH64.round', () {
      var round = XXH64.round(
        acc: BigInt.parse('128'),
        input: BigInt.parse('2'),
      );
      expect(round.toString(), '6075530607141913643');

      round = XXH64.round(
        acc: BigInt.parse('2342334'),
        input: BigInt.parse('2'),
      );
      expect(round.toString(), '7952084526949532715');

      round = XXH64.round(
        acc: BigInt.parse('4345634563456'),
        input: BigInt.parse('32'),
      );
      expect(round.toString(), '12150438868989388436');
    });

    test('test XXH64.mergeRound', () {
      var mergeRound = XXH64.mergeRound(
        acc: BigInt.parse('4423423'),
        val: BigInt.parse('32'),
      );
      expect(mergeRound.toString(), '15763700522042800554');

      mergeRound = XXH64.mergeRound(
        acc: BigInt.parse('2312342123334'),
        val: BigInt.parse('64'),
      );
      expect(mergeRound.toString(), '13694692901207037177');

      mergeRound = XXH64.mergeRound(
        acc: BigInt.parse('43145634561233456'),
        val: BigInt.parse('128'),
      );
      expect(mergeRound.toString(), '5770724901972134668');
    });

    //[49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70, 49, 50, 51]
    test('test XXH64.UInt8ArrayToUInt', () {
      var num = XXH64.convertIntArrayToBigInt(
        array: [
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          65,
          66,
          67,
          68,
          69,
          70,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          65,
          66,
          67,
          68,
          69,
          70,
          49,
          50,
          51
        ],
        index: 16,
      );
      expect(num.toString(), '4123106164818064178');

      num = XXH64.convertIntArrayToBigInt(
        array: [
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          65,
          66,
          67,
          68,
          69,
          70,
          49,
          50,
          51,
          52,
          53,
          54,
          55,
          56,
          57,
          65,
          66,
          67,
          68,
          69,
          70,
          49,
          50,
          51
        ],
        index: 24,
      );
      expect(num.toString(), '3616749239067165249');

      num = XXH64
          .convertIntArrayToBigInt(array: [71, 72, 73, 74, 75, 76], index: 0);
      expect(num.toString(), '83886252574791');
    });

    test('test XXH64.swap', () {
      var result = XXH64.swap(BigInt.parse('3616749239067165249'));
      expect(result.toString(), '4702394921427284274');

      result = XXH64.swap(BigInt.parse('909456435'));
      expect(result.toString(), '859059510');

      result = XXH64.swap(BigInt.parse('4774159993596687668'));
      expect(result.toString(), '3761972674532294978');

      result = XXH64.swap(BigInt.parse('3761405300998227011'));
      expect(result.toString(), '4847075266732897076');
    });

    test('test XXH64.finalize', () {
      var result = XXH64.finalize(
          h: BigInt.parse('2870177452160083908'),
          array: [],
          len: 0,
          endian: Endian.little);
      expect(result.toString(), '2762220722563373876');

      result = XXH64.finalize(
          h: BigInt.parse('2870177452160083909'),
          array: [49],
          len: 1,
          endian: Endian.little);
      expect(result.toString(), '55788671215529161');

      result = XXH64.finalize(
          h: BigInt.parse('2870177452160083911'),
          array: [49, 50, 51],
          len: 3,
          endian: Endian.little);
      expect(result.toString(), '1847307508393980282');

      result = XXH64.finalize(
          h: BigInt.parse('2870177452160083926'),
          array: [
            49,
            50,
            51,
            52,
            53,
            54,
            55,
            56,
            57,
            65,
            66,
            67,
            68,
            69,
            70,
            49,
            50,
            51
          ],
          len: 18,
          endian: Endian.little);
      expect(result.toString(), '1012868637032094316');
    });

    test('test XXH64.digest', () {
      var result = XXH64.digest(data: 'ABC', seed: BigInt.from(2147483647));
      expect(result.toString(), '15797479979174972575');

      result = XXH64.digest(data: 'JFGU#3SKD', seed: BigInt.from(2147483647));
      expect(result.toString(), '7367589494533449586');

      result = XXH64.digest(data: 'GHIJKL', seed: BigInt.from(2147483647));
      expect(result.toString(), '4027016598219745550');

      result = XXH64.digest(data: 'xxhash', seed: BigInt.from(20141025));
      expect(result.toString(), '13067679811253438005');

      result = XXH64.digest(data: 'xxhash2', seed: BigInt.from(0x1234567890));
      expect(result.toString(), '13063737571838136875');

      result = XXH64.digest(data: 'Hello hash!', seed: BigInt.from(123456));
      expect(result.toString(), '16757859236885667383');

      result = XXH64.digest(
          data: 'LONG_LONG_12345678901234567890',
          seed: BigInt.from(0x1234567890));
      expect(result.toString(), '17254423677287601589');
    });

    /*
    test('test digest result same as python', () async {
      for (int i = 0; i < 100; i++) {
        BigInt seed = BigInt.from(Random().nextInt(4294967296));
        String element = getRandomString(8);
        final result = XXH64.digest(data: element, seed: seed).toString();
        final resultFromPython = await hashFromPython(element, seed.toString());
        expect(
          result,
          resultFromPython,
          reason: 'hash of "$element" with seed "$seed" is difference',
        );
      }
    });
     */
  });
}

Future<String> hashFromPython(String element, String seed) async {
  // you need to install xxhash for python before you use it.
  // pip install xxhash
  // https://pypi.org/project/xxhash/
  // python -c "import sys;import xxhash; print(xxhash.xxh64('ABC', seed=0x123456789).intdigest())"
  final result = await Process.run('python', [
    '-c',
    "import sys;import xxhash; print(xxhash.xxh64('$element', seed=$seed).intdigest())"
  ]);
  return (result.stdout as String).replaceAll('\n', '');
}

String getRandomString(int length) {
  Random rnd = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );
}
