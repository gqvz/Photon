import 'dart:async';

import 'package:flutter/material.dart';

class ImagesPage extends StatefulWidget {
  const ImagesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ImagesPageState();
}

class _ImagesPageState extends State<ImagesPage> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> albums = List.generate(
    20,
    (index) => {
      "image": "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
      "name": "Album ${index + 1}",
      "subtitle": "Subtitle ${index + 1}",
    },
  );

  final List<String> mockPhotos = List.generate(
    50,
    (index) => "https://avatars.githubusercontent.com/u/70444445?s=1024&v=4",
  );

  bool showAlbums = true;
  String currentAlbumName = "";
  Set<int> selectedPhotos = {};
  bool isSelecting = false;
  bool isDragging = false;
  int? startIndex;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Widget buildAlbumsGrid() {
    return GridView.builder(
      primary: true,
      padding: const EdgeInsets.all(10),
      itemCount: albums.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 8,
        childAspectRatio: 0.76,
      ),
      itemBuilder: (context, index) {
        final album = albums[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              showAlbums = false;
              currentAlbumName = album["name"]!;
            });
          },
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Delete Album'),
                  content: const Text(
                    'Are you sure you want to delete this album? This action cannot be undone.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          albums.removeAt(index);
                        });
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth;
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: <Widget>[
                        Container(
                          height: size,
                          width: size,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(album["image"]!),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 8,
                          right: 8,
                          child: ClipOval(
                            child: Image.network(
                              album["image"]!,
                              width: 32,
                              height: 32,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 6),
              Text(
                album["name"]!,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                album["subtitle"]!,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildPhotoGrid() {
    return WillPopScope(
      onWillPop: () async {
        if (isSelecting) {
          setState(() {
            isSelecting = false;
            selectedPhotos.clear();
          });
          return false;
        }
        setState(() {
          showAlbums = true;
        });
        return false;
      },
      child: Column(
        children: [
          Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        currentAlbumName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isSelecting) ...[
                        const SizedBox(width: 8),
                        Text(
                          '(${selectedPhotos.length})',
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelecting) ...[
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete ${selectedPhotos.length} Photos'),
                          content: Text(
                            'Are you sure you want to delete ${selectedPhotos.length} selected photos? This action cannot be undone.',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  isSelecting = false;
                                  selectedPhotos.clear();
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        isSelecting = false;
                        selectedPhotos.clear();
                      });
                    },
                  ),
                ],
              ],
            ),
          ),
          Expanded(
            child: Listener(
              onPointerMove: (PointerMoveEvent event) {
                if (!isDragging) return;

                final RenderBox box = context.findRenderObject() as RenderBox;
                final localPosition = box.globalToLocal(event.position);

                final double itemWidth = (box.size.width - 40) / 4;
                final double itemHeight = itemWidth;

                // Get the scroll offset
                final double scrollOffset = _scrollController.offset;

                final int col =
                    ((localPosition.dx - 8) / (itemWidth + 8)).floor();
                // Add scroll offset to y-position calculation
                // account for the very top text
                final int row =
                    ((localPosition.dy - 80 + scrollOffset) / (itemHeight + 8))
                        .floor();

                if (col >= 0 && col < 4 && row >= 0) {
                  final int currentIndex = (row * 4) + col;
                  if (currentIndex >= 0 && currentIndex < mockPhotos.length) {
                    setState(() {
                      //selectedPhotos.clear();
                      final range = [startIndex!, currentIndex];
                      range.sort();
                      for (int i = range[0]; i <= range[1]; i++) {
                        selectedPhotos.add(i);
                      }
                    });
                  }
                }
              },
              onPointerUp: (PointerUpEvent event) {
                setState(() {
                  isDragging = false;
                });
              },
              child: GridView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(8),
                itemCount: mockPhotos.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final isSelected = selectedPhotos.contains(index);
                  return GestureDetector(
                    onTap: () {
                      if (isSelecting) {
                        setState(() {
                          if (isSelected) {
                            selectedPhotos.remove(index);
                            if (selectedPhotos.isEmpty) {
                              isSelecting = false;
                            }
                          } else {
                            selectedPhotos.add(index);
                          }
                        });
                      }
                    },
                    onLongPressStart: (details) {
                      setState(() {
                        isSelecting = true;
                        isDragging = true;
                        startIndex = index;
                        //selectedPhotos.clear();
                        selectedPhotos.add(index);
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: isSelected
                            ? Border.all(color: Colors.blue, width: 2)
                            : null,
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              mockPhotos[index],
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                          if (isSelected) ...[
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                            const Positioned(
                              top: 4,
                              right: 4,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: showAlbums ? buildAlbumsGrid() : buildPhotoGrid(),
    );
  }
}
