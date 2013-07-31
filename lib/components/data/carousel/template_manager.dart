part of carousel;

class CarouselTemplateManager extends TemplateManager {
  static const String SELECT_BUTTON_PLACEHOLDER = r"${carousel:selectButton}";
  static const String SELECT_BUTTON = r"""
    <a href="#" title="View Detail" class="x-carousel_ui-commandlink">
      <span class="x-carousel_ui-icon x-carousel_ui-icon-search"></span>
    </a>
  """;
  
  CarouselTemplateManager(String template) : super(template);
  
  String getSubstitutedString(Object object) {
    String record = super.getSubstitutedString(object);
    
    record = record.replaceAll(SELECT_BUTTON_PLACEHOLDER, SELECT_BUTTON);
    
    return record;
  }
}