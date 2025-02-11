import 'package:chessmate/features/board/business/db/initial_board.dart';
import 'package:chessmate/features/board/business/entity/cell_entity.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ChessBoardDBHelper {
  static const _dbName = 'chessboard.db';
  static const _tableName = 'boardCells';

  // Method to get the database instance
  static Future<Database> getDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      return openDatabase(
        join(dbPath, _dbName),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE $_tableName (cellPosition INTEGER PRIMARY KEY, hasPiece INTEGER, pieceId TEXT)',
          );
        },
        version: 1,
      );
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  // Insert cells into the database
  static Future<void> insertBoardCells(List<BoardCellEntity> cells) async {
    final db = await getDatabase();
    await db.transaction((txn) async {
      for (var cell in cells) {
        await txn.insert(
          _tableName,
          cell.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  // Fetch all board cells
  static Future<List<BoardCellEntity>> getBoardCells() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);
    return maps.map((map) => BoardCellEntity.fromMap(map)).toList();
  }

  // Fetch or initialize the board if the database is empty
  static Future<List<BoardCellEntity>> getOrInitializeBoard() async {
    final db = await getDatabase();
    final List<Map<String, dynamic>> maps = await db.query(_tableName);

    if (maps.isEmpty) {
      final initialCells = generateInitialBoard();
      await insertBoardCells(initialCells);
      return initialCells;
    }

    return maps.map((map) => BoardCellEntity.fromMap(map)).toList();
  }

  // Reset the board to its initial state
  static Future<void> resetBoard(List<BoardCellEntity> initialCells) async {
    final db = await getDatabase();
    await db.delete(_tableName);
    await insertBoardCells(initialCells);
  }
}
