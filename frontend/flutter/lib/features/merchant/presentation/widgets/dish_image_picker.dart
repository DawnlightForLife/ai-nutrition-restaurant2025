import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DishImagePicker extends ConsumerStatefulWidget {
  final String? dishId;
  final List<String>? initialImages;
  final Function(List<dynamic>) onImagesChanged;
  final int maxImages;

  const DishImagePicker({
    Key? key,
    this.dishId,
    this.initialImages,
    required this.onImagesChanged,
    this.maxImages = 10,
  }) : super(key: key);

  @override
  ConsumerState<DishImagePicker> createState() => _DishImagePickerState();
}

class _DishImagePickerState extends ConsumerState<DishImagePicker> {
  final ImagePicker _picker = ImagePicker();
  List<dynamic> _images = []; // Can contain File or String (URL)

  @override
  void initState() {
    super.initState();
    if (widget.initialImages != null) {
      _images = List.from(widget.initialImages!);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    if (_images.length >= widget.maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('最多只能上传${widget.maxImages}张图片')),
      );
      return;
    }

    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
        widget.onImagesChanged(_images);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败：$e')),
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
    widget.onImagesChanged(_images);
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('拍照'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('从相册选择'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image grid
        if (_images.isNotEmpty) ...[
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return _buildImageItem(_images[index], index);
              },
            ),
          ),
          const SizedBox(height: 12),
        ],

        // Add image button
        if (_images.length < widget.maxImages)
          OutlinedButton.icon(
            onPressed: _showImageSourceDialog,
            icon: const Icon(Icons.add_photo_alternate),
            label: Text('添加图片 (${_images.length}/${widget.maxImages})'),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(dynamic image, int index) {
    Widget imageWidget;
    
    if (image is File) {
      imageWidget = Image.file(
        image,
        fit: BoxFit.cover,
      );
    } else if (image is String) {
      imageWidget = CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(),
        ),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
    } else {
      return const SizedBox.shrink();
    }

    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 120,
              width: 120,
              color: Colors.grey[100],
              child: imageWidget,
            ),
          ),
          // Primary image indicator
          if (index == 0)
            Positioned(
              left: 4,
              top: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  '主图',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Delete button
          Positioned(
            right: 4,
            top: 4,
            child: InkWell(
              onTap: () => _removeImage(index),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}