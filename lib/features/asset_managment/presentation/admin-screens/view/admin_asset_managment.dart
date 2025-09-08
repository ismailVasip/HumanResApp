// ignore_for_file: unnecessary_type_check

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/presentation/admin-screens/bloc/bloc/assets_mng_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AdminAssetManagment extends StatelessWidget {
  const AdminAssetManagment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AssetsMngBloc>(),
      child: const AdminAssetManagmentView(),
    );
  }
}

class AdminAssetManagmentView extends StatefulWidget {
  const AdminAssetManagmentView({super.key});

  @override
  State<AdminAssetManagmentView> createState() =>
      _AdminAssetManagmentViewState();
}

class _AdminAssetManagmentViewState extends State<AdminAssetManagmentView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _toWhoController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();

  List<Asset> _currentAssetList = [];
  Iterable<Asset> _iterableAssetList = [];

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final userEmail = authState.user.email!;
      context.read<AssetsMngBloc>().add(AssetsFetched(byWho: userEmail));
    }
  }

  @override
  void dispose() {
    _toWhoController.dispose();
    _serialNumberController.dispose();
    super.dispose();
  }

  final Map<String, List<String>> _brandModels = {
    'Apple': ['iPhone 13', 'iPhone 14', 'iPhone 15'],
    'Samsung': ['Galaxy S22', 'Galaxy S23', 'Galaxy Z Flip'],
    'Xiaomi': ['Redmi Note 10', 'Redmi Note 11', 'Mi 11 Lite'],
  };

  String? _selectedBrand;
  String? _selectedModel;
  List<String> _availableModels = [];
  int pageViewIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(title: 'Zimmet Yönetimi', isBackButtonActive: false),
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocConsumer<AssetsMngBloc, AssetsMngState>(
            listener: (context, state) {
              if (state is AssetsMngFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                      backgroundColor: Colors.red,
                    ),
                  );
              }
              if (state is AssetsMngActionSuccess) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                _formKey.currentState?.reset();
                _toWhoController.clear();
                _serialNumberController.clear();
                setState(() {
                  _selectedBrand = null;
                  _selectedModel = null;
                  _availableModels = [];
                });
              }
            },
            builder: (context, state) {
              if (state is AssetsMngLoaded) {
                _currentAssetList = state.assets;
                _iterableAssetList = _currentAssetList.take(3);
              }

              final bool isLoading = state is AssetsMngLoading;

              if (state is AssetsMngInitial ||
                  (isLoading && state.isFirstFetch)) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.blue),
                );
              }

              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Yeni Cihaz Zimmetle',
                            style: TextStyle(
                              fontSize: 21,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          TextFormField(
                            controller: _toWhoController,
                            decoration: const InputDecoration(
                              labelText: 'Kullanıcı E-Postası',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Lütfen bir e-posta adresi giriniz.';
                              }
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value)) {
                                return 'Lütfen geçerli bir e-posta adresi giriniz.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedBrand,
                            hint: const Text('Marka Seçiniz'),
                            items: _brandModels.keys.map((String brand) {
                              return DropdownMenuItem(
                                value: brand,
                                child: Text(brand),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedBrand = newValue;
                                _selectedModel = null;
                                _availableModels = _brandModels[newValue] ?? [];
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Marka',
                            ),
                            validator: (value) => value == null
                                ? 'Lütfen bir marka seçiniz.'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            value: _selectedModel,
                            hint: const Text('Model Seçiniz'),
                            items: _availableModels.map((String model) {
                              return DropdownMenuItem(
                                value: model,
                                child: Text(model),
                              );
                            }).toList(),
                            onChanged: _selectedBrand == null
                                ? null
                                : (String? newValue) {
                                    setState(() {
                                      _selectedModel = newValue;
                                    });
                                  },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Model',
                            ),
                            disabledHint: const Text('Önce marka seçiniz'),
                            validator: (value) => value == null
                                ? 'Lütfen bir model seçiniz.'
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _serialNumberController,
                            decoration: const InputDecoration(
                              labelText: 'Seri Numarası',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Lütfen bir seri numarası giriniz.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          Align(
                            alignment: Alignment.center,
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      if (_formKey.currentState!.validate()) {
                                        final authState = context
                                            .read<AuthBloc>()
                                            .state;
                                        if (authState is AuthSuccess) {
                                          final adminEmail =
                                              authState.user.email!;
                                          final newAsset = Asset(
                                            id: const Uuid().v4(),
                                            byWho: adminEmail,
                                            toWho: _toWhoController.text.trim(),
                                            brand: _selectedBrand!,
                                            model: _selectedModel!,
                                            serialNumber:
                                                _serialNumberController.text
                                                    .trim(),
                                            assignDate: DateTime.now(),
                                          );
                                          context.read<AssetsMngBloc>().add(
                                            AssignAssetRequested(
                                              assetToAssign: newAsset,
                                            ),
                                          );
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "ZİMMETLE",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Son Zimmetlenen Cihazlar',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    '/adminAllAssignedAssetsPage',
                                  );
                                },
                                child: const Text(
                                  'Tümü',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          if (_iterableAssetList.isNotEmpty)
                            SizedBox(
                              height: 140,
                              child: PageView.builder(
                                controller: PageController(
                                  viewportFraction: 0.9,
                                ),
                                itemCount: _iterableAssetList.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    pageViewIndex = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final asset = _iterableAssetList.elementAt(
                                    index,
                                  );

                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: Colors.black12,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 14,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade700,
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(12),
                                                  bottomLeft: Radius.circular(
                                                    12,
                                                  ),
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${asset.brand} ${asset.model}",
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 19,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Kime: ${asset.toWho}\nSN: ${asset.serialNumber}\nTarih: ${DateFormat('dd.MM.yyy HH:mm').format(asset.assignDate)}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                            size: 30,
                                          ),
                                          onPressed: isLoading
                                              ? null
                                              : () {
                                                  showCancelAssignmentDialog(
                                                    context,
                                                    asset,
                                                  );
                                                },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            const SizedBox(
                              height: 140,
                              child: Center(
                                child: Text("Henüz zimmetlenmiş cihaz yok."),
                              ),
                            ),

                          const SizedBox(height: 14),

                          Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                _iterableAssetList.length,
                                (index) => Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: pageViewIndex == index
                                          ? Colors.blue.shade700
                                          : Colors.black,
                                      borderRadius: BorderRadius.circular(36),
                                      border: Border.all(
                                        color: Colors.white24,
                                        width: 1,
                                        style: BorderStyle.solid,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<dynamic> showCancelAssignmentDialog(
    BuildContext context,
    Asset asset,
  ) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Emin misiniz?',
            style: TextStyle(color: Colors.black),
          ),
          content: const Text(
            'Atamayı iptal etmek istediğinize emin misiniz?',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Hayır', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                backgroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
                context.read<AssetsMngBloc>().add(
                  CancelAssignmentRequested(assetToCancel: asset),
                );
              },
              child: const Text('Evet', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
