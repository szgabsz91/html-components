part of datagrid;

class DatagridTemplateManager extends TemplateManager {
  static const String SELECT_BUTTON_PLACEHOLDER = r"${datagrid:selectButton}";
  static const String SELECT_BUTTON = r"""
    <a href="#" title="View Detail" class="x-datagrid_ui-commandlink">
      <span class="x-datagrid_ui-icon x-datagrid_ui-icon-search"></span>
    </a>
  """;
  
  DatagridTemplateManager(String template) : super(template);
  
  String getSubstitutedString(Object object) {
    String record = super.getSubstitutedString(object);
    
    record = record.replaceAll(SELECT_BUTTON_PLACEHOLDER, SELECT_BUTTON);
    
    return record;
  }
}