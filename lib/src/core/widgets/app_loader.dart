import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_template/src/core/providers/loading_provider.dart';

class AppLoader extends ConsumerWidget {
  final Widget child;

  const AppLoader({
    super.key,
    required this.child,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final isLoading =
        ref.watch(loadingProvider);

    return Stack(
      children: [
        child,

        if (isLoading)
          Positioned.fill(
            child: IgnorePointer(
              ignoring: false,
              child: Container(
                color: Colors.black.withValues(
                  alpha: 0.4,
                ),
                child: const Center(
                  child:
                      CircularProgressIndicator(),
                ),
              ),
            ),
          ),
      ],
    );
  }
}