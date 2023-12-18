These are my solutions to the 2023 Advent of Code, written in Dart (the language that Flutter uses).

Also see my minor retheme of the Advent of Code website named
[Readable Advent of Code](https://userstyles.world/style/13749/readable-advent-of-code).

#### Directory structure

```
.
├── assets
│   ├── day_n.txt # Puzzle input for day n
├── lib
│   ├── day_n.dart # Solution for day n
└── test
    ├── day_n_test.dart # Tests for solution of day n
```

#### Running the code

To run the code, you need to have Dart installed.
You can either only install Dart (from [here](https://dart.dev/get-dart)),
or you can install Flutter (from [here](https://flutter.dev/docs/get-started/install)) which comes with Dart.

To run the code for a specific day `n`, run the following command:
```bash
dart lib/day_n.dart
```
And to run the tests for a specific day `n`, run the following command:
```bash
dart test test/day_n_test.dart
```
