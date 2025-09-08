import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ikproject/common/error/unknown_page.dart';
import 'package:ikproject/features/asset_managment/presentation/admin-screens/view/admin_all_assigned_assets.dart';
import 'package:ikproject/features/auth/presentation/screens/auth_page.dart';
import 'package:ikproject/features/bonus_request/presentation/user_screens/view/ask_bonus_page.dart';
import 'package:ikproject/features/company_policy/presentation/pages/create_company_policy_page.dart';
import 'package:ikproject/features/create_admin_users/presentation/pages/create_admin_users_page.dart';
import 'package:ikproject/features/home/admin_home_page.dart';
import 'package:ikproject/features/home/user_home_page.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/pages/admin_get_all_users.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/pages/admin_get_support_line_req.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/pages/create_announcement_page.dart';
import 'package:ikproject/features/main_page/presentation/admin_screens/pages/user_financials.dart';
import 'package:ikproject/features/permission/presentation/admin-screens/pages/request_of_permissions_page.dart';
import 'package:ikproject/features/permission/presentation/user-screens/pages/ask_for_permission_page.dart';
import 'package:ikproject/features/permission/presentation/user-screens/pages/history_of_permission_page.dart';
import 'package:ikproject/features/role_based_routing/presentation/screens/role_check_page.dart';

class RouteGenerator {
  static Route<dynamic>? _routeGenerator(
    Widget targetPage,
    RouteSettings settings,
  ) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoPageRoute(
        builder: (context) => targetPage,
        settings: settings,
      );
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return MaterialPageRoute(
        builder: (context) => targetPage,
        settings: settings,
      );
    } else {
      return MaterialPageRoute(
        builder: (context) => targetPage,
        settings: settings,
      );
    }
  }

  static Route<dynamic>? routeGenerator(RouteSettings settings) {
    switch (settings.name) {
      case '/authPage':
        return _routeGenerator(AuthPage(), settings);

      case '/roleCheckPage':
        return _routeGenerator(RoleCheckPage(), settings);

      case '/superAdminPage':
        return _routeGenerator(CreateAdminUsersPage(), settings);

      case '/adminHomePage':
        return _routeGenerator(AdminHomePage(), settings);

      case '/userHomePage':
        return _routeGenerator(UserHomePage(), settings);

      case '/adminAllAssignedAssetsPage':
        return _routeGenerator(AdminAllAssignedAssets(), settings);

      case '/adminRequestOfPermissionsPage':
        return _routeGenerator(RequestOfPermissionsPage(), settings);

      case '/userAskForPermissionPage':
        return _routeGenerator(AskForPermissionPage(), settings);

      case '/userHistoryOfPermissionPage':
        return _routeGenerator(HistoryOfPermissionPage(), settings);
      case '/superAdminCreateCompanyPolicyPage':
        return _routeGenerator(CreateCompanyPolicyPage(), settings);
      case '/adminUpdateUserFinancials':
        return _routeGenerator(UserFinancials(), settings);
      case '/userAskBonusPage':
        return _routeGenerator(AskBonusPage(), settings);
      case '/adminGetAllUsersPage':
        return _routeGenerator(
          AdminGetAllUsers(adminEmail: settings.arguments as String),
          settings,
        );
      case '/adminGetSupportsLineReqPage':
        return _routeGenerator(
          AdminGetSupportLineReq(adminEmail: settings.arguments as String),
          settings,
        );
      case '/adminCreateAnnouncementPage':
        return _routeGenerator(
          CreateAnnouncementPage(adminEmail: settings.arguments as String),
          settings,
        );

      default:
        return _routeGenerator(UnknownPage(), settings);
    }
  }
}
