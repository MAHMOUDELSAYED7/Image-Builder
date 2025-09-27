import 'package:flutter/material.dart';
import 'package:image_builder/image_builder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImageBuilder Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ImageBuilderExample(),
    );
  }
}

class ImageBuilderExample extends StatelessWidget {
  const ImageBuilderExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ImageBuilder Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Network Images'),
            const SizedBox(height: 10),
            _buildNetworkImageExamples(),
            const SizedBox(height: 30),
            _buildSectionTitle('Error Handling'),
            const SizedBox(height: 10),
            _buildErrorHandlingExample(),
            const SizedBox(height: 30),
            _buildSectionTitle('Size Variations'),
            const SizedBox(height: 10),
            _buildSizeVariations(),
            const SizedBox(height: 30),
            _buildSectionTitle('Custom Placeholders'),
            const SizedBox(height: 10),
            _buildCustomPlaceholderExample(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.deepPurple,
      ),
    );
  }

  Widget _buildNetworkImageExamples() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageBuilder(
                  'https://picsum.photos/150/150?random=1',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: ImageBuilder(
                  'https://picsum.photos/150/150?random=2',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Two network images loaded with caching',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildErrorHandlingExample() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ImageBuilder(
                'https://invalid-url-that-will-fail.com/image.jpg',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.red.shade50,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 40),
                      SizedBox(height: 8),
                      Text('Failed to load',
                          style: TextStyle(color: Colors.red, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ImageBuilder(
                'assets/non_existent_image.png',
                width: 150,
                height: 150,
                fit: BoxFit.cover,
                errorWidget: Container(
                  color: Colors.orange.shade50,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.image_not_supported,
                          color: Colors.orange, size: 40),
                      SizedBox(height: 8),
                      Text('Asset not found',
                          style: TextStyle(color: Colors.orange, fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Error handling with custom error widgets',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSizeVariations() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ImageBuilder(
                  'https://picsum.photos/100/100?random=3',
                  size: 50,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                const Text('50x50', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ImageBuilder(
                  'https://picsum.photos/100/100?random=4',
                  size: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                const Text('80x80', style: TextStyle(fontSize: 12)),
              ],
            ),
            Column(
              children: [
                ImageBuilder(
                  'https://picsum.photos/120/80?random=5',
                  width: 120,
                  height: 80,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                const Text('120x80', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const Text(
          'Different size configurations',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCustomPlaceholderExample() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageBuilder(
              'https://picsum.photos/200/120?random=6',
              width: 200,
              height: 120,
              fit: BoxFit.cover,
              placeholder: Container(
                color: Colors.blue.shade50,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.blue),
                    SizedBox(height: 8),
                    Text('Loading...', style: TextStyle(color: Colors.blue)),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Custom loading placeholder (refresh to see)',
          style: TextStyle(color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
