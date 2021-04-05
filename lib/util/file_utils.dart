import 'dart:io';

class FileUtils {
  static Future<Directory> getProjectDirectory(String projectNumber) async {
    Directory rootDir, projectDir;
    try {
      rootDir = new Directory('/storage/emulated/0/StrucChecklist');
      if (!(await rootDir.exists())) {
        await rootDir.create(recursive: true);
      }
      print("----------- in Try -----------");
    } catch (e) {
      print("----------- in Catch -----------");
      rootDir = new Directory('/storage/emulated/0/StrucChecklist');
      if (!(await rootDir.exists())) {
        await rootDir.create(recursive: true);
      }

    }
    try {
      projectDir = new Directory(rootDir.path + '/' + projectNumber);
      if (!(await projectDir.exists())) projectDir.create(recursive: true);
      return projectDir;
    } catch (e) {
      projectDir = new Directory(rootDir.path + '/' + projectNumber);
      if (!(await projectDir.exists())) projectDir.create(recursive: true);
      return projectDir;
    }
  }

  static Future<Directory> getProjectImageDirectory(String projectNumber) async {
    Directory projectDir = await getProjectDirectory(projectNumber);
    Directory imageDir;
    try {
      imageDir = new Directory(projectDir.path + '/images');
      if (!(await imageDir.exists())) imageDir.create(recursive: true);
      return imageDir;
    } catch (e) {
      imageDir = new Directory(projectDir.path + '/images');
      if (!(await imageDir.exists())) imageDir.create(recursive: true);
      return imageDir;
    }
  }
}