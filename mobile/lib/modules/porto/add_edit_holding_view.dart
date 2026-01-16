import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'portfolio_controller.dart';
import 'models/portfolio_holding.dart';
import '../../theme/app_theme.dart';

class AddEditHoldingView extends StatefulWidget {
  final PortfolioHolding? holding;

  const AddEditHoldingView({super.key, this.holding});

  @override
  State<AddEditHoldingView> createState() => _AddEditHoldingViewState();
}

class _AddEditHoldingViewState extends State<AddEditHoldingView> {
  final PortfolioController controller = Get.find<PortfolioController>();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _coinController;
  late TextEditingController _amountController;
  late TextEditingController _priceController;
  late TextEditingController _notesController;

  // Search State
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  bool _isSearching = false;
  
  // Selected Coin
  String? _selectedCoinCode;
  String? _selectedName;

  bool get isEdit => widget.holding != null;

  @override
  void initState() {
    super.initState();
    _coinController = TextEditingController(text: widget.holding?.name ?? '');
    _amountController = TextEditingController(text: widget.holding?.amount.toString() ?? '');
    _priceController = TextEditingController(text: widget.holding?.avgBuyPrice?.toString() ?? '');
    _notesController = TextEditingController(text: widget.holding?.notes ?? '');

    if (isEdit) {
      _selectedCoinCode = widget.holding!.symbol;
      _selectedName = widget.holding!.name;
    }
  }

