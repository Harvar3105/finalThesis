

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