import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ikproject/core/route_generator/route_generator.dart';
import 'package:ikproject/core/theme/app_theme.dart';
import 'package:ikproject/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:ikproject/features/role_based_routing/presentation/cubit/role_cubit.dart';
import 'package:ikproject/firebase_options.dart';
import 'package:ikproject/service_locator.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR',null);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.black,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  setUpServiceLocator();

  runApp(MyApp());
}


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => serviceLocator<AuthBloc>(),),
        BlocProvider(create: (context) => serviceLocator<RoleCubit>(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HR Project',
        theme: AppTheme.buildTheme(Brightness.light),
        navigatorKey: navigatorKey,
        initialRoute: '/authPage',
        onGenerateRoute: RouteGenerator.routeGenerator,
        builder: (context, child) {
          return BlocListener<AuthBloc, AuthState>(
            listenWhen: (previous, current) => current is Unauthenticated,
            listener: (context,state){
              if (state is Unauthenticated) {
                navigatorKey.currentState?.pushNamedAndRemoveUntil(
                  '/authPage',
                  (route) => false,
                );
              }
            },
            child: child!,//kendisi
          );
        },
      ),
    );
  }
}
