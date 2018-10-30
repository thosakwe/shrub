import 'package:shrub/shrub.dart';

class AnalysisContext {
  final List<ShrubException> errors = [];
  final Module module;
  final ModuleSystemView moduleSystemView;
  final Map<String, AnalysisContext> _children = {};

  AnalysisContext(this.module, this.moduleSystemView);

  AnalysisContext child(String name) {
    return _children.putIfAbsent(name, () {
      var m = module.children.putIfAbsent(
          name,
          () => new Module(
              module, module.directory.child(name), name, module.version));
      var view = new LocalModuleSystemView(moduleSystemView, m);
      return new _ChildAnalysisContext(this, module, view);
    });
  }
}

class _ChildAnalysisContext extends AnalysisContext {
  final AnalysisContext parent;

  _ChildAnalysisContext(
      this.parent, Module module, ModuleSystemView moduleSystemView)
      : super(module, moduleSystemView);

  @override
  List<ShrubException> get errors => parent.errors;
}
