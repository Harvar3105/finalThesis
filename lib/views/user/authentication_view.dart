import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/services/authentication/providers/login_state.dart';
import '../../app/state/is_loading.dart';
import '../main_view.dart';
import '../widgets/animations/loading/loading_screen.dart';
import 'login_view.dart';

// class AuthenticationView extends StatelessWidget {
//   const AuthenticationView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (context, ref, child) {
//         ref.listen<bool>(isLoadingProvider, (_, isLoading) {
//           if (isLoading) {
//             LoadingScreen.instance().show(context: context);
//           } else {
//             LoadingScreen.instance().hide();
//           }
//         });
//
//         final isLoggedIn = ref.watch(isLoggedInProvider);
//         if (isLoggedIn) {
//           return const MainView();
//         } else {
//           return const LoginView();
//         }
//       },
//     );
//   }
// }