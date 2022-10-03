# take_a_photo_sample

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---
カメラ機能を使って写真をリスト内に表示するサンプル。
公式でcameraの使い方ドキュメントが用意されていたので、それを見つつ撮った写真をどう扱うのかを知る。
(具体的いえば、撮った後に遷移元画面に戻ってリスト内表示をさせたい)

### main内に利用可能なカメラのリスト取得する
```
// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
final firstCamera = cameras.first;
```
WidgetsFlutterBindingとは公式ドキュメントによるとFlutter Engineとframeworkを繋げてくれる接着剤のようなものらしい。
https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding-class.html

#### Flutter Engineとはなんぞや
Flutter Engineの役割を簡単に日本語で説明してくれている記事があった。
https://qiita.com/kurun_pan/items/02b46e4b330b137da3db
https://zenn.dev/seya/articles/f7ebcd8335eee7


なんとなくの理解だが、runAppを呼び出す前にavailableCameras(利用できるカメラのリストを返す)を初期化する必要があって、その際にネイティブのコードを呼び出す必要があるためにWidgetsFlutterBinding.ensureInitialized()でWidgetsBindingのインスタンスを初期化している。





### CameraController
CameraControllerを使用すると、takePicture () メソッドを使用して写真を撮ることができます。このメソッドは、クロスプラットフォームの簡略化されたFile抽象化であるXFileを返します。AndroidとIOSの両方で、新しいイメージはそれぞれのキャッシュディレクトリに格納され、その場所へのパスがXFileに返されます。

### Imageウィジェットに写真を表示
写真の撮影に成功したら、画像ウィジェットを使用して保存した写真を表示できます。この場合、画像はデバイスにファイルとして保存されます。