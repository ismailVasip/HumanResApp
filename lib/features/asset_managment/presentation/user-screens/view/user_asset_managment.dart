import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/common/singleton/get_admin_email.dart';
import 'package:ikproject/features/asset_managment/domain/entities/asset.dart';
import 'package:ikproject/features/asset_managment/domain/entities/support_line.dart';
import 'package:ikproject/features/asset_managment/presentation/user-screens/bloc/user_assetmng_bloc.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserAssetManagment extends StatelessWidget {
  const UserAssetManagment({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserAssetsMngBloc>(),
      child: const UserAssetManagmentView(),
    );
  }
}

class UserAssetManagmentView extends StatefulWidget {
  const UserAssetManagmentView({super.key});

  @override
  State<UserAssetManagmentView> createState() => _UserAssetManagmentViewState();
}

class _UserAssetManagmentViewState extends State<UserAssetManagmentView> {
  List<Asset> _currentAssetList = [];
  final TextEditingController _requestController = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      userEmail = authState.user.email!;
      context.read<UserAssetsMngBloc>().add(AssetsFetched(toWho: userEmail));
    }
  }

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Zimmet', isBackButtonActive: false),
      body: SafeArea(
        child: BlocConsumer<UserAssetsMngBloc, UserAssetmngState>(
          listener: (context, state) {
            if (state is UserAssetsMngFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                    backgroundColor: Colors.red,
                  ),
                );
            }
            if (state is UserAssetsMngLoaded) {
              setState(() {
                _currentAssetList = state.assets;
              });
            }
          },
          builder: (context, state) {
            final bool isLoading = state is UserAssetsMngLoading;

            if (state is UserAssetsMngInitial ||
                (isLoading && state.isFirstFetch)) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.blue),
              );
            }

            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cihazlarım',
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Expanded(
                        child: _currentAssetList.isEmpty
                            ? const SizedBox(
                                height: 140,
                                child: Center(
                                  child: Text("Henüz zimmetlenmiş cihaz yok."),
                                ),
                              )
                            : ListView.builder(
                                itemCount: _currentAssetList.length,
                                itemBuilder: (context, index) {
                                  final asset = _currentAssetList[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 14,
                                          height: 95,
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
                                                "Kim: ${asset.byWho} tarafından zimmetlendi.\nSN: ${asset.serialNumber}\nTarih: ${DateFormat('dd.MM.yyy HH:mm').format(asset.assignDate)}",
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
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  Positioned.fill(
                    child: Container(
                      color: Color.fromRGBO(0, 0, 0, 0.2),
                      child: Center(
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: BlocListener<UserAssetsMngBloc, UserAssetmngState>(
        listener: (context, state) {
          if (state is ReqSupportLineSendedSuccess) {
            Navigator.of(context).pop();
            _requestController.clear();
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
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                return Form(
                  key: _key,
                  child: AlertDialog(
                    icon: Icon(
                      Icons.support_agent_sharp,
                      color: Colors.black,
                      size: 36,
                    ),
                    title: Text('Destek Hattı', style: TextStyle(fontSize: 19)),
                    titlePadding: null,
                    iconPadding: null,
                    backgroundColor: Colors.white,
                    content: TextFormField(
                      controller: _requestController,
                      decoration: InputDecoration(
                        hintText: 'Lütfen talebinizi yazınız...',
                      ),
                      validator: (value) =>
                          (value == null || value.trim().isEmpty) ? 'Lütfen bir mesaj yazınız.' : null,
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          final String? adminEmail = await GetAdminEmail
                              .instance
                              .getAdminEmailForUser(userEmail);
                          if (_key.currentState!.validate()) {
                            context.read<UserAssetsMngBloc>().add(
                              AssetsSupportLine(
                                entity: SupportLineEntity(
                                  id: Uuid().v4(),
                                  adminEmail: adminEmail ?? '',
                                  userEmail: userEmail,
                                  request: _requestController.text.trim(),
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          minimumSize: Size(50, 40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Text(
                          "İlet",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          child: Icon(Icons.support_agent_sharp, size: 30),
        ),
      ),
    );
  }
}
