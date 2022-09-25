import 'package:mysql1/mysql1.dart';

class Mysql {
  static String host = 'leonardhors.site',
      user = 'u1581595_tester',
      password = 'UtG.femt9q~b',
      db = 'u1581595_mi_fik';
  static int port = 3306;

  Mysql();

  Future<MySqlConnection> getConnection() async {
    var settings = ConnectionSettings(
        host: host, port: port, user: user, password: password, db: db);
    return await MySqlConnection.connect(settings);
  }
}
