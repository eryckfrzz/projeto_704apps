abstract class IncidentArtifact {
  Future<bool> registerArtifact(
    String incidentId,
    String fileName,
    String fileType, {
    required String token,
  });
}