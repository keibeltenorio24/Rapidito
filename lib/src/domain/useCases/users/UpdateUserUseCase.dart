import 'package:rapidito/src/domain/repository/UsersRepository.dart';
import 'package:rapidito/src/domain/utils/Resource.dart';
import 'package:rapidito/src/domain/models/user.dart';
import 'dart:io';

class UpdateUserUseCase {
  UsersRepository usersRepository;

  UpdateUserUseCase(this.usersRepository);

  Future<Resource<User>> run(int id, User user, File? file) =>
      usersRepository.update(id, user, file);
}
