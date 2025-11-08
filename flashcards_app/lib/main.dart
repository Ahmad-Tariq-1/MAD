import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const FlashcardApp());

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAAD Quiz 3 – Flashcards',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const FlashcardHome(),
    );
  }
}

class Flashcard {
  String question;
  String answer;
  bool learned;
  Flashcard(this.question, this.answer, {this.learned = false});
}

class FlashcardHome extends StatefulWidget {
  const FlashcardHome({super.key});

  @override
  State<FlashcardHome> createState() => _FlashcardHomeState();
}

class _FlashcardHomeState extends State<FlashcardHome> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final Random _rand = Random();
  final List<Flashcard> _cards = [
    Flashcard('What is Flutter?', 'A UI toolkit for building cross-platform apps.'),
    Flashcard('What language does Flutter use?', 'Dart'),
    Flashcard('Who develops Flutter?', 'Google'),
    Flashcard('Widget for scrollable list?', 'ListView'),
    Flashcard('Use of setState()?', 'To rebuild UI when state changes.')
  ];

  int get learnedCount => _cards.where((c) => c.learned).length;

  Future<void> _refreshCards() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      for (var c in _cards) {
        c.learned = false;
      }
      _cards.shuffle();
    });
  }

  void _addCard() {
    final newCard = Flashcard(
      'New Question ${_rand.nextInt(100)}',
      'New Answer ${_rand.nextInt(100)}',
    );
    _cards.insert(0, newCard);
    _listKey.currentState?.insertItem(0);
  }

  void _markLearned(int index) {
    setState(() {
      _cards[index].learned = true;
      final removed = _cards.removeAt(index);
      _listKey.currentState?.removeItem(
        index,
            (context, animation) => SizeTransition(
          sizeFactor: animation,
          child: _buildCard(removed, index),
        ),
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  void _toggleAnswer(Flashcard card) {
    setState(() => card.learned = !card.learned);
  }

  Widget _buildCard(Flashcard card, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Dismissible(
        key: ValueKey(card.question),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.green,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 16),
          child: const Icon(Icons.check, color: Colors.white),
        ),
        onDismissed: (_) => _markLearned(index),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            title: Text(
              card.question,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: AnimatedCrossFade(
              duration: const Duration(milliseconds: 250),
              firstChild: const SizedBox.shrink(),
              secondChild: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(card.answer,
                    style: const TextStyle(color: Colors.indigo)),
              ),
              crossFadeState: card.learned
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            onTap: () => _toggleAnswer(card),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addCard,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCards,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Learned: $learnedCount / ${_cards.length}'),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo, Colors.blueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: AnimatedList(
                key: _listKey,
                initialItemCount: _cards.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index, animation) {
                  final card = _cards[index];
                  return SizeTransition(
                    sizeFactor: animation,
                    child: _buildCard(card, index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
