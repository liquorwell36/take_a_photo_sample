## 概要

カメラ機能を使って写真をリスト内に表示するサンプル。
公式でcameraの使い方ドキュメントが用意されていたので、それを見つつ撮った写真をどう扱うのかを知る。
(具体的いえば、撮った後に遷移元画面に戻ってリスト内表示をさせたい)
https://docs.flutter.dev/cookbook/plugins/picture-using-camera

また、RiverpodのStateProviderで何ができるか確認するために写真データをRiverpodで管理してみたい。今回は少量のコードしかない(1ファイルで完結している)ので使う必要はなさそうだが、練習の意味を込めて利用している。
これも公式ドキュメントが丁寧でわかりやすかった。
https://riverpod.dev/ja/docs/providers/state_provider/

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

なんとなくの理解だが、runAppを呼び出す前にavailableCameras(利用できるカメラのリストを返す)を初期化する必要があって、その際にネイティブのコードを呼び出す必要があるためにWidgetsFlutterBinding.ensureInitialized()でWidgetsBindingのインスタンスを初期化している。(他の記事では非同期処理を書くために必要と書いてあった。)

### CameraController
CameraControllerを使用すると、takePicture () メソッドを使用して写真を撮ることができます。このメソッドは、クロスプラットフォームの簡略化されたFile抽象化であるXFileを返します。AndroidとIOSの両方で、新しいイメージはそれぞれのキャッシュディレクトリに格納され、その場所へのパスがXFileに返される。

### Imageウィジェットに写真を表示
写真の撮影に成功したら、画像ウィジェットを使用して保存した写真を表示できます。この場合、画像はデバイスにファイルとして保存される。
よってファイルのパスを持っていれば、表示できる。
```
SizedBox(
  height: 100,
  child: Image.file(File(imagePathList[index])),
),
```