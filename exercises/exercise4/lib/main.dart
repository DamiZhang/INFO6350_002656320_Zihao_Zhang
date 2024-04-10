import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MainScreen()));

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Two Hero Animations'),
      ),
      body: Column(
        children: <Widget>[
          GestureDetector(
            child: Hero(
              tag: 'standardHero',
              child: Image.network(
                'https://picsum.photos/id/237/200/300',
                width: 100.0,
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreen(
                  tag: 'standardHero',
                  imageUrl: 'https://picsum.photos/id/237/200/300',
                );
              }));
            },
          ),
          GestureDetector(
            child: Hero(
              tag: 'radialHero',
              child: ClipOval(
                child: Image.network(
                  'https://picsum.photos/id/1005/200/300',
                  width: 100.0,
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return DetailScreen(
                  tag: 'radialHero',
                  imageUrl: 'https://picsum.photos/id/1005/200/300',
                  isRadial: true,
                );
              }));
            },
          ),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String tag;
  final String imageUrl;
  final bool isRadial;

  const DetailScreen({
    Key? key,
    required this.tag,
    required this.imageUrl,
    this.isRadial = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hero Detail'),
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: isRadial
              ? ClipRect(  // Used ClipRect here for simplicity to simulate radial to rectangular transition.
                  child: Image.network(imageUrl),
                )
              : Image.network(imageUrl),
        ),
      ),
    );
  }
}
