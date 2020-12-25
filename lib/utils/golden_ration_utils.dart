import 'dart:math' as math;

/// The goilden ration constant
const phi = 1.6180339887498948482045868343656381177203091798057628621354486227052604628189024;

/// Inverse of the goilden ration
const invphi = 1 / phi;

/// Returns relation of a square side lenght to the top-level rectangle longer side in the golden ration diagram
double sequence(int index) {
  return math.pow(invphi, index);
}
