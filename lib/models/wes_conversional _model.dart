class WESConverter {
  static double convertToWES(double localGPA) {
    // Adjusted conversion logic based on common WES scale interpretations
    if (localGPA >= 3.7) return 4.0;
    if (localGPA >= 3.3) return 3.7;
    if (localGPA >= 3.0) return 3.3;
    if (localGPA >= 2.7) return 3.0;
    if (localGPA >= 2.3) return 2.7;
    if (localGPA >= 2.0) return 2.3;
    if (localGPA >= 1.7) return 2.0;
    if (localGPA >= 1.3) return 1.7;
    if (localGPA >= 1.0) return 1.3;
    if (localGPA > 0.0) return 1.0;
    return 0.0; // Fix: return 0.0 for local GPA of 0 or less
  }
}
