module TemplateHelper

  # split the templates into rows of three for display.
  def split_templates_into_rows(templates)
    template_rows = []
    i = 1

    template_row = []
    template_rows << template_row

    templates.each do |template|
      template_row << template
      i += 1
      if i > 3
        i = 1
        template_row = []
        template_rows << template_row
      end
    end

    template_rows
  end
end
