import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_app_bar.dart';
import 'package:final_thesis_app/presentation/views/widgets/navigation/custom_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';




class MainView extends ConsumerStatefulWidget {
  final Widget innedWidget;
  const MainView({
    super.key,
    required this.innedWidget,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {

  @override
  Widget build(BuildContext context, ) {

    return Scaffold(
      appBar: CustomAppBar(),
      body: widget.innedWidget,
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}