  @override
  void dispose() {
    _coinController.dispose();
    _amountController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    if (query.length < 2) {
      setState(() => _suggestions = []);
      return;
    }
    
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() => _isSearching = true);
      final results = await controller.searchCoins(query);
      if (mounted) {
        setState(() {
          _suggestions = results;
          _isSearching = false;
        });
      }
    });
  }

  void _selectCoin(Map<String, dynamic> coin) {
    setState(() {
      _selectedCoinCode = coin['symbol']?.toString().toUpperCase();
      _selectedName = coin['name'];
      _coinController.text = _selectedName!;
      _suggestions = [];
    });
    FocusScope.of(context).unfocus(); // Close keyboard to show selection clearly
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCoinCode == null) {
      Get.snackbar('Gagal', 'Silakan pilih koin dari daftar pencarian', 
        backgroundColor: Colors.red, colorText: Colors.white, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final amount = double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;
    final price = double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;
    
    if (amount <= 0) {
      Get.snackbar('Gagal', 'Jumlah aset harus lebih dari 0', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (isEdit) {
      controller.updateHolding(
        widget.holding!.id, 
        amount, 
        price > 0 ? price : null, 
        _notesController.text
      );
    } else {
      controller.addHolding(
        _selectedCoinCode!, 
        _selectedName!, 
        amount, 
        price > 0 ? price : null, 
        _notesController.text
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
       height: Get.height * 0.85,
       decoration: const BoxDecoration(
         color: MuamalahColors.backgroundPrimary,
         borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
       ),
       padding: const EdgeInsets.all(24),
       child: Form(
         key: _formKey,
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Center(
               child: Container(
                 width: 40,
                 height: 4,
                 margin: const EdgeInsets.only(bottom: 20),
                 decoration: BoxDecoration(
                   color: MuamalahColors.glassBorder,
                   borderRadius: BorderRadius.circular(2),
                 ),
               ),
             ),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               children: [
                 Text(
                   isEdit ? 'Perbarui Aset' : 'Catat Aset Baru',
                   style: const TextStyle(
                     color: MuamalahColors.textPrimary,
                     fontSize: 20,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
                 IconButton(
                   onPressed: () => Get.back(),
                   icon: const Icon(Icons.close_rounded, color: MuamalahColors.textMuted),
                 ),
               ],
             ),
             const SizedBox(height: 24),
             
             // Coin Search Field
             _buildLabel('Nama Aset Kripto'),
             TextFormField(
               controller: _coinController,
               style: const TextStyle(color: MuamalahColors.textPrimary, fontWeight: FontWeight.bold),
               decoration: _inputDeco(
                 hint: 'Cari koin (misal: Bitcoin, ETH)...', 
                 icon: Icons.search_rounded
               ),
               onChanged: isEdit ? null : _onSearchChanged,
               readOnly: isEdit, 
             ),
             
             // Suggestions List
             if (_suggestions.isNotEmpty && !isEdit) ...[
               const SizedBox(height: 8),
               Container(
                 constraints: const BoxConstraints(maxHeight: 200),
                 decoration: BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.circular(16),
                   border: Border.all(color: MuamalahColors.glassBorder),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black.withOpacity(0.05),
                       blurRadius: 10,
                       offset: const Offset(0, 4),
                     ),
                   ],
                 ),
                 child: ListView.builder(
                   shrinkWrap: true,
                   padding: EdgeInsets.zero,
                   itemCount: _suggestions.length,
                   itemBuilder: (context, index) {
                     final coin = _suggestions[index];
                     return ListTile(
                       dense: true,
                       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                       leading: CircleAvatar(
                         radius: 14, 
                         backgroundImage: NetworkImage(coin['thumb'] ?? ''),
                         onBackgroundImageError: (_,__) {}, 
                         backgroundColor: MuamalahColors.neutralBg,
                       ),
                       title: Text(
                         coin['name'],
                         style: const TextStyle(
                           color: MuamalahColors.textPrimary,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       subtitle: Text(
                         coin['symbol'],
                         style: const TextStyle(
                           color: MuamalahColors.textSecondary,
                           fontSize: 12,
                         ),
                       ),
                       onTap: () => _selectCoin(coin),
                     );
                   },
                 ),
               ),
             ],

             const SizedBox(height: 20),
             
             // Amount & Price Row
             Row(
               children: [
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       _buildLabel('Jumlah (Unit)'),
                       TextFormField(
                         controller: _amountController,
                         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                         style: const TextStyle(color: MuamalahColors.textPrimary, fontWeight: FontWeight.bold),
                         decoration: _inputDeco(hint: '0.00'),
                         validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                       ),
                     ],
                   ),
                 ),
                 const SizedBox(width: 16),
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       _buildLabel('Harga Beli (Opsional)'),
                       TextFormField(
                         controller: _priceController,
                         keyboardType: const TextInputType.numberWithOptions(decimal: true),
                         style: const TextStyle(color: MuamalahColors.textPrimary, fontWeight: FontWeight.bold),
                         decoration: _inputDeco(hint: 'Rp 0', prefix: 'Rp '),
                       ),
                     ],
                   ),
                 ),
               ],
             ),
             
             const SizedBox(height: 20),
             _buildLabel('Catatan / Niat Investasi'),
             TextFormField(
               controller: _notesController,
               style: const TextStyle(color: MuamalahColors.textPrimary),
               decoration: _inputDeco(hint: 'Contoh: Tabungan Umroh 2025...'),
               maxLines: 3,
             ),
             
             const Spacer(),
             
             // Save Button
             SizedBox(
               width: double.infinity,
               child: ElevatedButton(
                 onPressed: _save,
                 style: ElevatedButton.styleFrom(
                   backgroundColor: MuamalahColors.primaryEmerald,
                   foregroundColor: Colors.white,
                   elevation: 0,
                   padding: const EdgeInsets.symmetric(vertical: 16),
                   shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(16),
                   ),
                 ),
                 child: Text(
                   isEdit ? 'Simpan Perubahan' : 'Simpan Aset',
                   style: const TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
             ),
             const SizedBox(height: 16), 
           ],
         ),
       ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text, 
        style: const TextStyle(
          color: MuamalahColors.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  InputDecoration _inputDeco({required String hint, IconData? icon, String? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: MuamalahColors.textMuted),
      filled: true,
      fillColor: Colors.white,
      prefixIcon: icon != null ? Icon(icon, color: MuamalahColors.textMuted) : null,
      prefixText: prefix,
      prefixStyle: const TextStyle(color: MuamalahColors.textSecondary, fontWeight: FontWeight.bold),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MuamalahColors.glassBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MuamalahColors.primaryEmerald),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: MuamalahColors.haram),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
