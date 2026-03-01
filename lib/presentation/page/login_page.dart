import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:battery_music/core/services/v2/node_api_service.dart';
import 'package:battery_music/core/services/v2/user_service.dart';
import 'package:battery_music/presentation/components/window_controls.dart';
import 'package:battery_music/presentation/layout/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// 登录页面
/// 提供手机号验证码登录和二维码扫描登录功能
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

enum _LoginType { phone, qrCode }

class _LoginPageState extends State<LoginPage> {
  // final NodeServiceApi _nodeServiceApi = NodeServiceApi();
  final NodeApiService _nodeApiService = NodeApiService();
  final UserService _userService = UserService();

  // 二维码登录相关状态
  Timer? _pollingTimer;
  Timer? _qrRefreshTimer;
  Uint8List? _qrImageBytes;
  String? _qrKey;
  String _qrStatusMessage = "点击按钮获取二维码";
  bool _isQrLoading = false;

  // 手机号登录相关状态
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  bool _isPhoneLoginLoading = false;
  String? _phoneLoginErrorText;

  // 验证码相关状态
  bool _isSendingCode = false;
  Timer? _countdownTimer;
  int _countdownSeconds = 60;
  bool get _canSendCode =>
      _countdownTimer == null || !_countdownTimer!.isActive;

  // 当前登录方式
  _LoginType _loginType = _LoginType.phone;

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _qrRefreshTimer?.cancel();
    _phoneController.dispose();
    _codeController.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  /// 重置二维码和定时器状态
  void _resetQrState() {
    _pollingTimer?.cancel();
    _qrRefreshTimer?.cancel();
    if (mounted) {
      setState(() {
        _pollingTimer = null;
        _qrRefreshTimer = null;
        _isQrLoading = false;
        _qrImageBytes = null; // 清除图片
        _qrStatusMessage = "点击按钮获取二维码";
      });
    }
  }

  /// 获取二维码并开始轮询
  Future<void> _getQrAndPoll() async {
    _resetQrState(); // 先重置状态

    if (mounted) {
      setState(() {
        _isQrLoading = true;
        _qrImageBytes = null;
        _qrStatusMessage = "正在获取二维码...";
      });
    }

    try {
      // final ApiResponse<LoginQrKey> response = await _nodeServiceApi
      //     .loginQrKey();
      final response = await _nodeApiService.loginQrKey();
      if (!mounted) return;

      if (response.data?.qrcode != null) {
        setState(() {
          _qrImageBytes = response.data!.qrImage!;
          _qrKey = response.data!.qrcode!;
          _qrStatusMessage = '请使用酷狗APP扫描';
          _isQrLoading = false;
        });

        // 30秒后自动刷新二维码
        _qrRefreshTimer = Timer(const Duration(seconds: 30), () {
          if (_loginType == _LoginType.qrCode) {
            _getQrAndPoll();
          }
        });

        _startPolling(_qrKey!);
      } else {
        if (!mounted) return;
        setState(() {
          _qrStatusMessage = '获取二维码失败，请重试';
          _isQrLoading = false;
        });
      }
    } catch (e) {
      log('获取二维码失败: $e');
      if (mounted) {
        setState(() {
          _qrStatusMessage = '获取二维码失败: $e';
          _isQrLoading = false;
        });
      }
    }
  }

  /// 开始轮询检查二维码状态
  void _startPolling(String key) {
    _pollingTimer?.cancel(); // Ensure only one poller is running
    _pollingTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted || _loginType != _LoginType.qrCode) {
        timer.cancel();
        return;
      }

