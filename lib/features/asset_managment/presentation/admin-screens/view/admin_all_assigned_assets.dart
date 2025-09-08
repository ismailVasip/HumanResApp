import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/presentation/admin-screens/bloc/bloc/assets_mng_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';

class AdminAllAssignedAssets extends StatelessWidget {
  const AdminAllAssignedAssets({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<AssetsMngBloc>(),
      child: AdminAllAssignedAssetsView(),
    );
  }
}

class AdminAllAssignedAssetsView extends StatefulWidget {
  const AdminAllAssignedAssetsView({super.key});

  @override
  State<AdminAllAssignedAssetsView> createState() =>
      _AdminAllAssignedAssetsStateView();
}

class _AdminAllAssignedAssetsStateView
    extends State<AdminAllAssignedAssetsView> {
  final _searchController = TextEditingController();
  String query = '';

  List<Asset> _fullAssetList = [];
  List<Asset> _displayedAssetList = [];

  void _filterList(String query) {
    List<Asset> filteredList = [];

    if (query.isEmpty) {
      filteredList = _fullAssetList;
    } else {
      filteredList = _fullAssetList.where((asset) {
        final serialNumberLower = asset.serialNumber.toLowerCase();
        final queryLower = query.toLowerCase();
        return serialNumberLower.contains(queryLower);
      }).toList();
    }

    setState(() {
      _displayedAssetList = filteredList;
    });
  }

  @override
  void initState() {
    super.initState();

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      final adminEmail = authState.user.email!;
      context.read<AssetsMngBloc>().add(AssetsFetched(byWho: adminEmail));
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: 'Tüm Zimmetlenen Cihazlar',
        isBackButtonActive: true,
      ),
      body: BlocConsumer<AssetsMngBloc, AssetsMngState>(
        listener: (context, state) {
          if (state is AssetsMngLoaded) {
            setState(() {
              _fullAssetList = state.assets;
              _displayedAssetList = state.assets;
            });
          }
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
          }
        },

        builder: (context, state) {
          final bool isLoading = state is AssetsMngLoading;

          if (state is AssetsMngInitial) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _filterList(value);
                      });
                    },
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      hintText: 'Seri numarasına göre arama yapın..',
                      prefixIcon: Icon(Icons.search_sharp),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: Colors.black),
                              onPressed: () {
                                _searchController.clear();
                                _filterList('');
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _displayedAssetList.length,
                    itemBuilder: (context, index) {
                      final asset = _displayedAssetList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _displayedAssetList.isEmpty
                            ? const SizedBox(
                                height: 140,
                                child: Center(
                                  child: Text("Henüz zimmetlenmiş cihaz yok."),
                                ),
                              )
                            : Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 14,
                                    height: 95,
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade700,
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
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
                                        const Divider(
                                          color: Colors.blue,
                                          thickness: 2,
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
                                            showCancelDeleteDialog(
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> showCancelDeleteDialog(BuildContext context, Asset asset) {
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
