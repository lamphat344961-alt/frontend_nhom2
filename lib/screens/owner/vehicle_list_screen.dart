import 'package:flutter/material.dart';
import 'package:frontend_nhom2/models/user_model.dart';
import '../../api/xe_service.dart';
import '../../api/user_service.dart';
import '../../models/xe_model.dart';
import 'vehicle_form_screen.dart'; // Sửa: Dùng form mới

class VehicleListScreen extends StatefulWidget {
  const VehicleListScreen({super.key});

  @override
  State<VehicleListScreen> createState() => _VehicleListScreenState();
}

class _VehicleListScreenState extends State<VehicleListScreen> {
  late Future<List<XeReadModel>> _vehiclesFuture;
  final XeService _xeService = XeService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  // Tải lại danh sách xe
  void _loadVehicles() {
    setState(() {
      _vehiclesFuture = _xeService.getVehicles();
    });
  }

  // Xử lý khi bấm vào nút "Thêm"
  Future<void> _navigateToAddVehicle() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VehicleFormScreen()), // Sửa: Dùng form mới
    );
    if (result == true) {
      _loadVehicles(); // Tải lại danh sách nếu có xe mới được thêm
    }
  }

  // Xử lý khi bấm vào một xe trong danh sách
  Future<void> _navigateToEditVehicle(XeReadModel vehicle) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleFormScreen(vehicleToEdit: vehicle), // Sửa: Dùng form mới
      ),
    );
    if (result == true) {
      _loadVehicles(); // Tải lại danh sách nếu có xe được sửa
    }
  }

  // Xử lý khi bấm nút "Xóa"
  Future<void> _deleteVehicle(XeReadModel vehicle) async {
    // Hiển thị dialog xác nhận
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc muốn xóa xe ${vehicle.bsXe}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _xeService.deleteVehicle(vehicle.bsXe!);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa xe thành công!'), backgroundColor: Colors.green),
        );
        _loadVehicles(); // Tải lại danh sách

      } catch (e) {

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  // Hiển thị modal để GÁN TÀI XẾ
  Future<void> _showAssignDriverModal(XeReadModel vehicle) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        // Chúng ta dùng một StatefulWidget riêng cho modal để nó tự quản lý state (loading, list,...)
        return AssignDriverModal(
          vehicle: vehicle,
          userService: _userService,
          xeService: _xeService,
        );
      },
    );
    _loadVehicles(); // Tải lại danh sách xe sau khi modal đóng (để cập nhật tên tài xế)
  }

  // HIỂN THỊ MENU CHỨC NĂNG (SỬA, XÓA, GÁN)
  void _showVehicleOptions(XeReadModel vehicle) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text('Sửa thông tin xe'),
                onTap: () {
                  Navigator.pop(ctx); // Đóng modal
                  _navigateToEditVehicle(vehicle);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person_add_alt_1),
                title: const Text('Gán tài xế cho xe'),
                onTap: () {
                  Navigator.pop(ctx); // Đóng modal
                  _showAssignDriverModal(vehicle);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Xóa xe', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(ctx); // Đóng modal
                  _deleteVehicle(vehicle);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản Lý Xe', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: FutureBuilder<List<XeReadModel>>(
        future: _vehiclesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có xe nào.'));
          }

          final vehicles = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              // Kiểm tra xem xe đã được gán tài xế chưa
              final bool isAssigned = vehicle.driverFullName != null;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  leading: CircleAvatar(
                    backgroundColor: isAssigned ? const Color(0xFF4F46E5).withAlpha(25) : Colors.grey.shade100,
                    child: Icon(
                      Icons.directions_car,
                      color: isAssigned ? const Color(0xFF4F46E5) : Colors.grey,
                    ),
                  ),
                  title: Text(
                    vehicle.bsXe ?? 'Không có biển số',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  // Hiển thị TÊN TÀI XẾ hoặc "Chưa gán tài xế"
                  subtitle: Text(
                    isAssigned ? vehicle.driverFullName! : 'Chưa gán tài xế',
                    style: TextStyle(
                        color: isAssigned ? Colors.green.shade700 : Colors.orange.shade800,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  // Nút 3 chấm để mở menu
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () => _showVehicleOptions(vehicle),
                  ),
                  onTap: () => _showVehicleOptions(vehicle), // Bấm vào đâu cũng ra menu
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddVehicle,
        backgroundColor: const Color(0xFF4F46E5),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

// (Bạn có thể tách file này ra: widgets/assign_driver_modal.dart)

class AssignDriverModal extends StatefulWidget {
  final XeReadModel vehicle;
  final UserService userService;
  final XeService xeService;

  const AssignDriverModal({
    super.key,
    required this.vehicle,
    required this.userService,
    required this.xeService,
  });

  @override
  State<AssignDriverModal> createState() => _AssignDriverModalState();
}

class _AssignDriverModalState extends State<AssignDriverModal> {
  late Future<List<UserModel>> _driversFuture;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    // Hiện tại, chúng ta lấy tất cả tài xế
    _driversFuture = widget.userService.getDrivers();
  }

  Future<void> _assignDriver(UserModel driver) async {
    setState(() => _isAssigning = true);
    try {
      await widget.xeService.assignDriver(widget.vehicle.bsXe!, driver.userId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đã gán tài xế ${driver.fullName} cho xe ${widget.vehicle.bsXe}'), backgroundColor: Colors.green),
        );
        Navigator.pop(context); // Đóng modal
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi gán: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAssigning = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Chọn tài xế gán cho xe ${widget.vehicle.bsXe}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            if (_isAssigning) const LinearProgressIndicator(),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: _driversFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Lỗi: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Không có tài xế nào.'));
                  }

                  final drivers = snapshot.data!;
                  return ListView.builder(
                    itemCount: drivers.length,
                    itemBuilder: (context, index) {
                      final driver = drivers[index];
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(driver.fullName),
                        subtitle: Text(driver.username),
                        onTap: _isAssigning ? null : () => _assignDriver(driver),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}