import 'package:flutter/material.dart';
import '../../api/xe_service.dart';
import '../../models/xe_model.dart';

class VehicleFormScreen extends StatefulWidget {
  // Nếu vehicleToEdit là null: Chế độ THÊM MỚI
  // Nếu vehicleToEdit có giá trị: Chế độ CHỈNH SỬA
  final XeReadModel? vehicleToEdit;

  const VehicleFormScreen({super.key, this.vehicleToEdit});

  @override
  State<VehicleFormScreen> createState() => _VehicleFormScreenState();
}

class _VehicleFormScreenState extends State<VehicleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bsxeController = TextEditingController();
  final _tenxeController = TextEditingController();
  final _ttxeController = TextEditingController();
  final XeService _xeService = XeService();
  bool _isLoading = false;

  bool get _isEditMode => widget.vehicleToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      // Nếu là chỉnh sửa, điền thông tin cũ vào form
      _bsxeController.text = widget.vehicleToEdit!.bsXe!;
      _tenxeController.text = widget.vehicleToEdit!.tenxe ?? '';
      _ttxeController.text = widget.vehicleToEdit!.ttXe ?? '';
    }
  }

  Future<void> _saveVehicle() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
        if (_isEditMode) {
          // --- Logic CẬP NHẬT ---
          // Backend DTO (XeUpdateDto) chỉ cần tenxe và ttxe
          final updatedVehicle = XeUpdateModel(
            tenXe: _tenxeController.text,
            ttXe: _ttxeController.text,
          );
          await _xeService.updateVehicle(widget.vehicleToEdit!.bsXe!, updatedVehicle);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cập nhật xe thành công!'), backgroundColor: Colors.green),
            );
          }
        } else {
          // --- Logic THÊM MỚI ---
          final newVehicle = XeCreateModel(
            bsXe: _bsxeController.text,
            tenxe: _tenxeController.text,
            ttXe: _ttxeController.text,
          );
          await _xeService.createVehicle(newVehicle);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Thêm xe thành công!'), backgroundColor: Colors.green),
            );
          }
        }
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Chỉnh Sửa Xe' : 'Thêm Xe Mới'),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _bsxeController,
                // KHÓA ô biển số nếu đang ở chế độ SỬA
                readOnly: _isEditMode,
                style: TextStyle(color: _isEditMode ? Colors.grey : Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Biển số xe (BS_XE)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.pin),
                ),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập biển số' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tenxeController,
                decoration: const InputDecoration(
                  labelText: 'Tên xe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.directions_car),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _ttxeController,
                decoration: const InputDecoration(
                  labelText: 'Trạng thái xe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle_outline),
                ),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _saveVehicle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4F46E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Lưu Thay Đổi', style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}