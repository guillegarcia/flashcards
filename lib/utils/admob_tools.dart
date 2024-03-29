import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdmobTools{

  static final AdmobTools _singleton = AdmobTools._privateConstructor();
  AdmobTools._privateConstructor(){
    MobileAds.instance.initialize();
  }

  factory AdmobTools() {
    return _singleton;
  }

  final bool _debugMode = false;

  final _actionsNumberToShowAd = 3;
  final bool showInFirstAction = true;
  int actionsCounter = 0;
  bool firstActionDone = false;
  bool screenReady = false;

  void adAction(){
    actionsCounter++;
    if(actionsCounter>_actionsNumberToShowAd){
      actionsCounter=0;
    }
    if(mustShowAd()){
      _createInterstitialAd();
    }
  }

  bool mustShowAd(){
    bool mustShowAd = false;
    if(!firstActionDone && showInFirstAction && actionsCounter == 1){
      firstActionDone = true;
      mustShowAd = true;
    } else if (actionsCounter == _actionsNumberToShowAd){
      mustShowAd = true;
    }
    return mustShowAd;
  }

  void screenIsReadyToShowAd() => screenReady = true;

  static const int maxFailedLoadAttempts = 3;

  //Ads Ids
  final String _interstitialAdIdAndroid = 'ca-app-pub-9891329721318092/5565621050';
  final String _interstitialAdIdIOS = ''; //TODO

  String get _interstitialAdId {
    if (Platform.isAndroid) {
      return _interstitialAdIdAndroid;
    } else if (Platform.isIOS) {
      return _interstitialAdIdIOS;
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static final AdRequest request = AdRequest(
    keywords: <String>['Estudiar','Examen','trivial','Exam','Study'],
    nonPersonalizedAds: false,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  Future _createInterstitialAd() async{
    await InterstitialAd.load(
        adUnitId: _interstitialAdId,
            //_debugMode
            //? InterstitialAd.testAdUnitId
            //: _interstitialAdId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            //adReady = true;
            if(screenReady){
              showInterstitialAd();
            }
          },
          onAdFailedToLoad: (LoadAdError error) async {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              await _createInterstitialAd();
            }
          },
        )
    );
  }

  void disposeInterstitialAd() {
    _interstitialAd?.dispose();
    screenReady = false;
  }

  void showInterstitialAd() async{
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      //onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        //print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        //_createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        //print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        //_createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

}