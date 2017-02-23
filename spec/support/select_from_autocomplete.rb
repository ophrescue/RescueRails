def select_from_autocomplete(field, options)
  page.fill_in field, with: options[:with]

  page.execute_script %Q{ $('##{field}').trigger('focus') }
  page.execute_script %Q{ $('##{field}').trigger('keydown') }
  selector = %Q{ul.ui-autocomplete li.ui-menu-item div.ui-menu-item-wrapper:contains("#{options[:with]}")}
  page.assert_selector('ul.ui-autocomplete li.ui-menu-item')
  page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
end
