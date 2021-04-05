import 'package:shared_preferences/shared_preferences.dart';

class Application {
  static SharedPreferences preferences;
  static double IconSize = 64;

  static String photoDelimiter = "^*__*^";
  static String photoElementDelimiter = "#*__*#";

  static List<String> Emails = [
    "robert.simplify@gmail.com",
    /*"selivestrovdanil47@gmail.com"*/

  ];

  static List<String> Employees = [
    "N/A",
    "Robert Szymborski",
    "Daniel Barber",
    "Rob Hardman",
    "Larisa Florian",
    "Muhammed Jagot",
    "Stephen Swatman",
    "Tim Bolojan"
  ];

  static List<String> InspectionType = [
    "N/A",
    "General Structural Inspection (GSI)",
    "Specific Structural Inspection (SSI)"
  ];

  static List<String> PropertyType = [
    "N/A",
    "Detached house",
    "Semi-detached house",
    "Terraced house",
    "End-terraced house",
    "Residential multi-unit",
    "Commercial portal frame",
    "Commercial masonry"
  ];

  static List<String> PurposeOfSiteVisit = [
    "N/A",
    "Pre-purchase report",
    "Alterations without plans – indicative structural plan & calculations",
    "Alterations with plans – structural mark-ups & calculations",
    "New construction",
    "Site visit only to define requirements"
  ];

  static List<String> PresentAtSite = [
    "N/A",
    "Vendor",
    "Buyer",
    "Agent",
    "Occupier",
    "Other"
  ];

  static List<String> ExternalWallsConstruction = [
    "N/A",
    "Solid",
    "Cavity"
  ];

  static List<String> CoverOfRoof = [
    "N/A",
    "Tiles",
    "Slates",
    "Other"
  ];

  static List<String> NumberOfRooms = [
    "N/A",
    "1-Bedroom property",
    "2-Bedroom property",
    "3-Bedroom property",
    "Other"
  ];

  static List<String> AnyReportDrawingSketch = [
    "N/A",
    "Surveyor’s report provided",
    "Architectural drawings provided",
    "Sketches/ indicative drawings provided"
  ];

  static List<String> Weather = [
    "N/A",
    "Overcast",
    "Sunny",
    "Rainy"
  ];

  static List<String> PhotoCategories = [
    "Appointment notes screenshot",
    "Front elevation overview",
    "Front elevation defect photos",
    "Continuation, front elevation defect photos",
    "Bay window, junction of bay window and front brickwork",
    "Roof overview photos",
    "Chimney & any defects photos",
    "Right elevation photos",
    "Right elevation defects photos",
    "Left side elevation photos",
    "Left side elevation defects photos",
    "Rear elevation overview",
    "Rear elevation defect photos",
    "Continuation, rear elevation defect photos",
    "Eternal cracks above windows/doors photos",
    "Internal cracks above windows/doors photos",
    "Any extensions, measuring tape against wall to show thickness",
    "Site overview photos of any trees, retaining walls, slope/hill, etc",
    "Continuation, site overview photos",
    "Internal cracks",
    "Continuation, internal cracks photos",
    "Internal defects",
    "Continuation, internal defects photos",
    "Internal uneven floors, ceilings",
    "Interior roof space overview photos & gable wall",
    "Interior roof space defect photos",
    "Misc. photos",
    "If applicable, floorboards or joists span photos",
    "If applicable, plan screenshot"
  ];

  static List<String> PhotoCaptions = [
    "Front elevation of the property",
    "Rear elevation of the property",
    "Side elevation of the property",
    "Cracked pavement",
    "Wall plaster crack",
    "Ceiling plaster crack",
    "Cracked render",
    "Cracked mortar joints",
    "Cracked brickwork",
    "Sagging roof rafters & purlins",
    "Peeling paint",
    "Chimney with some defective mortar joints"
  ];

  static List<String> LintelTypes = [
    "N/A",
    "(a) Likely timber w/arch",
    "(b) Likely timber w/ soldier course",
    "(c) Unknown – not visible on outside"
  ];

  static List<String> FloorConstructions = [
    "N/A",
    "Suspended",
    "Ground bearing",
    "Unknown"
  ];

  static List<String> FirstFloorConstructions = [
    "N/A",
    "Timber",
    "Concrete",
    "Unknown"
  ];

  static List<String> GableWallConstructions = [
    "N/A",
    "Load bearing masonry",
    "Concrete no fines",
    "Other"
  ];

  static List<String> SizeLargestInternalCrack = [
    "N/A",
    "0 - Hairline cracks less than 0.1mm",
    "1 - Fine cracks of up to 1mm",
    "2 - Crack widths up to 5mm",
    "3 - Crack widths of 5 to 15mm (or several of e.g. 3mm)",
    "4 - Extensive damage, cracks 15 to 25mm"
  ];

  static List<String> SizeLargestExternalCrack = [
    "N/A",
    "0 - Hairline cracks less than 0.1mm",
    "1 - Fine cracks of up to 1mm",
    "2 - Crack widths up to 5mm",
    "3 - Crack widths of 5 to 15mm (or several of e.g. 3mm)",
    "4 - Extensive damage, cracks 15 to 25mm"
  ];
}





















