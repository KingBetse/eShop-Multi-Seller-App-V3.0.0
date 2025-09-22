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
import 'Screen/SplashScreen/splashScreen.dart';

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
  debugProfileBuildsEnabled = true; // Add this
  // Show splash screen IMMEDIATELY
  runApp(const SplashLoader());

  // Then initialize everything in background
  await _initializeApp();
}

Future<void> _initializeApp() async {
  try {
    // Basic UI configuration (fast)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    // Get shared preferences first (relatively fast)
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Initialize Firebase
    if (Firebase.apps.isNotEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } else {
      await Firebase.initializeApp();
    }

    // Initialize Hive (can be slower)
    await Hive.initFlutter();
    await HiveRepository.init();

    HttpOverrides.global = MyHttpOverrides();

    if (!kIsWeb) {
      FirebaseMessaging.onBackgroundMessage(
        PushNotificationService.backgroundNotification,
      );
    }

    // Now run the actual app with all providers
    runApp(
      MultiProvider(
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
        child: MyApp(sharedPreferences: sharedPreferences),
      ),
    );
  } catch (e) {
    print('Initialization error: $e');
    // Fallback to error app if initialization fails
    runApp(const ErrorApp());
  }
}

// Simple splash screen loader
class SplashLoader extends StatelessWidget {
  const SplashLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading...', style: TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}

// Error fallback app
class ErrorApp extends StatelessWidget {
  const ErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            'App loading failed\nPlease restart the app',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}

//to get token without using context
SettingProvider? globalSettingsProvider;
GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({Key? key, required this.sharedPreferences}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLanguageLoaded = false;

  @override
  void initState() {
    globalSettingsProvider = SettingProvider(widget.sharedPreferences);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isLanguageLoaded) {
      context.read<LanguageCubit>().loadCurrentLanguage();
      _isLanguageLoaded = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      builder: (context, languageState) => GestureDetector(
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
                (language) => getLocaleFromLanguageCode(language.languageCode),
              )
              .toList(),
          localizationsDelegates: const [
            AppLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          home: const SplashScreen(),
        ),
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
