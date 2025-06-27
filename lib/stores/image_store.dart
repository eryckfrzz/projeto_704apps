import 'package:mobx/mobx.dart';
import 'package:projeto_704apps/features/models/image.dart';
import 'package:projeto_704apps/services/local/image_analyze_dao_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'image_store.g.dart';

class ImageStore = _ImageStore with _$ImageStore;

abstract class _ImageStore with Store {
  @observable
  Image? image;

  final ImageAnalyzeDaoImpl imageAnalyzeDaoImpl = ImageAnalyzeDaoImpl();

  @action
  Future<Image?> registerImageAnalysis(
    List<String> paths,
    String audioTranscriptionId,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    Image? newImage = await imageAnalyzeDaoImpl.registerImageAnalysis(
      paths,
      audioTranscriptionId,
      token: token!,
    );

    if (newImage != null) {
      image = newImage;
      return newImage;
    }else{
      print('Erro ao registrar análise de imagem.');
      return null;
    }
  }
}
