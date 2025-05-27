class University {
  final String id;
  final String name;
  final Map<String, double> gradePoints;

  University({required this.id, required this.name, required this.gradePoints});

  // Default Ghana grading scale
  static final Map<String, double> defaultGrading = {
    'A': 4.0,
    'B+': 3.5,
    'B': 3.0,
    'C+': 2.5,
    'C': 2.0,
    'D+': 1.5,
    'D': 1.0,
    'E': 0.5,
    'F': 0.0,
  };

  static final University ug = University(
    id: 'ug',
    name: '(UG)',
    gradePoints: defaultGrading,
  );

  static final University knust = University(
    id: 'knust',
    name: ' (KNUST)',
    gradePoints: defaultGrading,
  );

  static final University umat = University(
    id: 'umat',
    name: '(UMaT)',
    gradePoints: defaultGrading,
  );

  static final University ucc = University(
    id: 'ucc',
    name: ' (UCC)',
    gradePoints: defaultGrading,
  );

  static final University uenr = University(
    id: 'uenr',
    name: ' (UENR)',
    gradePoints: defaultGrading,
  );

  static final University gctu = University(
    id: 'gctu',
    name: ' (GCTU)',
    gradePoints: defaultGrading,
  );

  static final University upsa = University(
    id: 'upsa',
    name: '(UPSA)',
    gradePoints: defaultGrading,
  );

  static final University uhas = University(
    id: 'uhas',
    name: ' (UHAS)',
    gradePoints: defaultGrading,
  );

  static final University uew = University(
    id: 'uew',
    name: '(UEW)',
    gradePoints: defaultGrading,
  );

  static final University ckTedam = University(
    id: 'ckt',
    name: '(CKT-UTAS)',
    gradePoints: defaultGrading,
  );

  static final University sdd = University(
    id: 'sdd',
    name: ' (KAFF)',
    gradePoints: defaultGrading,
  );

  static final University aamusted = University(
    id: 'aamusted',
    name: ' (AAMUSTED)',
    gradePoints: defaultGrading,
  );

  // ✅ Full list of public universities in Ghana
  static final List<University> all = [
    ug,
    knust,
    umat,
    ucc,
    uenr,
    gctu,
    upsa,
    uhas,
    uew,
    ckTedam,
    sdd,
    aamusted,
  ];
}
