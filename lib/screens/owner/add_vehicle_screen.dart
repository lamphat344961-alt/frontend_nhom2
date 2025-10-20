import 'package:flutter/material.dart';
import '../../api/xe_service.dart';
import '../../models/xe_model.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bsxeController = TextEditingController();
  final _tenxeController = TextEditingController();
  final _ttxeController = TextEditingController();
  final XeService _xeService = XeService();
  bool _isLoading = false;

  Future<void> _addVehicle() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      try {
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
          Navigator.pop(context, true); // Trả về true để báo hiệu cần refresh
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
      appBar: AppBar(title: const Text('Thêm Xe Mới')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _bsxeController,
                decoration: const InputDecoration(labelText: 'Biển số xe (BS_XE)'),
                validator: (value) => value!.isEmpty ? 'Vui lòng nhập biển số' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tenxeController,
                decoration: const InputDecoration(labelText: 'Tên xe'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ttxeController,
                decoration: const InputDecoration(labelText: 'Trạng thái xe'),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: _addVehicle,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}