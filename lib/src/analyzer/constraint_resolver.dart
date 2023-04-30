import 'package:import_lint/src/analyzer/resource_locator.dart';
import 'package:import_lint/src/config/constraint.dart';

class ConstraintResolver {
  const ConstraintResolver(this.constraints);
  final Iterable<Constraint> constraints;

  bool isViolated(
    FilePathResourceLocator filePathResourceLocator,
    ImportLineResourceLocator importLineResourceLocator,
  ) {
    bool isTarget = false;
    bool isExcept = false;
    bool isFrom = false;
    for (final constraint in constraints) {
      if (constraint is TargetConstraint) {
        if (_matchTarget(constraint, filePathResourceLocator)) {
          isTarget = true;
        }
      } else if (constraint is ExceptConstraint) {
        if (_matchExcept(constraint, importLineResourceLocator)) {
          isExcept = true;
        }
      } else if (constraint is FromConstraint) {
        if (_matchFrom(constraint, importLineResourceLocator)) {
          isFrom = true;
        }
      }
    }

    if (isTarget && isFrom && !isExcept) {
      return true;
    }
    return false;
  }

  bool _matchTarget(TargetConstraint constraint,
          FilePathResourceLocator filePathResourceLocator) =>
      _match(constraint, filePathResourceLocator);

  bool _matchFrom(FromConstraint constraint,
          ImportLineResourceLocator importLineResourceLocator) =>
      _match(constraint, importLineResourceLocator);

  bool _matchExcept(ExceptConstraint constraint,
          ImportLineResourceLocator filePathResourceLocator) =>
      _match(constraint, filePathResourceLocator);

  bool _match(Constraint constraint, ResourceLocator resourceLocator) {
    return constraint.package == resourceLocator.package &&
        constraint.glob.matches(resourceLocator.path);
  }
}
