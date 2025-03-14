import 'package:final_thesis_app/views/widgets/navigation/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/services/authentication/providers/user_id.dart';
import '../app/storage/user/user_payload_provider.dart';
import '../app/theme/theme.dart';
import '../configurations/strings.dart';



class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  final List<Widget> screens = [];

  @override
  Widget build(BuildContext context, ) {

    return Scaffold(
      appBar: CustomAppBar(),
      // drawer: const Menu(),
      body: Column(
      ),
    );
  }
}