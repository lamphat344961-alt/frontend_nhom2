import 'package:flutter/material.dart';
import 'package:frontend_nhom2/api/hang_hoa_service.dart';
import 'package:frontend_nhom2/models/hang_hoa_model.dart';

class GoodsFormScreen extends StatefulWidget {
  final HangHoaModel? hangHoaToEdit; // Null nếu là Thêm mới
  const GoodsFormScreen({super.key, this.hangHoaToEdit});

  @override
  State<GoodsFormScreen> createState() => _GoodsFormScreenState();
}

class _GoodsFormScreenState extends State<GoodsFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mahhController = TextEditingController();
  final _tenhhController = TextEditingController();
  final _slController = TextEditingController();
  final _maloaiController =
      TextEditingController(); // Tạm thời dùng TextField cho mã loại

  final _service = HangHoaService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.hangHoaToEdit != null) {
      // Nếu là chỉnh sửa, điền dữ liệu cũ vào form
      _mahhController.text = widget.hangHoaToEdit!.mahh;
      _tenhhController.text = widget.hangHoaToEdit!.tenhh ?? '';
      _slController.text = widget.hangHoaToEdit!.sl.toString();
      _maloaiController.text = widget.hangHoaToEdit!.maloai ?? '';
    }
  }

  @override
  void dispose() {
    _mahhController.dispose();
    _tenhhController.dispose();
    _slController.dispose();
    _maloaiController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final isEditing = widget.hangHoaToEdit != null;
    final hangHoa = HangHoaModel(
      mahh: _mahhController.text.trim(),
      tenhh: _tenhhController.text.trim(),
      sl: int.tryParse(_slController.text.trim()) ?? 0,
      maloai: _maloaiController.text.trim().isNotEmpty
          ? _maloaiController.text.trim()
          : null,
    );

    try {
      if (isEditing) {
        await _service.updateHangHoa(hangHoa);
        // Sau khi sửa, trả về true để màn hình danh sách refresh
        if (mounted) Navigator.pop(context, true);
      } else {
        await _service.createHangHoa(hangHoa);
        // Sau khi thêm, trả về true để màn hình danh sách refresh
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceFirst('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.hangHoaToEdit != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Sửa Hàng Hóa' : 'Thêm Hàng Hóa')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _mahhController,
                decoration: const InputDecoration(
                  labelText: 'Mã Hàng Hóa (MAHH)',
                ),
                enabled: !isEditing, // Không cho sửa mã khi chỉnh sửa
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Mã hàng hóa không được để trống.';
                  return null;
                },
              ),
              TextFormField(
                controller: _tenhhController,
                decoration: const InputDecoration(labelText: 'Tên Hàng Hóa'),
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Tên hàng hóa không được để trống.';
                  return null;
                },
              ),
              TextFormField(
                controller: _slController,
                decoration: const InputDecoration(
                  labelText: 'Số lượng tồn kho (SL)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      int.tryParse(value) == null ||
                      int.parse(value) < 0) {
                    return 'Số lượng phải là một số nguyên không âm.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _maloaiController,
                decoration: const InputDecoration(
                  labelText: 'Mã Loại Hàng (MALOAI)',
                ),
                // Ghi chú: Thực tế nên dùng Dropdown để chọn từ danh sách Loại Hàng
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(isEditing ? 'Cập Nhật' : 'Thêm Mới'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
