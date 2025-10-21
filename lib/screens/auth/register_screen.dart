import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend_nhom2/providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _u = TextEditingController();
  final _p = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _u.dispose();
    _p.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Giả định register() tạo tài khoản Driver (role mặc định)
      // Đây là đoạn code được xác nhận:
      await context.read<AuthProvider>().register(
        u: _u.text.trim(),
        p: _p.text,
        name: _name.text.trim(),
        phone: _phone.text.trim().isEmpty ? null : _phone.text.trim(),
      );
      if (mounted) Navigator.pop(context); // quay lại login
    } catch (e) {
      setState(() {
        // Cắt bỏ tiền tố "Exception: " nếu có
        _error = e.toString().replaceFirst("Exception: ", "");
      });
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // THAY ĐỔI: Thêm resizeToAvoidBottomInset và SingleChildScrollView
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký (Driver)')),
      // Cho phép Scaffold tự điều chỉnh khi bàn phím xuất hiện
      resizeToAvoidBottomInset: true,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          // THÊM: SingleChildScrollView để tránh bị bàn phím che khuất
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon đẹp hơn một chút
                  const Icon(
                    Icons.person_add_alt_1,
                    size: 50,
                    color: Colors.indigo,
                  ),
                  const SizedBox(height: 24),

                  // Họ tên
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Họ tên',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 16),

                  // Username
                  TextFormField(
                    controller: _u,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Bắt buộc' : null,
                  ),
                  const SizedBox(height: 16),

                  // SĐT
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'SĐT (Không bắt buộc)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone_outlined),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mật khẩu
                  TextFormField(
                    controller: _p,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outlined),
                    ),
                    obscureText: true,
                    validator: (v) => v != null && v.length >= 4
                        ? null
                        : 'Mật khẩu phải ≥4 ký tự',
                  ),
                  const SizedBox(height: 24),

                  // Thông báo lỗi
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),

                  // Nút Đăng ký
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Tạo tài khoản',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
