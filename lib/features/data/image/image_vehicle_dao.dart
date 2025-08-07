import 'package:projeto_704apps/features/models/ilist_images.dart';

abstract class ImageAnalyzeDao {
  Future<ListImages?> registerImageAnalysis(
    int userId,
    List<String> imagePaths,
    {required String token}
  );
}
