def select_from_autocomplete(field, options)
  page.fill_in field, with: options[:with]

  page.execute_script %{ $('##{field}').trigger('focus') }
  page.execute_script %{ $('##{field}').trigger('keydown') }
  selector = %{ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper:contains("#{options[:click]}")}
  page.assert_selector('ul.ui-autocomplete li.ui-menu-item')
  page.execute_script %{ $('#{selector}').trigger('mouseenter').click() }
end
