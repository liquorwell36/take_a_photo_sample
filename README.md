## 概要

カメラ機能を使って写真をリスト内に表示するサンプル。</br>
公式でcameraの使い方ドキュメントが用意されていたので、それを見つつ撮った写真をどう扱うのかを知る。</br>
(具体的いえば、撮った後に遷移元画面に戻ってリスト内表示をさせたい)</br>
https://docs.flutter.dev/cookbook/plugins/picture-using-camera

また、RiverpodのStateProviderで何ができるか確認するために写真データをRiverpodで管理してみたい。今回は少量のコードしかない(1ファイルで完結している)ので使う必要はなさそうだが、練習の意味を込めて利用している。</br>
これも公式ドキュメントが丁寧でわかりやすかった。</br>
https://riverpod.dev/ja/docs/providers/state_provider/

### 1. 必要なプラグインをpub getする
[camera](https://pub.dev/packages/camera)
デバイス上のカメラを操作するためのプラグイン
[path_provider](https://pub.dev/packages/path_provider)
画像の保存先のパスを検索してくれるプラグイン
[path](https://pub.dev/packages/path)
あらゆるプラットフォームで動作するパスを作成してくれるプラグイン

これらをpubspec.yamlのdependencies下におき、`flutter pub get`する。
＊ VSCodeならcommnad+cntrl+pでコマンドを表示させてDart:Add Dependencyから入れたいプラグインを検索すればpub getまでしてくれるから便利。(これはFlutterの公式Youtubeを見て知った。https://www.youtube.com/watch?v=AaQzV1LTmo0&t=2079s)

Androidで動作するようにminSdkVersionを21以上(android/app/build.gradleのdefaultConfig内にある)に設定し、
iOSで動作するようにios/Runner/Info.plistのdictタグ内に以下コードを入れる必要がある。
```
<!--cameraを使うために以下2行を追加-->
<key>NSCameraUsageDescription</key>
<string>Explanation on why the camera access is needed.</string>
```

### 2. main内に利用可能なカメラのリスト取得する
ここからmain.dartで作業する。
まずはデバイス上で操作できるカメラの情報を取得する。

```
// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
final firstCamera = cameras.first;
```

#### 1行目のWidgetsFlutterBindingとは
WidgetsFlutterBindingとは公式ドキュメントによるとFlutter Engineとframeworkを繋げてくれる接着剤のようなものらしい(公式の文章をそのままGoogle翻訳しただけ)。</br>
https://api.flutter.dev/flutter/widgets/WidgetsFlutterBinding-class.html
</br>
runAppを呼び出す前にFlutter Engineの機能を使いたいときにコールするそう。Flutter Engineの機能はプラットフォーム(Android, iOSとか)の情報(画面の向きやロケール、今回でいうとカメラ)などらしい。今回のcameraプラグインを利用する場合にrunAppの前に初期化する必要がある。

</br>

####  availableCameras、cameras.firstについて
＊ awailableCamerasの型は`Future<List<CameraDescription>>`で、cameras.firstで実際に何が入っているかデバッグして確認すると以下スクショのような値が入っていた。





### 3. CameraControllerを初期化する
CameraControllerを使用すると、takePicture () メソッドを使用して写真を撮ることができる。このメソッドは、クロスプラットフォームの簡略化されたFile抽象化であるXFileを返す。AndroidとIOSの両方で、新しいイメージはそれぞれのキャッシュディレクトリに格納され、その場所へのパスがXFileに返される。

```
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });
  //main内のcameraをもってきてる
  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  //initState内で初期化するためlateを使っている
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    //ここでCameraControllerのインスタンスを作成
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    //CameraControllerの初期化。Futureが返る
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    //disposeも忘れずに
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Container();
  }
}
```
ここで注意すべきなのはinitState内でCameraControllerの初期化を行っていること。

### 4. CameraPreviewで写真を表示する
初期化できたので写真を撮る実装を進めるかと思いきや、先に写真を表示させるための実装を行なっている。
```
// You must wait until the controller is initialized before displaying the
// camera preview. Use a FutureBuilder to display a loading spinner until the
// controller has finished initializing.
FutureBuilder<void>(
  future: _initializeControllerFuture, //ここが肝
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // If the Future is complete, display the preview.
      return CameraPreview(_controller);
    } else {
      // Otherwise, display a loading indicator.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
```
初期化まで待つ必要があるため、FutureBuilderを使っている。`_initializeControllerFuture`はinitState内で定義した変数。

### 5. CameraControllerで写真を撮る


### Imageウィジェットに写真を表示
写真の撮影に成功したら、画像ウィジェットを使用して保存した写真を表示できます。この場合、画像はデバイスにファイルとして保存される。
よってファイルのパスを持っていれば、表示できる。
```
SizedBox(
  height: 100,
  child: Image.file(File(imagePathList[index])),
),
```

---

todo: (10/5)
- [ ] Widgetテストを書く
- [ ] 記事用にもっと丁寧に調べる
  - [ ] セクション番号をつける
  - [ ] 最初に画面遷移図を書いて、具体的にどう動かせようとしているのか説明する。
  - [ ] 公式ドキュメントとは違う実装の箇所は分離させて書く
  - [ ] Flutterを始めて1週間くらい(StatefulWidgetあたりはわかるけど、cameraやRiverpodの使い方は知らん)の人に教えるつもりで書く。