      try {
        // final response = await _nodeServiceApi.loginQrCheck(key);
        final response = await _nodeApiService.loginQrCheck(key);
        if (!mounted) return;

        final qrCheck = response.data;
        if (qrCheck == null) return;

        if (qrCheck.isSuccess) {
          // Stop timers to prevent further checks.
          timer.cancel();
          _qrRefreshTimer?.cancel();
          _userService.saveUserInfo(loginQrCheck: qrCheck);

          log("登录成功");

          // 登录成功，跳转到主界面
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const MainLayout()),
            );
          }
          return;
        } else if (qrCheck.isExpired) {
          if (!mounted) return;
          setState(() {
            _qrStatusMessage = '二维码已过期，正在刷新...';
          });
          _getQrAndPoll(); // 自动刷新
        } else if (qrCheck.isWaitingConfirm) {
          if (!mounted) return;
          setState(() {
            _qrStatusMessage = '扫描成功，请在手机上确认登录';
          });
        } else if (qrCheck.isWaitingScan) {
          // '等待扫码'这个状态可以不用频繁更新，避免UI闪烁
          if (_qrStatusMessage != '请使用酷狗APP扫描') {
            if (!mounted) return;
            setState(() {
              _qrStatusMessage = '请使用酷狗APP扫描';
            });
          }
        }
      } catch (e) {
        log('轮询检查二维码状态时发生错误: $e');
        // 可以选择在这里停止轮询或提示错误
        if (mounted) {
          _resetQrState();
          setState(() {
            _qrStatusMessage = "检查状态出错, 请重试";
          });
        }
      }
    });
  }

  /// 发送验证码
  Future<void> _handleSendCode() async {
    // 校验手机号
    if (_phoneController.text.isEmpty ||
        !RegExp(r'^1\d{10}$').hasMatch(_phoneController.text)) {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('请输入有效的11位手机号')));
      return;
    }

    setState(() {
      _isSendingCode = true;
    });

    try {
      // await _nodeServiceApi.captchaSent(_phoneController.text);
      await _nodeApiService.captchaSent(_phoneController.text);
      if (!mounted) return;
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('验证码已发送')));
      _startCountdown();
    } catch (e) {
      log('发送验证码失败: $e');
      // if (mounted) {
      //   ScaffoldMessenger.of(
      //     context,
      //   ).showSnackBar(SnackBar(content: Text('发送验证码失败: $e')));
      // }
    } finally {
      if (mounted) {
        setState(() {
          _isSendingCode = false;
        });
      }
    }
  }

  /// 开始倒计时
  void _startCountdown() {
    _countdownSeconds = 60;
    _countdownTimer?.cancel(); // Cancel any existing timer
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        if (_countdownSeconds > 0) {
          _countdownSeconds--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  /// 处理手机号登录
  Future<void> _handlePhoneLogin() async {
    // 校验表单
    if (!(_phoneFormKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isPhoneLoginLoading = true;
      _phoneLoginErrorText = null;
    });

    try {
      // final ApiResponse<LoginResponse> response = await _nodeServiceApi
      //     .loginForCellPhone(_phoneController.text, _codeController.text);
      final response = await _nodeApiService.loginForCellPhone(
        _phoneController.text,
        _codeController.text,
      );

      if (response.status == 1) {
        _userService.saveUserInfo(userInfo: response.data!);
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
        );
        // final userDetailResponse = await NodeServiceApi.instance.userDetial();
        // final userDetailResponse = await _nodeApiService.userDetail();
        // if (userDetailResponse.data != null) {
        //   await UserService.instance.saveUserInfo(userDetailResponse.data!);
        //   if (!mounted) return;
        //   // ScaffoldMessenger.of(
        //   //   context,
        //   // ).showSnackBar(const SnackBar(content: Text('登录成功！')));
        // } else {
        //   setState(() {
        //     _phoneLoginErrorText = '获取用户信息失败，请重试';
        //   });
        // }
      } else {
        setState(() {
          _phoneLoginErrorText = '登录失败，请检查验证码或手机号';
        });
      }
    } catch (e) {
      log('手机号登录出错: $e');
      if (mounted) {
        setState(() {
          _phoneLoginErrorText = '发生未知错误，请稍后重试';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isPhoneLoginLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 60,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DragToMoveArea(child: const WindowControls()),
            ),
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 380),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '登录 Battery Music',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '同步你的酷狗音乐体验',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ToggleButtons(
                            borderRadius: BorderRadius.circular(8),
                            isSelected: [
                              _loginType == _LoginType.phone,
                              _loginType == _LoginType.qrCode,
                            ],
                            onPressed: (index) {
                              setState(() {
                                _loginType = _LoginType.values[index];
                                if (_loginType != _LoginType.qrCode) {
                                  _resetQrState();
                                } else {
                                  // 用户切换到二维码时，如果之前没加载过，就主动加载
                                  if (_qrImageBytes == null && !_isQrLoading) {
                                    _getQrAndPoll();
                                  }
                                }
                              });
                            },
                            children: const [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text('手机号登录'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24.0),
                                child: Text('二维码登录'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                        child: _loginType == _LoginType.phone
                            ? _buildPhoneLoginSection()
                            : _buildQrCodeLoginSection(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 手机号登录区域
  Widget _buildPhoneLoginSection() {
    return Form(
      key: _phoneFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: '手机号',
              hintText: '请输入11位手机号',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.phone_iphone),
              counterText: "", // Hide counter
            ),
            keyboardType: TextInputType.phone,
            maxLength: 11,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '手机号不能为空';
              }
              if (!RegExp(r'^1\d{10}$').hasMatch(value)) {
                return '请输入有效的11位手机号';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeController,
            decoration: InputDecoration(
              labelText: '验证码',
              hintText: '请输入验证码',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.shield_outlined),
              suffixIcon: TextButton(
                onPressed: _canSendCode && !_isSendingCode
                    ? _handleSendCode
                    : null,
                child: _isSendingCode
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_canSendCode ? '获取验证码' : '$_countdownSeconds s'),
              ),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '验证码不能为空';
              }
              return null;
            },
          ),
          if (_phoneLoginErrorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                _phoneLoginErrorText!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 24),
          SizedBox(
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _isPhoneLoginLoading ? null : _handlePhoneLogin,
              child: _isPhoneLoginLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Text('登录', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  /// 二维码登录区域
  Widget _buildQrCodeLoginSection() {
    return Column(
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _isQrLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _qrImageBytes != null
                  ? Image.memory(
                      _qrImageBytes!,
                      key: ValueKey(_qrImageBytes),
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: TextButton(
                        onPressed: _getQrAndPoll,
                        child: const Text('获取二维码'),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _qrStatusMessage,
            key: ValueKey(_qrStatusMessage),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
