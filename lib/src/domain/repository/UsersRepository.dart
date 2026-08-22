import 'dart:io';

import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

abstract class UsersRepository {
  Future<Resource<User>> update(int id, User user, File? file);
}
