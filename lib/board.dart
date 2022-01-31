import 'package:boxes/cell.dart';
import 'package:boxes/game_controller_cubit.dart';
import 'package:boxes/player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    final idx =
        List.generate(gameController.state.board.length, (index) => index);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _getColorFromPlayer(gameController.state.playerTurn),
        title: Text(
            'now ${gameController.state.playerTurn} - ${gameController.state.score.toString()} - ${gameController.state.winner ?? 'ngm'} ganhou'),
      ),
      body: Container(
        color: const Color(0xFF080F0F),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxSize = constraints.maxHeight < constraints.maxWidth
                ? constraints.maxHeight
                : constraints.maxWidth;
            return Center(
              child: SizedBox(
                height: maxSize,
                width: maxSize,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: idx
                      .map(
                        (rowIndex) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: idx
                              .map(
                                (columnIndex) => _buildCell(
                                  rowIndex,
                                  columnIndex,
                                  gameController.state.board,
                                  maxSize: maxSize,
                                  onTap: () {
                                    context.read<GameController>().doPlay(
                                          gameController.state.playerTurn,
                                          rowIndex,
                                          columnIndex,
                                        );
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCell(int rowIndex, int columnIndex, List<List<Cell>> board,
      {VoidCallback? onTap, required double maxSize}) {
    Widget? child;

    final player = board[rowIndex][columnIndex].player;
    final boardSize = board.length;

    final hItemsCount = (boardSize / 2).ceil();
    final vItemsCount = (boardSize / 2).floor();

    final hItemsHeigth = maxSize * 0.2 / hItemsCount.toDouble();
    final vItemsHeigth = maxSize * 0.8 / vItemsCount;

    final vItemsWidth = hItemsHeigth;
    final hItemsWidth = vItemsHeigth;

    if (rowIndex % 2 == 0) {
      if (columnIndex % 2 == 0) {
        child = Container(
          margin: const EdgeInsets.all(10),
          height: vItemsWidth - 20,
          width: vItemsWidth - 20,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(vItemsWidth),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade100,
                spreadRadius: 0,
                blurRadius: 10,
              ),
              BoxShadow(
                color: Colors.grey.shade100,
                spreadRadius: -5,
                blurRadius: 25,
              )
            ],
          ),
        );
      } else {
        child = MouseRegion(
          cursor: player == Player.none
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              margin: const EdgeInsets.all(5),
              height: hItemsHeigth - 10,
              width: hItemsWidth - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(vItemsWidth),
                boxShadow: player == Player.none
                    ? null
                    : [
                        BoxShadow(
                          color: _getColorFromPlayer(player),
                          spreadRadius: 0,
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: _getColorFromPlayer(player),
                          spreadRadius: -5,
                          blurRadius: 25,
                        )
                      ],
                color: _getColorFromPlayer(player),
              ),
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 150),
            ),
          ),
        );
      }
    } else {
      if (columnIndex % 2 == 0) {
        child = MouseRegion(
          cursor: player == Player.none
              ? SystemMouseCursors.click
              : SystemMouseCursors.forbidden,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              margin: const EdgeInsets.all(5),
              height: vItemsHeigth - 10,
              width: vItemsWidth - 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(vItemsWidth),
                boxShadow: player == Player.none
                    ? null
                    : [
                        BoxShadow(
                          color: _getColorFromPlayer(player),
                          spreadRadius: 0,
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: _getColorFromPlayer(player),
                          spreadRadius: -5,
                          blurRadius: 25,
                        )
                      ],
                color: _getColorFromPlayer(player),
              ),
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 250),
            ),
          ),
        );
      }
    }

    final panelColor = player == Player.none
        ? Colors.transparent
        : _getColorFromPlayer(player);
    child ??= AnimatedContainer(
      margin: const EdgeInsets.all(5),
      height: vItemsHeigth - 10,
      width: hItemsWidth - 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(vItemsWidth / 2),
        boxShadow: [
          BoxShadow(
            color: panelColor,
            spreadRadius: 0,
            blurRadius: 10,
          ),
          BoxShadow(
            color: panelColor,
            spreadRadius: -5,
            blurRadius: 25,
          )
        ],
        color: panelColor,
      ),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    return child;
  }

  Color _getColorFromPlayer(Player player) {
    if (player == Player.red) {
      return const Color(0xFFCA2E55);
    }
    if (player == Player.blue) {
      return const Color(0xFF54C6EB);
    }

    return Colors.blueGrey.shade900.withAlpha(80);
  }
}
