import 'dart:io';

import 'package:rapidito/src/data/dataSource/remote/service/UsersService.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'package:rapidito/src/domain/repository/UsersRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';

class UsersRepositoryImpl implements UsersRepository {
  final UsersService usersService;
  UsersRepositoryImpl(this.usersService);

  @override
  Future<Resource<User>> update(int id, User user, File? file) {
    return usersService.update(id, user, file);
  }
}
