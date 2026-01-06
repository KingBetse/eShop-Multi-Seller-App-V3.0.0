import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/PushNotificationService.dart';
import 'package:sellermultivendor/Provider/AdvertisingPackageProvider.dart';
import 'package:sellermultivendor/Provider/addPickUpLocationProvider.dart';
import 'package:sellermultivendor/Provider/brandProvider.dart';
import 'package:sellermultivendor/Provider/cityProvider.dart';
import 'package:sellermultivendor/Provider/faqProvider.dart';
import 'package:sellermultivendor/Provider/pickUpLocationProvider.dart';
import 'package:sellermultivendor/Provider/pushNotificationProvider.dart';
import 'package:sellermultivendor/Repository/chatRepository.dart';
import 'package:sellermultivendor/Repository/consignment_repository.dart';
import 'package:sellermultivendor/Repository/generateAWBRepository.dart';
import 'package:sellermultivendor/Repository/hiveRepository.dart';
import 'package:sellermultivendor/Repository/ordeListRepositry.dart';
import 'package:sellermultivendor/Repository/sendPickUpRequestRepository.dart';
import 'package:sellermultivendor/Screen/Authentication/Login.dart';
import 'package:sellermultivendor/Screen/DeshBord/dashboard.dart';
import 'package:sellermultivendor/cubits/groupConverstationsCubit.dart';
import 'package:sellermultivendor/cubits/languageCubit.dart';
import 'package:sellermultivendor/cubits/loadCountryCodeCubit.dart';
import 'package:sellermultivendor/cubits/makeMeOnlineCubit.dart';
import 'package:sellermultivendor/cubits/order/create_consignment_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_consignments_cubit.dart';
import 'package:sellermultivendor/cubits/order/fetch_orders_cubit.dart';
import 'package:sellermultivendor/cubits/order/generate_awb_cubit.dart';
import 'package:sellermultivendor/cubits/order/send_pickup_request_cubit.dart';
import 'package:sellermultivendor/cubits/personalConverstationsCubit.dart';
import 'package:sellermultivendor/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Helper/Color.dart';
import 'Helper/Constant.dart';
import 'Localization/Demo_Localization.dart';
import 'Provider/ProductListProvider.dart';
import 'Provider/ProfileProvider.dart';
import 'Provider/addProductProvider.dart';
import 'Provider/attributeSetProvider.dart';
import 'Provider/categoryProvider.dart';
import 'Provider/countryProvider.dart';
import 'Provider/editProductProvider.dart';
import 'Provider/homeProvider.dart';
import 'Provider/loginProvider.dart';
import 'Provider/mediaProvider.dart';
import 'Provider/privacyProvider.dart';
import 'Provider/reviewListProvider.dart';
import 'Provider/salesReportProvider.dart';
import 'Provider/searchProvider.dart';
import 'Provider/settingProvider.dart';
import 'Provider/stockmanagementProvider.dart';
import 'Provider/taxProvider.dart';
import 'Provider/walletProvider.dart';
import 'Provider/zipcodeProvider.dart';
// Remove splash screen import
// import 'Screen/SplashScreen/splashScreen.dart';

// Import your repositories for settings
import 'Repository/getSettingRepositry.dart';
import 'Repository/appSettingsRepository.dart';
import 'Model/appSettingsModel.dart';
import 'Widget/sharedPreferances.dart';
import 'Widget/parameterString.dart';

// Global provider instance
SettingProvider? globalSettingsProvider;

// Global navigation key
GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  debugProfileBuildsEnabled = true;

  // Set basic UI configuration immediately
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // Show immediate loading screen
  runApp(const AppInitializer());
}

// App initializer that handles all setup
class AppInitializer extends StatefulWidget {
  const AppInitializer({Key? key}) : super(key: key);

