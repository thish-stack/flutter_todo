// database_queries.dart

import 'database_constants.dart';

class DatabaseQueries {
  // Initialization script to create the tasks table
  static final List<String> initialScript = [
    '''CREATE TABLE ${DatabaseConstants.tableName} (
      ${DatabaseConstants.columnId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DatabaseConstants.columnApiId} TEXT, 
      ${DatabaseConstants.columnName} TEXT,
      ${DatabaseConstants.columnCompleted} INTEGER,
      ${DatabaseConstants.columnDate} TEXT,
      ${DatabaseConstants.columnDescription} TEXT);
      '''
  ];

  // Migration scripts to alter the tasks table
  static final List<String> migrations = [
    '''ALTER TABLE ${DatabaseConstants.tableName} ADD COLUMN ${DatabaseConstants.columnDescription} TEXT''',
    '''ALTER TABLE ${DatabaseConstants.tableName} ADD COLUMN ${DatabaseConstants.columnApiId} TEXT'''
  ];
}
