import 'package:snake/models/direction.dart';
import 'package:snake/models/position.dart';

class Snake {
  final List<Position> body;
  final Direction direction;

  const Snake({required this.body, required this.direction});

  Position get head => body.first;

  Snake move() {
    final newHead = _getNextHeadPosition();
    final newBody = [newHead, ...body.sublist(0, body.length - 1)];

    return Snake(body: newBody, direction: direction);
  }

  Snake grow() {
    final newHead = _getNextHeadPosition();
    final newBody = [newHead, ...body];

    return Snake(body: newBody, direction: direction);
  }

  Snake changeDirection(Direction newDirection) {
    if (_isOppositeDirection(newDirection)) {
      return this;
    }

    return Snake(body: body, direction: newDirection);
  }

  bool checkSelfCollision() {
    final head = this.head;
    return body.skip(1).any((segment) => segment == head);
  }

  Position _getNextHeadPosition() {
    final currentHead = head;

    switch (direction) {
      case Direction.up:
        return Position(x: currentHead.x, y: currentHead.y - 1);
      case Direction.down:
        return Position(x: currentHead.x, y: currentHead.y + 1);
      case Direction.left:
        return Position(x: currentHead.x - 1, y: currentHead.y);
      case Direction.right:
        return Position(x: currentHead.x + 1, y: currentHead.y);
    }
  }

  bool _isOppositeDirection(Direction newDirection) {
    switch (direction) {
      case Direction.up:
        return newDirection == Direction.down;
      case Direction.down:
        return newDirection == Direction.up;
      case Direction.left:
        return newDirection == Direction.right;
      case Direction.right:
        return newDirection == Direction.left;
    }
  }
}
