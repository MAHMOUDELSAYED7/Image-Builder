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
      title: 'ImageBuilder Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ImageBuilder Package Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      const MyHomePage(title: 'ImageBuilder Package Test'),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            tooltip: 'Refresh Images',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildSectionHeader('Network Images'),
            const SizedBox(height: 16),
            _buildTestCase(
              'Standard Network Image',
              ImageBuilder(
                'https://picsum.photos/200/200?random=1',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                useAdaptiveLoading: true,
                errorWidget: Container(
                  width: 200,
                  height: 200,
                  color: Colors.red[100],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 32),
                      SizedBox(height: 8),
                      Text('Failed to load', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            _buildSectionHeader('Large Network Image'),
            const SizedBox(height: 16),
            _buildTestCase(
              'Large Image for Slow Loading Demo',
              ImageBuilder(
                'https://picsum.photos/2000/1500?random=2', // Very large image
                width: 250,
                height: 180,
                fit: BoxFit.cover,
                useAdaptiveLoading: true,
                loadingColor: Colors.blue,
                errorWidget: Container(
                  width: 250,
                  height: 180,
                  color: Colors.blue[100],
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.blue, size: 32),
                      SizedBox(height: 8),
                      Text('Large image failed', style: TextStyle(fontSize: 10, color: Colors.blue)),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
            
            _buildSectionHeader('SVG Images'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    ImageBuilder(
                      'assets/icons/android.svg',
                      size: 60,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 4),
                    const Text('Blue Android', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Column(
                  children: [
                    ImageBuilder(
                      'assets/icons/github.svg',
                      size: 60,
                    ),
                    const SizedBox(height: 4),
                    const Text('GitHub Original', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),
            
            _buildSectionHeader('Local Images'),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    _buildTestCase(
                      'Local JPG',
                      ImageBuilder(
                        'assets/images/file_formats.jpg',
                        width: 150,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildTestCase(
                      'Local PNG',
                      ImageBuilder(
                        'assets/images/rectangle.png',
                        width: 150,
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),
            
            _buildSectionHeader('Error Handling'),
            const SizedBox(height: 16),
            _buildTestCase(
              'Non-existent Image URL',
              ImageBuilder(
                'https://this-does-not-exist.com/image.jpg',
                width: 150,
                height: 150,
                errorWidget: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    border: Border.all(color: Colors.orange, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.orange, size: 32),
                      SizedBox(height: 8),
                      Text(
                        'Error loading image',
                        style: TextStyle(fontSize: 10, color: Colors.orange),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple,
        ),
      ),
    );
  }

  Widget _buildTestCase(String title, Widget imageWidget) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: imageWidget,
          ),
        ),
      ],
    );
  }
}
