import 'package:deskdose/features/posture/presentation/bloc/posture_bloc.dart';
import 'package:deskdose/features/routines/presentation/widgets/routine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PosturePage extends StatefulWidget {
  const PosturePage({super.key});

  @override
  State<PosturePage> createState() => _PosturePageState();
}

class _PosturePageState extends State<PosturePage> {
  @override
  void initState() {
    super.initState();
    context.read<PostureBloc>().add(const LoadPostureRoutinesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posture')),
      body: BlocBuilder<PostureBloc, PostureState>(
        builder: (context, state) {
          return switch (state) {
            PostureLoading() || PostureInitial() =>
              const Center(child: CircularProgressIndicator()),
            PostureError(:final message) => Center(child: Text(message)),
            PostureLoaded(:final routines) => routines.isEmpty
                ? const Center(child: Text('No posture routines yet.'))
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: routines.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => RoutineCard(
                      routine: routines[i],
                      onTap: () {},
                    ),
                  ),
          };
        },
      ),
    );
  }
}
