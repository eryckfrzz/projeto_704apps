import 'package:projeto_704apps/features/models/image_profile.dart';

abstract class ImageProfileDao {
  Future<ImageProfile?> registerImageProfile(
    int userId,
    String file, {
    required String token,
  });
}