  @override
  _AppInitializerState createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  late Future<Widget> _appFuture;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _appFuture = _initializeApp();
  }

  Future<Widget> _initializeApp() async {
    try {
      // 1. Get shared preferences
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      // 2. Initialize Firebase
      if (Firebase.apps.isNotEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      } else {
        await Firebase.initializeApp();
      }

      // 3. Initialize Hive
      await Hive.initFlutter();
      await HiveRepository.init();

      HttpOverrides.global = MyHttpOverrides();

      // 4. Load app settings (from your splash screen logic)
      final data = await SystemRepository.fetchSystemSettings();
      AppSettingsRepository.appSettings = AppSettingsModel.fromMap(data);

      // 5. Check login status
      final bool isLoggedIn = await getPrefrenceBool(isLogin);

      // 6. Initialize Firebase messaging
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(
          PushNotificationService.backgroundNotification,
        );
      }

      // 7. Return the main app with all providers
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<HomeProvider>(
            create: (_) => HomeProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<AddProductProvider>(
            create: (_) => AddProductProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<CountryProvider>(
            create: (_) => CountryProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<BrandProvider>(
            create: (_) => BrandProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<PickUpLocationProvider>(
            create: (_) => PickUpLocationProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<TaxProvider>(
            create: (_) => TaxProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<SettingProvider>(
            create: (_) => SettingProvider(sharedPreferences),
            lazy: true,
          ),
          ChangeNotifierProvider<LoginProvider>(
            create: (_) => LoginProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<ZipcodeProvider>(
            create: (_) => ZipcodeProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<CategoryProvider>(
            create: (_) => CategoryProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<AttributeProvider>(
            create: (_) => AttributeProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<MediaProvider>(
            create: (_) => MediaProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<SystemProvider>(
            create: (_) => SystemProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<ProductListProvider>(
            create: (_) => ProductListProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<ProfileProvider>(
            create: (_) => ProfileProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<ReviewListProvider>(
            create: (_) => ReviewListProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<SalesReportProvider>(
            create: (_) => SalesReportProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<FaQProvider>(
            create: (_) => FaQProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<EditProductProvider>(
            create: (_) => EditProductProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<WalletTransactionProvider>(
            create: (_) => WalletTransactionProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<StockProviderProvider>(
            create: (_) => StockProviderProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<AddPickUpLocationProvider>(
            create: (_) => AddPickUpLocationProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<CityProvider>(
            create: (_) => CityProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<PushNotificationProvider>(
            create: (_) => PushNotificationProvider(),
            lazy: true,
          ),
          ChangeNotifierProvider<AdvertisingPackageProvider>(
            create: (_) => AdvertisingPackageProvider(),
          ),
          BlocProvider(
            create: (_) => PersonalConverstationsCubit(ChatRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => GroupConversationsCubit(ChatRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => FetchOrdersCubit(OrdersRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => CreateConsignmentCubit(ConsignmentRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => FetchConsignmentsCubit(ConsignmentRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => SendPickUpRequestCubit(SendPickUpRepository()),
            lazy: true,
          ),
          BlocProvider(
            create: (_) => GenerateAWBCubit(GenerateAWBRepository()),
            lazy: true,
          ),
          BlocProvider<CountryCodeCubit>(
            create: (_) => CountryCodeCubit(),
            lazy: true,
          ),
          BlocProvider<LanguageCubit>(
            create: (_) => LanguageCubit(),
            lazy: true,
          ),
          BlocProvider<MakeMeOnlineCubit>(
            create: (context) => MakeMeOnlineCubit(ChatRepository()),
            lazy: true,
          ),
        ],
        child: MainAppContent(
          sharedPreferences: sharedPreferences,
          isLoggedIn: isLoggedIn,
        ),
      );
    } catch (e) {
      print('App initialization error: $e');
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Initialization Failed', style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _appFuture = _initializeApp();
                    });
                  },
                  child: Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _appFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show simple loading screen while initializing
          return MaterialApp(
            home: Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text('Initializing app...', style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text(
                  'Error loading app\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return snapshot.data ??
            MaterialApp(
              home: Scaffold(body: Center(child: Text('App failed to load'))),
            );
      },
    );
  }
}

// Main app content that decides whether to show Login or Dashboard
class MainAppContent extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final bool isLoggedIn;

  const MainAppContent({
    Key? key,
    required this.sharedPreferences,
    required this.isLoggedIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Decide which screen to show based on login status
    final initialScreen = isLoggedIn ? const Dashboard() : const Login();

    return MyApp(
      sharedPreferences: sharedPreferences,
      initialScreen: initialScreen,
    );
  }
}

// Your existing MyApp class, modified to accept initialScreen
// In main.dart, modify MyApp class
class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;
  final Widget? initialScreen; // Make it optional

  const MyApp({
    Key? key,
    required this.sharedPreferences,
    this.initialScreen, // Now optional
  }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLanguageLoaded = false;
  late Future<Widget> _initialScreenFuture;

  @override
  void initState() {
    globalSettingsProvider = SettingProvider(widget.sharedPreferences);

    // If initialScreen is provided, use it, otherwise calculate it
    if (widget.initialScreen != null) {
      _initialScreenFuture = Future.value(widget.initialScreen!);
    } else {
      _initialScreenFuture = _determineInitialScreen();
    }

    super.initState();
  }

  Future<Widget> _determineInitialScreen() async {
    try {
      final bool isLoggedIn = await getPrefrenceBool(isLogin);
      return isLoggedIn ? const Dashboard() : const Login();
    } catch (e) {
      return const Login(); // Fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) => FutureBuilder<Widget>(
        future: _initialScreenFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            );
          }

          final homeScreen = snapshot.data ?? const Login();

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: MaterialApp(
              builder: (context, child) {
                return AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: white,
                    systemNavigationBarIconBrightness: Brightness.dark,
                  ),
                  child: Scaffold(
                    backgroundColor: white,
                    body: SafeArea(bottom: true, top: false, child: child!),
                  ),
                );
              },
              title: appName,
              navigatorKey: rootNavigatorKey,
              theme: ThemeData(
                useMaterial3: false,
                primarySwatch: primary_app,
                fontFamily: 'opensans',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              locale: (languageState is LanguageLoader)
                  ? Locale(languageState.languageCode)
                  : Locale(defaultLanguageCode),
              supportedLocales: appLanguages
                  .map(
                    (language) =>
                        getLocaleFromLanguageCode(language.languageCode),
                  )
                  .toList(),
              localizationsDelegates: const [
                AppLocalization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              home: homeScreen,
            ),
          );
        },
      ),
    );
  }
}

class GlobalScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
