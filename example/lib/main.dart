import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'ImageBuilder Package Example'),
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
  final ImagePicker _picker = ImagePicker();
  File? _selectedImageFromGallery;
  File? _pickedFile;
  Uint8List? _webPickedFileBytes;
  String? _pickedFileName;
  bool _isPickingFile = false;

  /// Helper method to load asset as bytes for memory image demonstration
  Future<Uint8List> _loadAssetAsBytes(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    return byteData.buffer.asUint8List();
  }

  /// Check if current platform is mobile (iOS or Android)
  bool get _isMobile => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

  /// Check if current platform is desktop or web
  bool get _isDesktopOrWeb => kIsWeb || Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// Pick file using file_picker (works on all platforms)
  Future<void> _pickFile() async {
    if (_isPickingFile) return;
    
    setState(() {
      _isPickingFile = true;
    });

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        if (kIsWeb) {
          // On web, we get bytes instead of file paths
          setState(() {
            _webPickedFileBytes = result.files.single.bytes;
            _pickedFileName = result.files.single.name;
            _pickedFile = null;
            _isPickingFile = false;
          });
        } else {
          // On mobile/desktop, we get file paths
          setState(() {
            _pickedFile = File(result.files.single.path!);
            _pickedFileName = result.files.single.name;
            _webPickedFileBytes = null;
            _isPickingFile = false;
          });
        }
      } else {
        setState(() {
          _isPickingFile = false;
        });
      }
    } catch (e) {
      setState(() {
        _isPickingFile = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
    }
  }

  /// Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _selectedImageFromGallery = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image from gallery: $e')),
        );
      }
    }
  }



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
                      const MyHomePage(title: 'ImageBuilder Package Example'),
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
              'Large Image for Slow Loading Example',
              ImageBuilder(
                'https://picsum.photos/2000/1500?random=2', 
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
            
            _buildSectionHeader('Memory Images'),
            const SizedBox(height: 16),
            _buildTestCase(
              'Image from Memory Bytes (Uint8List)',
              FutureBuilder<Uint8List>(
                future: _loadAssetAsBytes('assets/images/photo.jpg'),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ImageBuilder.memory(
                      snapshot.data!,
                      width: 200,
                      height: 150,
                      fit: BoxFit.cover,
                    );
                  } else if (snapshot.hasError) {
                    return Container(
                      width: 200,
                      height: 150,
                      color: Colors.red[100],
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error, color: Colors.red),
                          Text('Failed to load memory image'),
                        ],
                      ),
                    );
                  }
                  return Container(
                    width: 200,
                    height: 150,
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 32),
            
            _buildSectionHeader('Device Images (File Constructor)'),
            const SizedBox(height: 16),
            
            // Platform-specific card - File picker for Desktop/Web
            if (_isDesktopOrWeb)
              _buildTestCase(
                'Pick Image File (Desktop & Web)',
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isPickingFile ? null : _pickFile,
                      icon: _isPickingFile 
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.folder_open),
                      label: Text(_isPickingFile ? 'Picking File...' : 'Pick Image File'),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kIsWeb ? 'Web File Picker' : 'Desktop File Picker',
                      style: const TextStyle(fontSize: 11, color: Colors.blue),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (_pickedFile != null || _webPickedFileBytes != null)
                      Column(
                        children: [
                          // For non-web platforms (desktop) use File
                          if (_pickedFile != null && !kIsWeb)
                            ImageBuilder.file(
                              _pickedFile!,
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          // For web platform use memory (since File doesn't work on web)
                          if (_webPickedFileBytes != null && kIsWeb)
                            ImageBuilder.memory(
                              _webPickedFileBytes!,
                              width: 200,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'File: ${_pickedFileName ?? 'Unknown'}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            kIsWeb ? '(Using ImageBuilder.memory)' : '(Using ImageBuilder.file)',
                            style: const TextStyle(fontSize: 10, color: Colors.blue),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.folder_open, size: 40, color: Colors.blue),
                            SizedBox(height: 8),
                            Text('Click to pick image file', 
                                 style: TextStyle(color: Colors.blue, fontSize: 12),
                                 textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

            // Platform-specific card - Gallery picker for Mobile
            if (_isMobile)
              _buildTestCase(
                'Choose from Gallery (Mobile)',
                Column(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickImageFromGallery,
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Choose from Gallery'),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Mobile Gallery Access',
                      style: TextStyle(fontSize: 11, color: Colors.green),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedImageFromGallery != null)
                      Column(
                        children: [
                          ImageBuilder.file(
                            _selectedImageFromGallery!,
                            width: 200,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'File: ${_selectedImageFromGallery!.path.split('/').last}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const Text(
                            '(Using ImageBuilder.file)',
                            style: TextStyle(fontSize: 10, color: Colors.green),
                          ),
                        ],
                      )
                    else
                      Container(
                        width: 200,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green, style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library, size: 40, color: Colors.green),
                            SizedBox(height: 8),
                            Text('Choose from gallery', 
                                 style: TextStyle(color: Colors.green, fontSize: 12),
                                 textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                  ],
                ),
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
