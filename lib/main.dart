import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cat_cubit.dart';
import 'cubit/cat_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cat Gallery',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => CatCubit()..loadData(),
        child: const CatGalleryPage(),
      ),
    );
  }
}

class CatGalleryPage extends StatelessWidget {
  const CatGalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Лабораторная 6. Шепеленко Д.И.')),
      body: BlocBuilder<CatCubit, CatState>(
        builder: (context, state) {
          if (state is CatLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CatErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<CatCubit>().loadData(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (state is CatLoadedState) {
            return ListView.builder(
              itemCount: state.images.length,
              itemBuilder: (context, index) {
                final cat = state.images[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Image.network(
                        cat.url,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const SizedBox(
                            height: 200,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        },
                        errorBuilder: (context, error, stack) => const SizedBox(
                          height: 200,
                          child: Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('ID: ${cat.id}'),
                      ),
                    ],
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}