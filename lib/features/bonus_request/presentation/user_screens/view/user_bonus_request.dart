import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/common/components/app_bar.dart';
import 'package:ikproject/core/utils/get_color_req_status_enum.dart';
import 'package:ikproject/core/utils/translate_req_status_enum.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/bonus_request/domain/entities/advance_request_entity.dart';
import 'package:ikproject/features/bonus_request/domain/entities/user_financials_entity.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/bloc/user_bonus_bloc.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserBonusRequest extends StatelessWidget {
  const UserBonusRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<UserBonusBloc>(),
      child: UserBonusRequestView(),
    );
  }
}

class UserBonusRequestView extends StatefulWidget {
  const UserBonusRequestView({super.key});

  @override
  State<UserBonusRequestView> createState() => _UserBonusRequestViewState();
}

class _UserBonusRequestViewState extends State<UserBonusRequestView> {
  UserFinancialsEntity entity = UserFinancialsEntity(
    userEmail: 'Hata',
    annualLimit: 0,
    remainingLimit: 0,
  );
  List<AdvanceRequestEntity> list = [];
  int _selectedPageTab = 0;
  int maxInstallments = 1;
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthSuccess) {
      context.read<UserBonusBloc>().add(
        UserGetFinancials(userEmail: authState.user.email!),
      );

      context.read<UserBonusBloc>().add(
        UserFetchAdvanceReqs(userEmail: authState.user.email!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Avans İste', isBackButtonActive: false),
      body: BlocConsumer<UserBonusBloc, UserBonusState>(
        listener: (context, state) {
          if (state is UserBonusFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red,
                ),
              );
          }
          if (state is UserFinancialsFetched) {
            setState(() {
              entity = state.entity;
            });
          }
          if (state is UserAllFinancialsFetched) {
            setState(() {
              list = state.list;
            });
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 6,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: CircularPercentIndicator(
                      radius: 80,
                      lineWidth: 12,
                      percent:
                          ((entity.remainingLimit.toInt() * 100) /
                              entity.annualLimit.toInt()) /
                          100,
                      animation: true,
                      animationDuration: 2200,
                      header: Text(
                        "Kalan Limit",
                        style: TextStyle(
                          fontSize: 23,
                          letterSpacing: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      center: Text(
                        entity.annualLimit != 0.0
                            ? '${((entity.remainingLimit * 100) / entity.annualLimit).toInt()}%'
                            : '0%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      backgroundColor: Colors.black87,
                      progressColor: Colors.blue,
                      circularStrokeCap: CircularStrokeCap.butt,
                      footer: Text(
                        "Toplam Limit : ${entity.remainingLimit.toInt()}₺ / ${entity.annualLimit.toInt()}₺",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Geri Ödeme Planı',
                    style: TextStyle(
                      fontSize: 21,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 250,
                    child: list.isEmpty
                        ? Center(
                            child: Text(
                              'Henüz avans talebiniz yok.',
                              style: TextStyle(fontSize: 17),
                            ),
                          )
                        : PageView.builder(
                            controller: PageController(viewportFraction: 0.95),
                            itemCount: list.length,
                            onPageChanged: (index) {
                              setState(() {
                                _selectedPageTab = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final item = list[index];
                              return Card(
                                color: Colors.white,
                                elevation: 6,
                                shadowColor: Colors.black,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    spacing: 2,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Text(
                                          translateName(item.status),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: getColor(item.status),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 4,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Text(
                                              '${item.amount.toInt()}₺',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 32,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Toplam Avans',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                Text(
                                                  '${item.amount.ceil()}₺',
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            LinearPercentIndicator(
                                              lineHeight: 5,
                                              percent: 0.7,
                                              animation: true,
                                              animationDuration: 1000,
                                              backgroundColor: Colors.black,
                                              progressColor: Colors.blue,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Text(
                                          'Bir sonraki kesinti: ${item.requestDate.day} '
                                          '${DateFormat.MMMM('tr').format(DateTime(item.requestDate.year, item.requestDate.month + 1))} '
                                          '(${item.repaymentPlan?['monthly_deduction']}₺)',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: Row(
                                          spacing: 8,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  backgroundColor: Colors.black,
                                                ),
                                                onPressed: null,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  spacing: 4,
                                                  children: [
                                                    const Text(
                                                      'Toplu Öde',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.payment_rounded,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                  ),
                                                  backgroundColor: Colors.black,
                                                ),
                                                onPressed: null,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  spacing: 4,
                                                  children: [
                                                    const Text(
                                                      'Kesintiyi Öde',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    const Icon(
                                                      Icons.payment_rounded,
                                                      color: Colors.white,
                                                      size: 17,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        list.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Container(
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              color: _selectedPageTab == index
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
                  Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4A90E2), // mavi
                          Color(0xFF357ABD), // koyu mavi
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/userAskBonusPage');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Avans İste',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
