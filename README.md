A Flex implementation similar to FlutterFlex, aimed to be simpler, faster, and fixing some limitations. 

> **Warning**
> This package is in development. It's unfinished and changes are inevitable. Expect v1 to be stable.

### Parent Widgets

`Flex` => `NFlex`.  
`Row` => `NRow`.  
`Column` => `NColumn`.  

### Child Widgets

`Expanded` => `NExpanded`.  

### Helper Widgets

`NDirection`.  

## Features over Flex

`padding`: set padding directly in the `Parent Widgets`.  
`gap`: set the gap between elements.

## Limitations

As expected on `v1`, `Parent Widgets` would not provide `baseline` alignments, and `verticalAlignment` and `textDirection` are not available directly on `NFlex`, but in `NDirection`.

## Differences

`Expanded` children would get shared space after minium size calculations.
On `Flutter` they don't get a minium size. 
Add example.

## Getting started

run `flutter pub get nflex`

## Usage

```dart
NFlex(
  padding: const EdgeInsets.all(10.0),
  direction: Axis.horizontal,
  children: [
    Container(
      color: const Color.fromRGBO(255, 0, 0, 1),
      constraints: const BoxConstraints.tightFor(width: 100, height: 100),
    ),
    Container(
      color: const Color.fromARGB(255, 200, 255, 0),
      constraints: const BoxConstraints.tightFor(width: 80, height: 80),
    ),
  ],
);
```

## Things to do before releasing v1

| feature | test | impl | doc |
|---|---|---|---|
| padding            | ✅ | ✅ |    |
| gap                | ✅ | ✅ |    |
| mainAxisAlignment  | ✅ | ✅ |    |
| crossAxisAlignment | ✅ | ✅ |    |
| axis               | ✅ | ✅ |    |
| NFlexible          | ❌ | ❌ | ❌ |
| NRow               | ❌ | ✅ |    |
| NColumn            | ❌ | ✅ |    |
| NDirection         | ❌ | ❌ | ❌ |
| minium element size| ❌ | ❌ | ❌ |
| intrinsics         | ❌ | ❌ |    |
| dry layout         | ❌ | ❌ |    |
| examples           |    |    | ❌ |