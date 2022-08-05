// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/auth_strings.dart';
// import 'package:local_auth/local_auth.dart';
//
// class FingerprintLoginPage extends StatefulWidget {
//   @override
//   FingerprintState createState() => FingerprintState();
// }
//
// class FingerprintState extends State<FingerprintLoginPage> {
//   final LocalAuthentication auth = LocalAuthentication();
//   _SupportState _supportState = _SupportState.unknown;
//   bool _canCheckBiometrics;
//   List<BiometricType> _availableBiometrics;
//   String _authorized = 'Not Authorized';
//   bool _isAuthenticating = false;
//
//   @override
//   void initState() {
//     super.initState();
//     auth.isDeviceSupported().then(
//           (isSupported) => setState(() => _supportState = isSupported
//               ? _SupportState.supported
//               : _SupportState.unsupported),
//         );
//   }
//
//   Future<void> _checkBiometrics() async {
//     bool canCheckBiometrics;
//     try {
//       canCheckBiometrics = await auth.canCheckBiometrics;
//     } on PlatformException catch (e) {
//       canCheckBiometrics = false;
//       print(e);
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _canCheckBiometrics = canCheckBiometrics;
//     });
//   }
//
//   Future<void> _getAvailableBiometrics() async {
//     List<BiometricType> availableBiometrics;
//     try {
//       availableBiometrics = await auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       availableBiometrics = <BiometricType>[];
//       print(e);
//     }
//     if (!mounted) return;
//
//     setState(() {
//       _availableBiometrics = availableBiometrics;
//     });
//   }
//
//   Future<void> _authenticate() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = '识别中...';
//       });
//       //弹框汉化
//       const androidAuth = const AndroidAuthMessages(
//         cancelButton: '取消',
//         goToSettingsButton: '去设置',
//         goToSettingsDescription: '请设置指纹.',
//         biometricHint: '身份校验',
//         signInTitle: '指纹验证',
//       );
//       authenticated = await auth.authenticate(
//           localizedReason: '扫描指纹进行身份识别',
//           useErrorDialogs: false,
//           androidAuthStrings: androidAuth,
//           stickyAuth: true);
//       setState(() {
//         _isAuthenticating = false;
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;
//
//     setState(
//         () => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
//   }
//
//   Future<void> _authenticateWithBiometrics() async {
//     bool authenticated = false;
//     try {
//       setState(() {
//         _isAuthenticating = true;
//         _authorized = '识别中...';
//       });
//       //弹框汉化
//       const androidAuth = const AndroidAuthMessages(
//           cancelButton: '取消',
//           goToSettingsButton: '去设置',
//           goToSettingsDescription: '请设置指纹.',
//           biometricHint: '身份校验',
//           signInTitle: '指纹验证',
//       );
//       authenticated = await auth.authenticate(
//           localizedReason:
//               '扫描指纹进行身份识别',
//           useErrorDialogs: false,
//           stickyAuth: true,
//           androidAuthStrings: androidAuth,
//           biometricOnly: true);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = '识别中...';
//       });
//     } on PlatformException catch (e) {
//       print(e);
//       setState(() {
//         _isAuthenticating = false;
//         _authorized = "Error - ${e.message}";
//       });
//       return;
//     }
//     if (!mounted) return;
//
//     final String message = authenticated ? 'Authorized' : 'Not Authorized';
//     setState(() {
//       _authorized = message;
//     });
//   }
//
//   void _cancelAuthentication() async {
//     await auth.stopAuthentication();
//     setState(() => _isAuthenticating = false);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('指纹登录'),
//         ),
//         body: ListView(
//           padding: const EdgeInsets.only(top: 30),
//           children: [
//             Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 if (_supportState == _SupportState.unknown)
//                   CircularProgressIndicator()
//                 else if (_supportState == _SupportState.supported)
//                   Text("该设备支持生物识别")
//                 else
//                   Text("该设备不支持生物识别"),
//                 Divider(height: 100),
//                 Text('是否支持生物识别: $_canCheckBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('检测是否支持生物识别'),
//                   onPressed: _checkBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('支持的生物识别类型: $_availableBiometrics\n'),
//                 ElevatedButton(
//                   child: const Text('获取支持的生物识别类型'),
//                   onPressed: _getAvailableBiometrics,
//                 ),
//                 Divider(height: 100),
//                 Text('当前识别状态: $_authorized\n'),
//                 (_isAuthenticating)
//                     ? ElevatedButton(
//                         onPressed: _cancelAuthentication,
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text("取消识别"),
//                             Icon(Icons.cancel),
//                           ],
//                         ),
//                       )
//                     : Column(
//                         children: [
//                           ElevatedButton(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text('生物识别'),
//                                 Icon(Icons.perm_device_information),
//                               ],
//                             ),
//                             onPressed: _authenticate,
//                           ),
//                           ElevatedButton(
//                             child: Row(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Text(_isAuthenticating
//                                     ? '取消'
//                                     : '只有指纹识别'),
//                                 Icon(Icons.fingerprint),
//                               ],
//                             ),
//                             onPressed: _authenticateWithBiometrics,
//                           ),
//                         ],
//                       ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// enum _SupportState {
//   unknown,
//   supported,
//   unsupported,
// }
