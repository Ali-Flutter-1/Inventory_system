import 'package:flutter/material.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../features/products/products_screen.dart';
import '../../features/products/product_form_screen.dart';
import '../../features/stock/stock_screen.dart';
import '../../features/employees/employees_screen.dart';
import '../../features/employees/employee_form_screen.dart';
import '../../features/expenses/expenses_screen.dart';
import '../../features/expenses/expense_form_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/settings/screens/account_screen.dart';
import '../../features/settings/screens/change_password_screen.dart';
import '../../features/settings/screens/company_screen.dart';
import '../../features/settings/screens/notifications_screen.dart';
import '../../features/settings/screens/subscription_screen.dart';

class AppRouter {
  AppRouter._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String dashboard = '/';
  static const String products = '/products';
  static const String productForm = '/products/form';
  static const String stock = '/stock';
  static const String employees = '/employees';
  static const String employeeForm = '/employees/form';
  static const String expenses = '/expenses';
  static const String expenseForm = '/expenses/form';
  static const String reports = '/reports';
  static const String settings = '/settings';
  static const String settingsCompany = '/settings/company';
  static const String settingsSubscription = '/settings/subscription';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsAccount = '/settings/account';
  static const String settingsChangePassword = '/settings/change-password';

  static Route<dynamic>? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case dashboard:
        return MaterialPageRoute(builder: (_) => const DashboardScreen());
      case products:
        return MaterialPageRoute(builder: (_) => const ProductsScreen());
      case productForm:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ProductFormScreen(
            productId: args?['productId'] as String?,
          ),
        );
      case stock:
        return MaterialPageRoute(builder: (_) => const StockScreen());
      case employees:
        return MaterialPageRoute(builder: (_) => const EmployeesScreen());
      case employeeForm:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => EmployeeFormScreen(
            employeeId: args?['employeeId'] as String?,
          ),
        );
      case expenses:
        return MaterialPageRoute(builder: (_) => const ExpensesScreen());
      case expenseForm:
        final args = routeSettings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ExpenseFormScreen(
            expenseId: args?['expenseId'] as String?,
          ),
        );
      case reports:
        return MaterialPageRoute(builder: (_) => const ReportsScreen());
      case settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case settingsCompany:
        return MaterialPageRoute(builder: (_) => const CompanyScreen());
      case settingsSubscription:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case settingsNotifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case settingsAccount:
        return MaterialPageRoute(builder: (_) => const AccountScreen());
      case settingsChangePassword:
        return MaterialPageRoute(builder: (_) => const ChangePasswordScreen());
      default:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
    }
  }
}
