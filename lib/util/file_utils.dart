import 'dart:io';

class FileUtils {
  static Future<Directory> getProjectDirectory(String projectNumber) async {
    try {
      Directory rootDir = new Directory('/storage/emulated/0/StrucReport');
      if (!(await rootDir.exists())) {
        await rootDir.create(recursive: true);
      }
      Directory projectDir = new Directory(rootDir.path + '/' + projectNumber);
      if (!(await projectDir.exists())) projectDir.create(recursive: true);
      return projectDir;
    } catch (e) {
      return null;
    }
  }

  static Future<Directory> getProjectImageDirectory(String projectNumber) async {
    try {
      Directory projectDir = await getProjectDirectory(projectNumber);
      if (projectDir == null) return null;
      Directory imageDir = new Directory(projectDir.path + '/images');
      if (!(await imageDir.exists())) imageDir.create(recursive: true);
      return imageDir;
    } catch (e) {
      return null;
    }
  }
}