import 'package:bolt/features/Auth/data/datasources/auth_remote_datasource.dart';
import 'package:bolt/features/Auth/data/repositories/auth_repository_impl.dart';
import 'package:bolt/features/Auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:bolt/features/Auth/domain/usecases/login_usecase.dart';
import 'package:bolt/features/Auth/domain/usecases/register_usecase.dart';
import 'package:bolt/features/Auth/presentation/cubit/auth_cubit.dart';
import 'package:bolt/features/Splash_screen/splash_screen.dart';
import 'package:bolt/core/network/api_client.dart';
import 'package:bolt/core/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tokenService = TokenService();
    final apiClient = ApiClient(tokenService: tokenService);
    final repository = AuthRepositoryImpl(
      AuthRemoteDatasource(apiClient),
      tokenService,
    );

    return BlocProvider<AuthCubit>(
      create: (_) => AuthCubit(
        loginUsecase: LoginUsecase(repository),
        registerUsecase: RegisterUsecase(repository),
        googleSignInUsecase: GoogleSignInUsecase(repository),
        tokenService: tokenService,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Bolt',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          textTheme: GoogleFonts.soraTextTheme(
            Theme.of(context).textTheme,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
