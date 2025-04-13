import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/di/service_locator.dart';
import 'core/router/app_router.dart';
import 'core/services/google_maps_services.dart';
import 'core/theme/app_theme.dart';
import 'presentation/blocs/location/location_bloc.dart';
import 'presentation/blocs/ride/ride_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GoogleMapsService.initGoogleMaps();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LocationBloc>(
          create: (_) => sl<LocationBloc>(),
          lazy: false,
        ),
        BlocProvider<RideBloc>(
          create: (_) => sl<RideBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Ride Booking App',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
