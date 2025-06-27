import 'package:projeto_704apps/features/models/image.dart';

abstract class ImageAnalyzeDao {
  Future<Image?> registerImageAnalysis(
    List<String> imagePaths,
    String audioTranscriptionId,
    {required String token}
  );
}
