import 'package:flutter/material.dart';
import 'package:frontend_nhom2/api/hang_hoa_service.dart';
import 'package:frontend_nhom2/models/hang_hoa_model.dart';
import 'goods_form_screen.dart'; // Import màn hình Form mới

class GoodsListScreen extends StatefulWidget {
  const GoodsListScreen({super.key});

  @override
  State<GoodsListScreen> createState() => _GoodsListScreenState();
}

class _GoodsListScreenState extends State<GoodsListScreen> {
  late Future<List<HangHoaModel>> _hangHoasFuture;
  final HangHoaService _hangHoaService = HangHoaService();

  @override
  void initState() {
    super.initState();
    _loadHangHoas();
  }

  void _loadHangHoas() {
    setState(() {
      _hangHoasFuture = _hangHoaService.getAllHangHoas();
    });
  }

  // Hàm xử lý điều hướng đến form (Thêm/Sửa)
  void _navigateAndReload({HangHoaModel? itemToEdit}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GoodsFormScreen(hangHoaToEdit: itemToEdit),
      ),
    );

    // Nếu màn hình Form trả về true, có nghĩa là đã có thay đổi -> load lại danh sách
    if (result == true) {
      _loadHangHoas();
    }
  }

  // Hàm xử lý Xóa
  void _confirmDelete(String mahh) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Bạn có chắc chắn muốn xóa hàng hóa $mahh này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(context).pop(); // Đóng dialog xác nhận
              try {
                await _hangHoaService.deleteHangHoa(mahh);
                _loadHangHoas(); // Tải lại danh sách sau khi xóa thành công
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Đã xóa hàng hóa thành công.'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        e.toString().replaceFirst('Exception: ', ''),
                      ),
                    ),
                  );
                }
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Quản Lý Hàng Hóa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadHangHoas),
        ],
      ),
      body: FutureBuilder<List<HangHoaModel>>(
        future: _hangHoasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có hàng hóa nào trong kho.'));
          }

          final hangHoas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: hangHoas.length,
            itemBuilder: (context, index) {
              final hh = hangHoas[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  leading: const Icon(Icons.category, color: Colors.blueAccent),
                  title: Text(
                    '${hh.tenhh ?? 'Chưa đặt tên'} (${hh.mahh})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tồn kho: ${hh.sl} | Loại: ${hh.maloai ?? 'N/A'}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // NÚT SỬA
                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          size: 20,
                          color: Colors.blue,
                        ),
                        onPressed: () => _navigateAndReload(itemToEdit: hh),
                      ),
                      // NÚT XÓA
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        onPressed: () => _confirmDelete(hh.mahh),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      // NÚT THÊM
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndReload(itemToEdit: null),
        child: const Icon(Icons.add),
      ),
    );
  }
}
