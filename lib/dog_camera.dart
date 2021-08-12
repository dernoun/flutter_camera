import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late CameraController _controller;
  bool _cameraInitialized = false;
  var _cameraType = 0;
  late AnimationController _flashModeControlRowAnimationController;
  late Animation<double> _flashModeControlRowAnimation;

  @override
  void initState() {
    super.initState();

    _ambiguate(WidgetsBinding.instance)?.addObserver(this);
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    _flashModeControlRowAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _flashModeControlRowAnimation = CurvedAnimation(
      parent: _flashModeControlRowAnimationController,
      curve: Curves.easeInCubic,
    );
    _initializeCamera();
  }

  void _initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    _controller =
        CameraController(cameras[_cameraType], ResolutionPreset.ultraHigh);
    _controller.initialize().then((_) {
      _cameraInitialized = true;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          children: [
            Container(
              color: Colors.black,
              // constraints: const BoxConstraints.expand(),
              child: Stack(
                children: <Widget>[
                  // Text(
                  //   _topText,
                  //   style: TextStyle(color: Colors.white, fontSize: 18),
                  // ),
                  _cameraInitialized ? CameraPreview(_controller) : Container(),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.black,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      IconButton(
                        icon: Icon(Icons.flash_on),
                        iconSize: 30.0,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.camera),
                        iconSize: 75.0,
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(Icons.cameraswitch),
                        iconSize: 30.0,
                        color: Colors.white,
                        onPressed: () {
                          _cameraType == 0 ? _cameraType = 1 : _cameraType = 0;
                          _initializeCamera();
                        },
                      ),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}

T? _ambiguate<T>(T? value) => value;
