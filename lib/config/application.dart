import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static SharedPreferences preferences;
  static double IconSize = 64;

  static String photoDelimiter = "^*__*^";
  static String photoElementDelimiter = "#*__*#";

  static List<String> Emails = [
    "robert.simplify@gmail.com",

  ];

  static List<String> Employees = [
    "Robert Szymborski",
    "Daniel Barber",
    "Rob Hardman",
    "Larisa Florian",
    "Muhammed Jagot"
  ];

  static List<String> InspectionType = [
    "General Structural Inspection (GSI)",
    "Specific Structural Inspection (SSI)"
  ];

  static List<String> PropertyType = [
    "Detached",
    "Semi-detached",
    "Terraced",
    "End-terraced"
  ];

  static List<String> PresentAtSite = [
    "Vendor",
    "Buyer",
    "Agent",
    "Occupier",
    "Other"
  ];

  static List<String> ExternalWallsConstruction = [
    "Solid",
    "Cavity"
  ];

  static List<String> CoverOfRoor = [
    "Tiles",
    "Slates",
    "Other"
  ];

  static List<String> NumberOfRooms = [
    "1-Bedroom property",
    "2-Bedroom property",
    "3-Bedroom property"
  ];

  static List<String> Weather = [
    "Overcast",
    "Sunny",
    "Rainy"
  ];

  static List<String> PhotoCategories = [
    "Front elevation overview",
    "Front elevation defects photos",
    "Bay window, junction of bay window and front brickwork",
    "Roof overview photos",
    "Chimney & any defects photos",
    "Right elevation photos",
    "Right elevation defects photos",
    "Left side elevation photos",
    "Left side elevation defects photos",
    "Rear elevation overview",
    "Rear side elevation defects photos",
    "Any extensions, measuring tape against wall to show thickness",
    "Site overview photos of any trees, retaining walls, slope/hill, etc",
    "Internal plaster cracks ceiling (x3) and wall (x3) and any other defects observed",
    "Internal uneven floors, ceilings",
    "Interior roof space overview photos & gable wall",
    "Interior roof space defect photos",
    "Misc. photos"
  ];

  static List<String> PhotoCaptions = [
    "Front elevation of the property",
    "Rear elevation of the property",
    "Side elevation of the property",
    "Cracked pavement",
    "Wall plaster crack",
    "Celling plaster crack",
    "Cracked render",
    "Cracked mortar joints",
    "Cracked brickwork",
    "Sagging roof rafters & purlins",
    "Peeling paint",
    "Chimney with some defective mortar joints"
  ];

  static List<String> LintelTypes = [
    "(a) Likely timber w/arch",
    "(b) Likely timber w/ soldier course",
    "(c) Unknown – not visible on outside"
  ];

  static List<String> FloorConstructions = [
    "Suspended",
    "Ground bearing",
    "Unknown"
  ];

  static List<String> FirstFloorConstructions = [
    "Timber",
    "Concrete",
    "Unknown"
  ];

  static List<String> GableWallConstructions = [
    "Load bearing masonry",
    "Concrete no fines",
    "Other"
  ];
}




















